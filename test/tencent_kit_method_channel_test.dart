import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tencent_kit/src/tencent_kit_method_channel.dart';

void main() {
  final MethodChannelTencentKit platform = MethodChannelTencentKit();
  const MethodChannel channel = MethodChannel('v7lin.github.io/tencent_kit');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'isQQInstalled':
          return true;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('isQQInstalled', () async {
    expect(await platform.isQQInstalled(), true);
  });
}
