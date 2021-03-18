import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedantic/pedantic.dart';
import 'package:tencent_kit/tencent_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('v7lin.github.io/tencent_kit');
  final Tencent tencent = Tencent();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'registerApp':
          return null;
        case 'isQQInstalled':
          return true;
        case 'isTIMInstalled':
          return true;
        case 'login':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(
                MethodCall('onLoginResp', json.decode('{"ret":-2}'))),
            (ByteData? data) {
              // mock success
            },
          ));
          return null;
        case 'logout':
          return null;
        case 'shareMood':
        case 'shareText':
        case 'shareImage':
        case 'shareMusic':
        case 'shareWebpage':
          unawaited(channel.binaryMessenger.handlePlatformMessage(
            channel.name,
            channel.codec.encodeMethodCall(
                MethodCall('onShareResp', json.decode('{"ret":0}'))),
            (ByteData? data) {
              // mock success
            },
          ));
          return null;
      }
      throw PlatformException(code: '0', message: '想啥呢，升级插件不想升级Mock？');
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isQQInstalled', () async {
    expect(await tencent.isQQInstalled(), true);
  });

  test('isTIMInstalled', () async {
    expect(await tencent.isTIMInstalled(), true);
  });

  test('login', () async {
    StreamSubscription<TencentLoginResp> sub =
        tencent.loginResp().listen((TencentLoginResp resp) {
      expect(resp.ret, TencentSdkResp.RET_USERCANCEL);
    });
    await tencent.login(
      scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
    );
    await sub.cancel();
  });

  test('share', () async {
    StreamSubscription<TencentShareResp> sub =
        tencent.shareResp().listen((TencentShareResp resp) {
      expect(resp.ret, TencentSdkResp.RET_SUCCESS);
    });
    await tencent.shareMood(
      scene: TencentScene.SCENE_QZONE,
      summary: 'share text',
    );
    await sub.cancel();
  });
}
