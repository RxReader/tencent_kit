import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:tencent_kit/src/constant.dart';
import 'package:tencent_kit/src/model/resp.dart';
import 'package:tencent_kit/src/tencent_kit_method_channel.dart';
import 'package:tencent_kit/src/tencent_kit_platform_interface.dart';

class MockTencentKitPlatform
    with MockPlatformInterfaceMixin
    implements TencentKitPlatform {
  @override
  Future<void> setIsPermissionGranted({
    required bool granted,
    String? buildModel,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> registerApp({
    required String appId,
    String? universalLink,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<bool> isQQInstalled() {
    return Future<bool>.value(true);
  }

  @override
  Future<bool> isTIMInstalled() {
    throw UnimplementedError();
  }

  @override
  Stream<BaseResp> respStream() {
    throw UnimplementedError();
  }

  @override
  Future<void> login({
    required List<String> scope,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> shareImage({
    required int scene,
    required Uri imageUri,
    String? appName,
    int extInt = TencentQZoneFlag.DEFAULT,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> shareMood({
    required int scene,
    String? summary,
    List<Uri>? imageUris,
    Uri? videoUri,
  }) {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }

  @override
  Future<void> shareText({
    required int scene,
    required String summary,
  }) {
    throw UnimplementedError();
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
    throw UnimplementedError();
  }
}

void main() {
  final TencentKitPlatform initialPlatform = TencentKitPlatform.instance;

  test('$MethodChannelTencentKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTencentKit>());
  });

  test('isQQInstalled', () async {
    final MockTencentKitPlatform fakePlatform = MockTencentKitPlatform();
    TencentKitPlatform.instance = fakePlatform;

    expect(await TencentKitPlatform.instance.isQQInstalled(), true);
  });
}
