import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tencent_kit/src/model/tencent_login_resp.dart';
import 'package:tencent_kit/src/model/tencent_sdk_resp.dart';
import 'package:tencent_kit/src/tencent_constant.dart';

///
class Tencent {
  ///
  Tencent._();

  static Tencent get instance => _instance;

  static final Tencent _instance = Tencent._();

  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISQQINSTALLED = 'isQQInstalled';
  static const String _METHOD_ISTIMINSTALLED = 'isTIMInstalled';
  static const String _METHOD_LOGIN = 'login';
  static const String _METHOD_LOGOUT = 'logout';
  static const String _METHOD_SHAREMOOD = 'shareMood';
  static const String _METHOD_SHARETEXT = 'shareText';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _METHOD_ONLOGINRESP = 'onLoginResp';
  static const String _METHOD_ONSHARERESP = 'onShareResp';

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

  late final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/tencent_kit')
        ..setMethodCallHandler(_handleMethod);

  final StreamController<TencentLoginResp> _loginRespStreamController =
      StreamController<TencentLoginResp>.broadcast();

  final StreamController<TencentSdkResp> _shareRespStreamController =
      StreamController<TencentSdkResp>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONLOGINRESP:
        _loginRespStreamController.add(TencentLoginResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
      case _METHOD_ONSHARERESP:
        _shareRespStreamController.add(TencentSdkResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
    }
  }

  /// 向 Open_SDK 注册
  Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
        if (universalLink?.isNotEmpty ?? false)
          _ARGUMENT_KEY_UNIVERSALLINK: universalLink,
      },
    );
  }

  /// 登录
  Stream<TencentLoginResp> loginResp() {
    return _loginRespStreamController.stream;
  }

  /// 分享
  Stream<TencentSdkResp> shareResp() {
    return _shareRespStreamController.stream;
  }

  /// 检查QQ是否已安装
  Future<bool> isQQInstalled() async {
    return await _channel.invokeMethod<bool>(_METHOD_ISQQINSTALLED) ?? false;
  }

  /// 检查QQ是否已安装
  Future<bool> isTIMInstalled() async {
    return await _channel.invokeMethod<bool>(_METHOD_ISTIMINSTALLED) ?? false;
  }

  /// 登录
  Future<void> login({
    required List<String> scope,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_LOGIN,
      <String, dynamic>{
        _ARGUMENT_KEY_SCOPE: scope.join(','),
      },
    );
  }

  /// 登出
  Future<void> logout() {
    return _channel.invokeMethod<void>(_METHOD_LOGOUT);
  }

  /// 分享 - 说说
  Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    assert(scene == TencentScene.SCENE_QZONE);
    assert((summary?.isNotEmpty ?? false) ||
        ((imageUris?.isNotEmpty ?? false) &&
            imageUris!
                .every((Uri element) => element.isScheme(_SCHEME_FILE))) ||
        (videoUri != null && videoUri.isScheme(_SCHEME_FILE)));
    return _channel.invokeMethod<void>(
      _METHOD_SHAREMOOD,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        if (summary?.isNotEmpty ?? false) _ARGUMENT_KEY_SUMMARY: summary,
        if (imageUris?.isNotEmpty ?? false)
          _ARGUMENT_KEY_IMAGEURIS:
              imageUris!.map((Uri imageUri) => imageUri.toString()).toList(),
        if (videoUri != null) _ARGUMENT_KEY_VIDEOURI: videoUri.toString(),
      },
    );
  }

  /// 分享 - 文本（Android调用的是系统API，故而不会有回调）
  Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    return _channel.invokeMethod<void>(
      _METHOD_SHARETEXT,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        _ARGUMENT_KEY_SUMMARY: summary,
      },
    );
  }

  /// 分享 - 图片
  Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    assert(imageUri.isScheme(_SCHEME_FILE));
    return _channel.invokeMethod<void>(
      _METHOD_SHAREIMAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
        if (appName?.isNotEmpty ?? false) _ARGUMENT_KEY_APPNAME: appName,
        _ARGUMENT_KEY_EXTINT: extInt,
      },
    );
  }

  /// 分享 - 音乐
  Future<void> shareMusic({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String musicUrl,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    return _channel.invokeMethod<void>(
      _METHOD_SHAREMUSIC,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        _ARGUMENT_KEY_TITLE: title,
        if (summary?.isNotEmpty ?? false) _ARGUMENT_KEY_SUMMARY: summary,
        if (imageUri != null) _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
        _ARGUMENT_KEY_MUSICURL: musicUrl,
        _ARGUMENT_KEY_TARGETURL: targetUrl,
        if (appName?.isNotEmpty ?? false) _ARGUMENT_KEY_APPNAME: appName,
        _ARGUMENT_KEY_EXTINT: extInt,
      },
    );
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    return _channel.invokeMethod<void>(
      _METHOD_SHAREWEBPAGE,
      <String, dynamic>{
        _ARGUMENT_KEY_SCENE: scene,
        _ARGUMENT_KEY_TITLE: title,
        if (summary?.isNotEmpty ?? false) _ARGUMENT_KEY_SUMMARY: summary,
        if (imageUri != null) _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
        _ARGUMENT_KEY_TARGETURL: targetUrl,
        if (appName?.isNotEmpty ?? false) _ARGUMENT_KEY_APPNAME: appName,
        _ARGUMENT_KEY_EXTINT: extInt,
      },
    );
  }
}
