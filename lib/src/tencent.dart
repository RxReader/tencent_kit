import 'dart:async';

import 'package:fake_tencent/src/domain/tencent_login_resp.dart';
import 'package:fake_tencent/src/domain/tencent_share_resp.dart';
import 'package:fake_tencent/src/domain/tencent_user_info_resp.dart';
import 'package:fake_tencent/src/tencent_qzone_flag.dart';
import 'package:fake_tencent/src/tencent_scene.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Tencent {
  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISQQINSTALLED = 'isQQInstalled';
  static const String _METHOD_ISQQSUPPORTSSOLOGIN = 'isQQSupportSSOLogin';
  static const String _METHOD_LOGIN = 'login';
  static const String _METHOD_LOGOUT = 'logout';
  static const String _METHOD_GETUSERINFO = 'getUserInfo';
  static const String _METHOD_SHAREMOOD = 'shareMood';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _METHOD_ONLOGINRESP = 'onLoginResp';
  static const String _METHOD_ONGETUSERINFORESP = 'onGetUserInfoResp';
  static const String _METHOD_ONSHARERESP = "onShareResp";

  static const String _ARGUMENT_KEY_APPID = 'appId';
  static const String _ARGUMENT_KEY_SCOPE = 'scope';
  static const String _ARGUMENT_KEY_OPENID = 'openId';
  static const String _ARGUMENT_KEY_ACCESSTOKEN = 'accessToken';
  static const String _ARGUMENT_KEY_EXPIRESIN = 'expiresIn';
  static const String _ARGUMENT_KEY_CREATEAT = 'createAt';
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

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/fake_tencent');

  final StreamController<TencentLoginResp> _loginRespStreamController =
      StreamController<TencentLoginResp>.broadcast();

  final StreamController<TencentUserInfoResp> _userInfoRespStreamController =
      StreamController<TencentUserInfoResp>.broadcast();

  final StreamController<TencentShareResp> _shareRespStreamController =
      StreamController<TencentShareResp>.broadcast();

  Future<void> registerApp({
    @required String appId,
  }) {
    assert(appId != null && appId.isNotEmpty);
    _channel.setMethodCallHandler(_handleMethod);
    return _channel.invokeMethod(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
      },
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONLOGINRESP:
        _loginRespStreamController.add(TencentLoginRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONGETUSERINFORESP:
        _userInfoRespStreamController.add(TencentUserInfoRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
      case _METHOD_ONSHARERESP:
        _shareRespStreamController.add(TencentShareRespSerializer()
            .fromMap(call.arguments as Map<dynamic, dynamic>));
        break;
    }
  }

  Stream<TencentLoginResp> loginResp() {
    return _loginRespStreamController.stream;
  }

  Stream<TencentUserInfoResp> userInfoResp() {
    return _userInfoRespStreamController.stream;
  }

  Stream<TencentShareResp> shareResp() {
    return _shareRespStreamController.stream;
  }

  Future<bool> isQQInstalled() async {
    return (await _channel.invokeMethod(_METHOD_ISQQINSTALLED)) as bool;
  }

  Future<bool> isQQSupportSSOLogin() async {
    return (await _channel.invokeMethod(_METHOD_ISQQSUPPORTSSOLOGIN)) as bool;
  }

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

  Future<void> logout() {
    return _channel.invokeMethod(_METHOD_LOGOUT);
  }

  Future<void> getUserInfo({
    @required String openId,
    @required String accessToken,
    @required int expiresIn,
    @required int createAt,
  }) {
    assert(openId != null && openId.isNotEmpty);
    assert(accessToken != null && accessToken.isNotEmpty);
    assert(expiresIn != null && expiresIn > 0);
    return _channel.invokeMethod(
      _METHOD_GETUSERINFO,
      <String, dynamic>{
        _ARGUMENT_KEY_OPENID: openId,
        _ARGUMENT_KEY_ACCESSTOKEN: accessToken,
        _ARGUMENT_KEY_EXPIRESIN: expiresIn,
        _ARGUMENT_KEY_CREATEAT: createAt,
      },
    );
  }

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
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURIS: imageUris != null ? new List.generate(imageUris.length, (int index) {
//        return imageUris[index].toString();
//      }) : null,
//      _ARGUMENT_KEY_VIDEOURI: videoUri != null ? videoUri.toString() : null,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_SUMMARY, () => summary);
    }
    if (imageUris != null && imageUris.isNotEmpty) {
      map.putIfAbsent(
          _ARGUMENT_KEY_IMAGEURIS,
          () => List<String>.generate(imageUris.length, (int index) {
                return imageUris[index].toString();
              }));
    }
    if (videoUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_VIDEOURI, () => videoUri.toString());
    }
    return _channel.invokeMethod(_METHOD_SHAREMOOD, map);
  }

  Future<void> shareImage({
    @required int scene,
    @required Uri imageUri,
    String appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREIMAGE, map);
  }

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
    Map<String, dynamic> map = <String, dynamic>{
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
      map.putIfAbsent(_ARGUMENT_KEY_SUMMARY, () => summary);
    }
    if (imageUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_IMAGEURI, () => imageUri.toString());
    }
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREMUSIC, map);
  }

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
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURI: imageUri != null ? imageUri.toString() : null,
      _ARGUMENT_KEY_TARGETURL: targetUrl,
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    if (imageUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_IMAGEURI, () => imageUri.toString());
    }
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREWEBPAGE, map);
  }
}
