import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tencent_kit/src/model/resp.dart';
import 'package:tencent_kit/src/tencent_constant.dart';

import 'tencent_kit_method_channel.dart';

abstract class TencentKitPlatform extends PlatformInterface {
  /// Constructs a TencentKitPlatform.
  TencentKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static TencentKitPlatform _instance = MethodChannelTencentKit();

  /// The default instance of [TencentKitPlatform] to use.
  ///
  /// Defaults to [MethodChannelTencentKit].
  static TencentKitPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TencentKitPlatform] when
  /// they register themselves.
  static set instance(TencentKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setIsPermissionGranted({
    required bool granted,
    String? buildModel /* android.os.Build.MODEL */,
  }) {
    throw UnimplementedError(
        'setIsPermissionGranted({required granted, buildModel}) has not been implemented.');
  }

  Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) {
    throw UnimplementedError(
        'registerApp({required appId, universalLink}) has not been implemented.');
  }

  Future<bool> isQQInstalled() {
    throw UnimplementedError('isQQInstalled() has not been implemented.');
  }

  Future<bool> isTIMInstalled() {
    throw UnimplementedError('isTIMInstalled() has not been implemented.');
  }

  Stream<BaseResp> respStream() {
    throw UnimplementedError('respStream() has not been implemented.');
  }

  Future<void> login({
    required List<String> scope,
  }) {
    throw UnimplementedError(
        'login({required scope}) has not been implemented.');
  }

  Future<void> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    throw UnimplementedError(
        'shareMood({required scene, summary, imageUris, videoUri}) has not been implemented.');
  }

  Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    throw UnimplementedError(
        'shareText({required scene, required summary}) has not been implemented.');
  }

  Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    throw UnimplementedError(
        'shareImage({required scene, required imageUri, appName, extInt}) has not been implemented.');
  }

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
    throw UnimplementedError(
        'shareMusic({required scene, required title, summary, imageUri, required musicUrl, required targetUrl, appName, extInt}) has not been implemented.');
  }

  Future<void> shareWebpage({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    throw UnimplementedError(
        'shareWebpage({required scene, required title, summary, imageUri, required targetUrl, appName, extInt}) has not been implemented.');
  }
}
