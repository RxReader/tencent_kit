package io.github.v7lin.tencent_kit;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ProviderInfo;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.tencent.connect.common.Constants;
import com.tencent.connect.share.QQShare;
import com.tencent.connect.share.QzonePublish;
import com.tencent.connect.share.QzoneShare;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

/**
 * TencentKitPlugin
 */
public class TencentKitPlugin implements FlutterPlugin, ActivityAware, ActivityResultListener, MethodCallHandler {

    private static class TencentScene {
        static final int SCENE_QQ = 0;
        static final int SCENE_QZONE = 1;
    }

    private static class TencentRetCode {
        // 网络请求成功发送至服务器，并且服务器返回数据格式正确
        // 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
        static final int RET_SUCCESS = 0;
        // 网络异常，或服务器返回的数据格式不正确导致无法解析
        static final int RET_FAILED = 1;
        static final int RET_COMMON = -1;
        static final int RET_USERCANCEL = -2;
    }

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context applicationContext;
    private ActivityPluginBinding activityPluginBinding;

    private Tencent tencent;

    // --- FlutterPlugin

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/tencent_kit");
        channel.setMethodCallHandler(this);
        applicationContext = binding.getApplicationContext();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        applicationContext = null;
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activityPluginBinding = binding;
        activityPluginBinding.addActivityResultListener(this);
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
        activityPluginBinding.removeActivityResultListener(this);
        activityPluginBinding = null;
    }

    // --- ActivityResultListener

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        switch (requestCode) {
            case Constants.REQUEST_LOGIN:
                return Tencent.onActivityResultData(requestCode, resultCode, data, loginListener);
            case Constants.REQUEST_QQ_SHARE:
            case Constants.REQUEST_QZONE_SHARE:
                return Tencent.onActivityResultData(requestCode, resultCode, data, shareListener);
            default:
                break;
        }
        return false;
    }

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if ("setIsPermissionGranted".equals(call.method)) {
            final boolean granted = call.argument("granted");
            final String buildModel = call.argument("build_model");
            if (!TextUtils.isEmpty(buildModel)) {
                Tencent.setIsPermissionGranted(granted, buildModel);
            } else {
                Tencent.setIsPermissionGranted(granted);
            }
            result.success(null);
        } else if ("registerApp".equals(call.method)) {
            final String appId = call.argument("appId");
//            final String universalLink = call.argument("universalLink");
            String authority = null;
            try {
                ProviderInfo providerInfo = applicationContext.getPackageManager().getProviderInfo(new ComponentName(applicationContext, TencentKitFileProvider.class), PackageManager.MATCH_DEFAULT_ONLY);
                authority = providerInfo.authority;
            } catch (PackageManager.NameNotFoundException e) {
                // ignore
            }
            if (!TextUtils.isEmpty(authority)) {
                tencent = Tencent.createInstance(appId, applicationContext, authority);
            } else {
                tencent = Tencent.createInstance(appId, applicationContext);
            }
            result.success(null);
        } else if ("isQQInstalled".equals(call.method)) {
            result.success(tencent != null && isAppInstalled(applicationContext, "com.tencent.mobileqq"));
        } else if ("isTIMInstalled".equals(call.method)) {
            result.success(tencent != null && isAppInstalled(applicationContext, "com.tencent.tim"));
        } else if ("login".equals(call.method)) {
            login(call, result);
        } else if ("loginServerSide".equals(call.method)) {
            loginServerSide(call, result);
        } else if ("logout".equals(call.method)) {
            logout(call, result);
        } else if ("shareMood".equals(call.method)) {
            shareMood(call, result);
        } else if ("shareText".equals(call.method)) {
            shareText(call, result);
        } else if ("shareImage".equals(call.method)) {
            shareImage(call, result);
        } else if ("shareMusic".equals(call.method)) {
            shareMusic(call, result);
        } else if ("shareWebpage".equals(call.method)) {
            shareWebpage(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void login(@NonNull MethodCall call, @NonNull Result result) {
        final String scope = call.argument("scope");
        final boolean qrcode = call.argument("qrcode");
        if (tencent != null) {
            tencent.login(activityPluginBinding.getActivity(), scope, loginListener, qrcode);
        }
        result.success(null);
    }

    private void loginServerSide(@NonNull MethodCall call, @NonNull Result result) {
        final String scope = call.argument("scope");
        final boolean qrcode = call.argument("qrcode");
        if (tencent != null) {
            tencent.loginServerSide(activityPluginBinding.getActivity(), scope, loginListener, qrcode);
        }
        result.success(null);
    }

    private IUiListener loginListener = new IUiListener() {
        @Override
        public void onComplete(Object o) {
            final Map<String, Object> map = new HashMap<>();
            try {
                if (o != null && o instanceof JSONObject) {
                    final JSONObject object = (JSONObject) o;
                    final int ret = !object.isNull("ret") ? object.getInt("ret") : TencentRetCode.RET_FAILED;
                    final String msg = !object.isNull("msg") ? object.getString("msg") : null;
                    if (ret == TencentRetCode.RET_SUCCESS) {
                        final String openId = !object.isNull("openid") ? object.getString("openid") : null;
                        final String accessToken = !object.isNull("access_token") ? object.getString("access_token") : null;
                        final int expiresIn = !object.isNull("expires_in") ? object.getInt("expires_in") : 0;
                        final long createAt = System.currentTimeMillis();
                        if (!TextUtils.isEmpty(openId) && !TextUtils.isEmpty(accessToken)) {
                            map.put("ret", TencentRetCode.RET_SUCCESS);
                            map.put("openid", openId);
                            map.put("access_token", accessToken);
                            map.put("expires_in", expiresIn);
                            map.put("create_at", createAt);
                        } else {
                            map.put("ret", TencentRetCode.RET_COMMON);
                            map.put("msg", "openId or accessToken is null.");
                        }
                    } else {
                        map.put("ret", TencentRetCode.RET_COMMON);
                        map.put("msg", msg);
                    }
                }
            } catch (JSONException e) {
                map.put("ret", TencentRetCode.RET_COMMON);
                map.put("msg", e.getMessage());
            }
            if (channel != null) {
                channel.invokeMethod("onLoginResp", map);
            }
        }

        @Override
        public void onError(UiError uiError) {
            // 登录失败
            final Map<String, Object> map = new HashMap<>();
            map.put("ret", TencentRetCode.RET_COMMON);
            map.put("msg", uiError.errorMessage);
            if (channel != null) {
                channel.invokeMethod("onLoginResp", map);
            }
        }

        @Override
        public void onCancel() {
            // 取消登录
            final Map<String, Object> map = new HashMap<>();
            map.put("ret", TencentRetCode.RET_USERCANCEL);
            if (channel != null) {
                channel.invokeMethod("onLoginResp", map);
            }
        }

        @Override
        public void onWarning(int code) {
        }
    };

    private void logout(@NonNull MethodCall call, @NonNull Result result) {
        if (tencent != null) {
            tencent.logout(applicationContext);
        }
        result.success(null);
    }

    private void shareMood(@NonNull MethodCall call, @NonNull Result result) {
        final int scene = call.argument("scene");
        if (scene == TencentScene.SCENE_QZONE) {
            final String summary = call.argument("summary");
            final List<String> imageUris = call.argument("imageUris");
            final String videoUri = call.argument("videoUri");

            final Bundle params = new Bundle();
            if (!TextUtils.isEmpty(summary)) {
                params.putString(QzonePublish.PUBLISH_TO_QZONE_SUMMARY, summary);
            }
            if (imageUris != null && !imageUris.isEmpty()) {
                final ArrayList<String> uris = new ArrayList<>();
                for (String imageUri : imageUris) {
                    uris.add(Uri.parse(imageUri).getPath());
                }
                params.putStringArrayList(QzonePublish.PUBLISH_TO_QZONE_IMAGE_URL, uris);
            }
            if (!TextUtils.isEmpty(videoUri)) {
                final String videoPath = Uri.parse(videoUri).getPath();
                params.putString(QzonePublish.PUBLISH_TO_QZONE_VIDEO_PATH, videoPath);
                params.putInt(QzonePublish.PUBLISH_TO_QZONE_KEY_TYPE, QzonePublish.PUBLISH_TO_QZONE_TYPE_PUBLISHVIDEO);
            } else {
                params.putInt(QzonePublish.PUBLISH_TO_QZONE_KEY_TYPE, QzonePublish.PUBLISH_TO_QZONE_TYPE_PUBLISHMOOD);
            }
            if (tencent != null) {
                tencent.publishToQzone(activityPluginBinding.getActivity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareText(@NonNull MethodCall call, @NonNull Result result) {
        final int scene = call.argument("scene");
        if (scene == TencentScene.SCENE_QQ) {
            final String summary = call.argument("summary");
            final Intent sendIntent = new Intent();
            sendIntent.setAction(Intent.ACTION_SEND);
            sendIntent.putExtra(Intent.EXTRA_TEXT, summary);
            sendIntent.setType("text/*");
            // 普通大众版 > 办公简洁版 > 急速轻聊版
            final PackageManager packageManager = applicationContext.getPackageManager();
            final List<PackageInfo> infos = packageManager.getInstalledPackages(0);
            if (infos != null && !infos.isEmpty()) {
                for (String packageName : Arrays.asList("com.tencent.mobileqq", "com.tencent.tim", "com.tencent.qqlite")) {
                    for (PackageInfo info : infos) {
                        if (packageName.equals(info.packageName)) {
                            sendIntent.setPackage(packageName);
                            if (sendIntent.resolveActivity(applicationContext.getPackageManager()) != null) {
                                sendIntent.setComponent(new ComponentName(packageName, "com.tencent.mobileqq.activity.JumpActivity"));
                                activityPluginBinding.getActivity().startActivity(sendIntent);
                                break;
                            }
                        }
                    }
                }
            }
        }
        result.success(null);
    }

    private void shareImage(@NonNull MethodCall call, @NonNull Result result) {
        final int scene = call.argument("scene");
        if (scene == TencentScene.SCENE_QQ) {
            final String imageUri = call.argument("imageUri");
            final String appName = call.argument("appName");
            final int extInt = call.argument("extInt");

            final Bundle params = new Bundle();
            params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_IMAGE);
            params.putString(QQShare.SHARE_TO_QQ_IMAGE_LOCAL_URL, Uri.parse(imageUri).getPath());
            if (!TextUtils.isEmpty(appName)) {
                params.putString(QQShare.SHARE_TO_QQ_APP_NAME, appName);
            }
            params.putInt(QQShare.SHARE_TO_QQ_EXT_INT, extInt);
            if (tencent != null) {
                tencent.shareToQQ(activityPluginBinding.getActivity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareMusic(@NonNull MethodCall call, @NonNull Result result) {
        final int scene = call.argument("scene");
        if (scene == TencentScene.SCENE_QQ) {
            final String title = call.argument("title");
            final String summary = call.argument("summary");
            final String imageUri = call.argument("imageUri");
            final String musicUrl = call.argument("musicUrl");
            final String targetUrl = call.argument("targetUrl");
            final String appName = call.argument("appName");
            final int extInt = call.argument("extInt");

            Bundle params = new Bundle();
            params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_AUDIO);
            params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
            if (!TextUtils.isEmpty(summary)) {
                params.putString(QQShare.SHARE_TO_QQ_SUMMARY, summary);
            }
            if (!TextUtils.isEmpty(imageUri)) {
                Uri uri = Uri.parse(imageUri);
                if (TextUtils.equals("file", uri.getScheme())) {
                    params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, uri.getPath());
                } else {
                    params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, imageUri);
                }
            }
            params.putString(QQShare.SHARE_TO_QQ_AUDIO_URL, musicUrl);
            params.putString(QQShare.SHARE_TO_QQ_TARGET_URL, targetUrl);
            if (!TextUtils.isEmpty(appName)) {
                params.putString(QQShare.SHARE_TO_QQ_APP_NAME, appName);
            }
            params.putInt(QQShare.SHARE_TO_QQ_EXT_INT, extInt);
            if (tencent != null) {
                tencent.shareToQQ(activityPluginBinding.getActivity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareWebpage(@NonNull MethodCall call, @NonNull Result result) {
        final int scene = call.argument("scene");
        final String title = call.argument("title");
        final String summary = call.argument("summary");
        final String imageUri = call.argument("imageUri");
        final String targetUrl = call.argument("targetUrl");
        final String appName = call.argument("appName");
        final int extInt = call.argument("extInt");

        final Bundle params = new Bundle();
        switch (scene) {
            case TencentScene.SCENE_QQ:
                params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
                params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
                if (!TextUtils.isEmpty(summary)) {
                    params.putString(QQShare.SHARE_TO_QQ_SUMMARY, summary);
                }
                if (!TextUtils.isEmpty(imageUri)) {
                    final Uri uri = Uri.parse(imageUri);
                    if (TextUtils.equals("file", uri.getScheme())) {
                        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, uri.getPath());
                    } else {
                        params.putString(QQShare.SHARE_TO_QQ_IMAGE_URL, imageUri);
                    }
                }
                params.putString(QQShare.SHARE_TO_QQ_TARGET_URL, targetUrl);
                if (!TextUtils.isEmpty(appName)) {
                    params.putString(QQShare.SHARE_TO_QQ_APP_NAME, appName);
                }
                params.putInt(QQShare.SHARE_TO_QQ_EXT_INT, extInt);
                if (tencent != null) {
                    tencent.shareToQQ(activityPluginBinding.getActivity(), params, shareListener);
                }
                break;
            case TencentScene.SCENE_QZONE:
                params.putInt(QzoneShare.SHARE_TO_QZONE_KEY_TYPE, QzoneShare.SHARE_TO_QZONE_TYPE_IMAGE_TEXT);
                params.putString(QzoneShare.SHARE_TO_QQ_TITLE, title);
                if (!TextUtils.isEmpty(summary)) {
                    params.putString(QzoneShare.SHARE_TO_QQ_SUMMARY, summary);
                }
                if (!TextUtils.isEmpty(imageUri)) {
                    final ArrayList<String> uris = new ArrayList<>();
                    final Uri uri = Uri.parse(imageUri);
                    if (TextUtils.equals("file", uri.getScheme())) {
                        uris.add(uri.getPath());
                    } else {
                        uris.add(imageUri);
                    }
                    params.putStringArrayList(QzoneShare.SHARE_TO_QQ_IMAGE_URL, uris);
                }
                params.putString(QzoneShare.SHARE_TO_QQ_TARGET_URL, targetUrl);
                if (tencent != null) {
                    tencent.shareToQzone(activityPluginBinding.getActivity(), params, shareListener);
                }
                break;
            default:
                break;
        }
        result.success(null);
    }

    private IUiListener shareListener = new IUiListener() {
        @Override
        public void onComplete(Object o) {
            final Map<String, Object> map = new HashMap<>();
            try {
                if (o != null && o instanceof JSONObject) {
                    final JSONObject object = (JSONObject) o;
                    final int ret = !object.isNull("ret") ? object.getInt("ret") : TencentRetCode.RET_FAILED;
                    final String msg = !object.isNull("msg") ? object.getString("msg") : null;
                    if (ret == TencentRetCode.RET_SUCCESS) {
                        map.put("ret", TencentRetCode.RET_SUCCESS);
                    } else {
                        map.put("ret", TencentRetCode.RET_COMMON);
                        map.put("msg", msg);
                    }
                }
            } catch (JSONException e) {
                map.put("ret", TencentRetCode.RET_COMMON);
                map.put("msg", e.getMessage());
            }
            if (channel != null) {
                channel.invokeMethod("onShareResp", map);
            }
        }

        @Override
        public void onError(UiError error) {
            final Map<String, Object> map = new HashMap<>();
            map.put("ret", TencentRetCode.RET_COMMON);
            map.put("msg", error.errorMessage);
            if (channel != null) {
                channel.invokeMethod("onShareResp", map);
            }
        }

        @Override
        public void onCancel() {
            final Map<String, Object> map = new HashMap<>();
            map.put("ret", TencentRetCode.RET_USERCANCEL);
            if (channel != null) {
                channel.invokeMethod("onShareResp", map);
            }
        }

        @Override
        public void onWarning(int code) {
            if (code == Constants.ERROR_NO_AUTHORITY) {
                // 如果authorities为空，sdk会回调这个接口，提醒开发者适配FileProvider
            }
        }
    };

    // ---

    private static boolean isAppInstalled(Context context, String packageName) {
        PackageInfo packageInfo = null;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(packageName, 0);
        } catch (PackageManager.NameNotFoundException e) {
        }
        return packageInfo != null;
    }
}
