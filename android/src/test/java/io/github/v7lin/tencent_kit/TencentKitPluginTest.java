package io.github.v7lin.tencent_kit;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.junit.Test;

/**
 * This demonstrates a simple unit test of the Java portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

public class TencentKitPluginTest {
  @Test
  public void onMethodCall_isQQInstalled_returnsExpectedValue() {
    TencentKitPlugin plugin = new TencentKitPlugin();

    final MethodCall call = new MethodCall("isQQInstalled", null);
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);
    plugin.onMethodCall(call, mockResult);

    verify(mockResult).success(false);
  }
}
