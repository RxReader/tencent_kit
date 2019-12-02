import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tencent_kit/src/model/api/tencent_user_info_resp.dart';
import 'package:tencent_kit/src/model/sdk/tencent_login_resp.dart';
import 'package:tencent_kit/src/model/sdk/tencent_share_resp.dart';
import 'package:tencent_kit/src/model/unionid/tencent_unionid_resp.dart';
import 'package:tencent_kit/src/tencent_constant.dart';

///
class Tencent {
  ///
  Tencent() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISINSTALLED = 'isInstalled';
  static const String _METHOD_LOGIN = 'login';
  static const String _METHOD_LOGOUT = 'logout';
  static const String _METHOD_SHAREMOOD = 'shareMood';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _METHOD_ONLOGINRESP = 'onLoginResp';
  static const String _METHOD_ONSHARERESP = "onShareResp";

  static const String _ARGUMENT_KEY_APPID = 'appId';
  static const String _ARGUMENT_KEY_UNIVERSALLINK = 'universalLink';
  static const String _ARGUMENT_KEY_SCOPE = 'scope';
  static const String _ARGUMENT_KEY_SCENE = 'scene';
  static const String _ARGUMENT_KEY_TITLE = 'title';
  static const String _ARGUMENT_KEY_SUMMARY = 'summary';
  static const String _ARGUMENT_KEY_IMAGEURI = 'imageUri';
  static const String _ARGUMENT_KEY_IMAGEURIS = 'imageUris';
  static const String _ARGUMENT_KEY_VIDEOURI = 'videoUri';
  static const String _ARGUMENT_KEY_MUSICURL = 'musicUrl';
  static const String _ARGUMENT_KEY_TARGETURL = 'targetUrl';
  static const String _ARGUMENT_KEY_APPNAME = 'appName';
  static const String _ARGUMENT_KEY_EXTINT = 'extInt';

  static const String _SCHEME_FILE = 'file';

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/tencent_kit');

  final StreamController<TencentLoginResp> _loginRespStreamController =
      StreamController<TencentLoginResp>.broadcast();

