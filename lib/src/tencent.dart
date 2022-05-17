import 'package:tencent_kit/src/model/resp.dart';
import 'package:tencent_kit/src/tencent_constant.dart';
import 'package:tencent_kit/src/tencent_kit_platform_interface.dart';

class Tencent {
  Tencent._();

  /// 设置是否已授权获取设备信息/是否同意隐私协议
  static Future<void> setIsPermissionGranted({
    required bool granted,
    String? buildModel /* android.os.Build.MODEL */,
  }) {
    return TencentKitPlatform.instance.setIsPermissionGranted(
      granted: granted,
      buildModel: buildModel,
    );
  }

  /// 向 Open_SDK 注册
  static Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) {
    return TencentKitPlatform.instance.registerApp(
      appId: appId,
      universalLink: universalLink,
    );
  }

  /// 检查QQ是否已安装
  static Future<bool> isQQInstalled() {
    return TencentKitPlatform.instance.isQQInstalled();
  }

  /// 检查QQ是否已安装
  static Future<bool> isTIMInstalled() {
    return TencentKitPlatform.instance.isTIMInstalled();
  }

  ///
  static Stream<BaseResp> respStream() {
    return TencentKitPlatform.instance.respStream();
  }

  /// 登录
  static Future<void> login({
    required List<String> scope,
  }) {
    return TencentKitPlatform.instance.login(scope: scope);
  }

  /// 登出
  static Future<void> logout() {
    return TencentKitPlatform.instance.logout();
  }

  /// 分享 - 说说
  static Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    return TencentKitPlatform.instance.shareMood(
      scene: scene,
      summary: summary,
      imageUris: imageUris,
      videoUri: videoUri,
    );
  }

  /// 分享 - 文本（Android调用的是系统API，故而不会有回调）
  static Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    return TencentKitPlatform.instance.shareText(
      scene: scene,
      summary: summary,
    );
  }

  /// 分享 - 图片
  static Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    return TencentKitPlatform.instance.shareImage(
      scene: scene,
      imageUri: imageUri,
      appName: appName,
      extInt: extInt,
    );
  }

  /// 分享 - 音乐
  static Future<void> shareMusic({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String musicUrl,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    return TencentKitPlatform.instance.shareMusic(
      scene: scene,
      title: title,
      summary: summary,
      imageUri: imageUri,
      musicUrl: musicUrl,
      targetUrl: targetUrl,
      appName: appName,
      extInt: extInt,
    );
  }

  /// 分享 - 网页
  static Future<void> shareWebpage({
    required int scene,
    required String title,
    String? summary,
    Uri? imageUri,
    required String targetUrl,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    return TencentKitPlatform.instance.shareWebpage(
      scene: scene,
      title: title,
      summary: summary,
      imageUri: imageUri,
      targetUrl: targetUrl,
      appName: appName,
      extInt: extInt,
    );
  }
}
