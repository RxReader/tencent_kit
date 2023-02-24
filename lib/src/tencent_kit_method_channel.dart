import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tencent_kit/src/constant.dart';
import 'package:tencent_kit/src/model/resp.dart';
import 'package:tencent_kit/src/tencent_kit_platform_interface.dart';

/// An implementation of [TencentKitPlatform] that uses method channels.
class MethodChannelTencentKit extends TencentKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel =
      const MethodChannel('v7lin.github.io/tencent_kit')
        ..setMethodCallHandler(_handleMethod);

  final StreamController<BaseResp> _respStreamController =
      StreamController<BaseResp>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onLoginResp':
        _respStreamController.add(LoginResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
      case 'onShareResp':
        _respStreamController.add(ShareMsgResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
    }
  }

  @override
  Future<void> setIsPermissionGranted({
    required bool granted,
    String? buildModel /* android.os.Build.MODEL */,
  }) {
    return methodChannel.invokeMethod(
      'setIsPermissionGranted',
      <String, dynamic>{
        'granted': granted,
        if (buildModel?.isNotEmpty ?? false) 'build_model': buildModel,
      },
    );
  }

  @override
  Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) {
    return methodChannel.invokeMethod<void>(
      'registerApp',
      <String, dynamic>{
        'appId': appId,
        if (universalLink?.isNotEmpty ?? false) 'universalLink': universalLink,
      },
    );
  }

  @override
  Stream<BaseResp> respStream() {
    return _respStreamController.stream;
  }

  @override
  Future<bool> isQQInstalled() async {
    return await methodChannel.invokeMethod<bool>('isQQInstalled') ?? false;
  }

  @override
  Future<bool> isTIMInstalled() async {
    return await methodChannel.invokeMethod<bool>('isTIMInstalled') ?? false;
  }

  @override
  Future<void> login({
    required List<String> scope,
  }) {
    return methodChannel.invokeMethod<void>(
      'login',
      <String, dynamic>{
        'scope': scope.join(','),
      },
    );
  }

  @override
  Future<void> logout() {
    return methodChannel.invokeMethod<void>('logout');
  }

  @override
  Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    assert(scene == TencentScene.SCENE_QZONE);
    assert((summary?.isNotEmpty ?? false) ||
        ((imageUris?.isNotEmpty ?? false) &&
            imageUris!.every((Uri element) => element.isScheme('file'))) ||
        (videoUri != null && videoUri.isScheme('file')));
    return methodChannel.invokeMethod<void>(
      'shareMood',
      <String, dynamic>{
        'scene': scene,
        if (summary?.isNotEmpty ?? false) 'summary': summary,
        if (imageUris?.isNotEmpty ?? false)
          'imageUris':
              imageUris!.map((Uri imageUri) => imageUri.toString()).toList(),
        if (videoUri != null) 'videoUri': videoUri.toString(),
      },
    );
  }

  @override
  Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    return methodChannel.invokeMethod<void>(
      'shareText',
      <String, dynamic>{
        'scene': scene,
        'summary': summary,
      },
    );
  }

  @override
  Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == TencentScene.SCENE_QQ);
    assert(imageUri.isScheme('file'));
    return methodChannel.invokeMethod<void>(
      'shareImage',
      <String, dynamic>{
        'scene': scene,
        'imageUri': imageUri.toString(),
        if (appName?.isNotEmpty ?? false) 'appName': appName,
        'extInt': extInt,
      },
    );
  }

  @override
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
    return methodChannel.invokeMethod<void>(
      'shareMusic',
      <String, dynamic>{
        'scene': scene,
        'title': title,
        if (summary?.isNotEmpty ?? false) 'summary': summary,
        if (imageUri != null) 'imageUri': imageUri.toString(),
        'musicUrl': musicUrl,
        'targetUrl': targetUrl,
        if (appName?.isNotEmpty ?? false) 'appName': appName,
        'extInt': extInt,
      },
    );
  }

  @override
  Future<void> shareWebpage({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    return methodChannel.invokeMethod<void>(
      'shareWebpage',
      <String, dynamic>{
        'scene': scene,
        'title': title,
        if (summary?.isNotEmpty ?? false) 'summary': summary,
        if (imageUri != null) 'imageUri': imageUri.toString(),
        'targetUrl': targetUrl,
        if (appName?.isNotEmpty ?? false) 'appName': appName,
        'extInt': extInt,
      },
    );
  }
}