  final StreamController<TencentShareResp> _shareRespStreamController =
      StreamController<TencentShareResp>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONLOGINRESP:
        _loginRespStreamController.add(
            TencentLoginResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONSHARERESP:
        _shareRespStreamController.add(
            TencentShareResp.fromJson(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  /// 向 Open_SDK 注册
  Future<void> registerApp({
    @required String appId,
    String universalLink,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(
        !Platform.isIOS || (universalLink != null && universalLink.isNotEmpty));
    final Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_APPID: appId,
//      _ARGUMENT_KEY_UNIVERSALLINK: universalLink,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (universalLink != null) {
      arguments[_ARGUMENT_KEY_UNIVERSALLINK] = universalLink;
    }
    return _channel.invokeMethod(_METHOD_REGISTERAPP, arguments);
  }

  /// 登录
  Stream<TencentLoginResp> loginResp() {
    return _loginRespStreamController.stream;
  }

  /// 分享
  Stream<TencentShareResp> shareResp() {
    return _shareRespStreamController.stream;
  }

  /// 检查QQ是否已安装
  Future<bool> isInstalled() async {
    return _channel.invokeMethod(_METHOD_ISINSTALLED);
  }

  /// 登录
  Future<void> login({
    @required List<String> scope,
  }) {
    assert(scope != null && scope.isNotEmpty);
    return _channel.invokeMethod(
      _METHOD_LOGIN,
      <String, dynamic>{
        _ARGUMENT_KEY_SCOPE: scope.join(','),
      },
    );
  }

  /// 登出
  Future<void> logout() {
    return _channel.invokeMethod(_METHOD_LOGOUT);
  }

  /// 用户信息
  /// https://wiki.connect.qq.com/get_user_info
  Future<TencentUserInfoResp> getUserInfo({
    @required String appId,
    @required String openid,
    @required String accessToken,
  }) {
    assert(appId != null && appId.isNotEmpty);
    assert(openid != null && openid.isNotEmpty);
    assert(accessToken != null && accessToken.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://graph.qq.com/user/get_user_info?access_token=$accessToken&oauth_consumer_key=$appId&openid=$openid'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        ContentType contentType = response.headers.contentType;
        Encoding encoding = Encoding.getByName(contentType?.charset) ?? utf8;
        String content = await encoding.decodeStream(response);
        return TencentUserInfoResp.fromJson(
            json.decode(content) as Map<dynamic, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// UnionID
  /// https://wiki.connect.qq.com/unionid%E4%BB%8B%E7%BB%8D
  Future<TencentUnionidResp> getUnionId({
    @required String accessToken,
    String unionid = '1',
  }) {
    assert(accessToken != null && accessToken.isNotEmpty);
    return HttpClient()
        .getUrl(Uri.parse(
            'https://graph.qq.com/oauth2.0/me?access_token=$accessToken&unionid=$unionid'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        ContentType contentType = response.headers.contentType;
        Encoding encoding = Encoding.getByName(contentType?.charset) ?? utf8;
        String callback = await encoding.decodeStream(response);
        // 腾讯有毒 callback( $json );
        RegExp exp = RegExp(r'callback\( (.*) \)\;');
        Match match = exp.firstMatch(callback);
        if (match.groupCount == 1) {
          String content = match.group(1);
          return TencentUnionidResp.fromJson(
              json.decode(content) as Map<dynamic, dynamic>);
        }
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// 分享 - 说说
  Future<void> shareMood({
    @required int scene,
    String summary,
    List<Uri> imageUris,
    Uri videoUri,
  }) {
    assert(scene == TencentScene.SCENE_QZONE);
    assert((summary != null && summary.isNotEmpty) ||
        (imageUris != null && imageUris.isNotEmpty) ||
        (videoUri != null && videoUri.isScheme(_SCHEME_FILE)));
    if (imageUris != null && imageUris.isNotEmpty) {
      imageUris.forEach((Uri imageUri) {
        assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
      });
    }
    final Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURIS: imageUris != null ? new List.generate(imageUris.length, (int index) {
//        return imageUris[index].toString();
//      }) : null,
//      _ARGUMENT_KEY_VIDEOURI: videoUri != null ? videoUri.toString() : null,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      arguments[_ARGUMENT_KEY_SUMMARY] = summary;
    }
    if (imageUris != null && imageUris.isNotEmpty) {
      arguments[_ARGUMENT_KEY_IMAGEURIS] =
          imageUris.map((Uri imageUri) => imageUri.toString()).toList();
    }
    if (videoUri != null) {
      arguments[_ARGUMENT_KEY_VIDEOURI] = videoUri.toString();
    }
    return _channel.invokeMethod(_METHOD_SHAREMOOD, arguments);
  }

  /// 分享 - 图片
  Future<void> shareImage({
    @required int scene,
    @required Uri imageUri,
    String appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
    final Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (appName != null && appName.isNotEmpty) {
      arguments[_ARGUMENT_KEY_APPNAME] = appName;
    }
    return _channel.invokeMethod(_METHOD_SHAREIMAGE, arguments);
  }

  /// 分享 - 音乐
  Future<void> shareMusic({
    @required int scene,
    @required String title,
    String summary,
    Uri imageUri,
    @required String musicUrl,
    @required String targetUrl,
    String appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    assert(title != null && title.isNotEmpty);
    assert(musicUrl != null && musicUrl.isNotEmpty);
    assert(targetUrl != null && targetUrl.isNotEmpty);
    final Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURI: imageUri != null ? imageUri.toString() : null,
      _ARGUMENT_KEY_MUSICURL: musicUrl,
      _ARGUMENT_KEY_TARGETURL: targetUrl,
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      arguments[_ARGUMENT_KEY_SUMMARY] = summary;
    }
    if (imageUri != null) {
      arguments[_ARGUMENT_KEY_IMAGEURI] = imageUri.toString();
    }
    if (appName != null && appName.isNotEmpty) {
      arguments[_ARGUMENT_KEY_APPNAME] = appName;
    }
    return _channel.invokeMethod(_METHOD_SHAREMUSIC, arguments);
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    @required int scene,
    @required String title,
    String summary,
    Uri imageUri,
    @required String targetUrl,
    String appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(title != null && title.isNotEmpty);
    assert(targetUrl != null && targetUrl.isNotEmpty);
    final Map<String, dynamic> arguments = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURI: imageUri != null ? imageUri.toString() : null,
      _ARGUMENT_KEY_TARGETURL: targetUrl,
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      arguments[_ARGUMENT_KEY_SUMMARY] = summary;
    }
    if (imageUri != null) {
      arguments[_ARGUMENT_KEY_IMAGEURI] = imageUri.toString();
    }
    if (appName != null && appName.isNotEmpty) {
      arguments[_ARGUMENT_KEY_APPNAME] = appName;
    }
    return _channel.invokeMethod(_METHOD_SHAREWEBPAGE, arguments);
  }
}
