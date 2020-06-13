package io.github.v7lin.tencent_kit;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

/**
 * TencentKitPlugin
 */
public class TencentKitPlugin implements FlutterPlugin, ActivityAware {
    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(PluginRegistry.Registrar registrar) {
        TencentKit tencentKit = new TencentKit(registrar.context(), registrar.activity());
        registrar.addActivityResultListener(tencentKit);
        tencentKit.startListening(registrar.messenger());
    }

    // --- FlutterPlugin

    private final TencentKit tencentKit;

    private ActivityPluginBinding pluginBinding;

    public TencentKitPlugin() {
        tencentKit = new TencentKit();
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        tencentKit.setApplicationContext(flutterPluginBinding.getApplicationContext());
        tencentKit.setActivity(null);
        tencentKit.startListening(flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        tencentKit.setApplicationContext(null);
        tencentKit.setActivity(null);
        tencentKit.stopListening();
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        tencentKit.setActivity(binding.getActivity());
        pluginBinding = binding;
        pluginBinding.addActivityResultListener(tencentKit);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        tencentKit.setActivity(null);
        pluginBinding.removeActivityResultListener(tencentKit);
        pluginBinding = null;
    }
}
