import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tencent_kit/src/constant.dart';
import 'package:tencent_kit/src/model/resp.dart';
import 'package:tencent_kit/src/tencent_kit_method_channel.dart';

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

  /// 设置是否已授权获取设备信息/是否同意隐私协议
  Future<void> setIsPermissionGranted({
    required bool granted,
    String? buildModel /* android.os.Build.MODEL */,
  }) {
    throw UnimplementedError(
        'setIsPermissionGranted({required granted, buildModel}) has not been implemented.');
  }

  /// 向 Open_SDK 注册
  Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) {
    throw UnimplementedError(
        'registerApp({required appId, universalLink}) has not been implemented.');
  }

  ///
  Stream<TencentResp> respStream() {
    throw UnimplementedError('respStream() has not been implemented.');
  }

  /// 检查QQ是否已安装
  Future<bool> isQQInstalled() {
    throw UnimplementedError('isQQInstalled() has not been implemented.');
  }

  /// 检查QQ是否已安装
  Future<bool> isTIMInstalled() {
    throw UnimplementedError('isTIMInstalled() has not been implemented.');
  }

  /// 登录
  Future<void> login({
    required List<String> scope,
  }) {
    throw UnimplementedError(
        'login({required scope}) has not been implemented.');
  }

  /// 登录（Server-Side）
  Future<void> loginServerSide({
    required List<String> scope,
  }) {
    throw UnimplementedError(
        'loginServerSide({required scope}) has not been implemented.');
  }

  /// 登出
  Future<void> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  /// 分享 - 说说
  Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    throw UnimplementedError(
        'shareMood({required scene, summary, imageUris, videoUri}) has not been implemented.');
  }

  /// 分享 - 文本（Android调用的是系统API，故而不会有回调）
  Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    throw UnimplementedError(
        'shareText({required scene, required summary}) has not been implemented.');
  }

  /// 分享 - 图片
  Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.kDefault,
  }) {
    throw UnimplementedError(
        'shareImage({required scene, required imageUri, appName, extInt}) has not been implemented.');
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
    int extInt = TencentQZoneFlag.kDefault,
  }) {
    throw UnimplementedError(
        'shareMusic({required scene, required title, summary, imageUri, required musicUrl, required targetUrl, appName, extInt}) has not been implemented.');
  }

  /// 分享 - 网页
  Future<void> shareWebpage({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.kDefault,
  }) {
    throw UnimplementedError(
        'shareWebpage({required scene, required title, summary, imageUri, required targetUrl, appName, extInt}) has not been implemented.');
  }
}
