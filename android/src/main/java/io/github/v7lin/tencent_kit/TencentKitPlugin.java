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

    //

    private static final String METHOD_REGISTERAPP = "registerApp";
    private static final String METHOD_ISQQINSTALLED = "isQQInstalled";
    private static final String METHOD_ISTIMINSTALLED = "isTIMInstalled";
    private static final String METHOD_LOGIN = "login";
    private static final String METHOD_LOGOUT = "logout";
    private static final String METHOD_SHAREMOOD = "shareMood";
    private static final String METHOD_SHARETEXT = "shareText";
    private static final String METHOD_SHAREIMAGE = "shareImage";
    private static final String METHOD_SHAREMUSIC = "shareMusic";
    private static final String METHOD_SHAREWEBPAGE = "shareWebpage";

    private static final String METHOD_ONLOGINRESP = "onLoginResp";
    private static final String METHOD_ONSHARERESP = "onShareResp";

    private static final String ARGUMENT_KEY_APPID = "appId";
    //    private static final String ARGUMENT_KEY_UNIVERSALLINK = "universalLink";
    private static final String ARGUMENT_KEY_SCOPE = "scope";
    private static final String ARGUMENT_KEY_SCENE = "scene";
    private static final String ARGUMENT_KEY_TITLE = "title";
    private static final String ARGUMENT_KEY_SUMMARY = "summary";
    private static final String ARGUMENT_KEY_IMAGEURI = "imageUri";
    private static final String ARGUMENT_KEY_IMAGEURIS = "imageUris";
    private static final String ARGUMENT_KEY_VIDEOURI = "videoUri";
    private static final String ARGUMENT_KEY_MUSICURL = "musicUrl";
    private static final String ARGUMENT_KEY_TARGETURL = "targetUrl";
    private static final String ARGUMENT_KEY_APPNAME = "appName";
    private static final String ARGUMENT_KEY_EXTINT = "extInt";

    private static final String ARGUMENT_KEY_RESULT_RET = "ret";
    private static final String ARGUMENT_KEY_RESULT_MSG = "msg";
    private static final String ARGUMENT_KEY_RESULT_OPENID = "openid";
    private static final String ARGUMENT_KEY_RESULT_ACCESS_TOKEN = "access_token";
    private static final String ARGUMENT_KEY_RESULT_EXPIRES_IN = "expires_in";
    private static final String ARGUMENT_KEY_RESULT_CREATE_AT = "create_at";

    private static final String SCHEME_FILE = "file";

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
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
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
        if (METHOD_REGISTERAPP.equals(call.method)) {
            final String appId = call.argument(ARGUMENT_KEY_APPID);
//            final String universalLink = call.argument(ARGUMENT_KEY_UNIVERSALLINK);
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
            Tencent.setIsPermissionGranted(true);

            result.success(null);
        } else if (METHOD_ISQQINSTALLED.equals(call.method)) {
            result.success(isAppInstalled(applicationContext, "com.tencent.mobileqq"));
        } else if (METHOD_ISTIMINSTALLED.equals(call.method)) {
            result.success(isAppInstalled(applicationContext, "com.tencent.tim"));
        } else if (METHOD_LOGIN.equals(call.method)) {
            login(call, result);
        } else if (METHOD_LOGOUT.equals(call.method)) {
            logout(call, result);
        } else if (METHOD_SHAREMOOD.equals(call.method)) {
            shareMood(call, result);
        } else if (METHOD_SHARETEXT.equals(call.method)) {
            shareText(call, result);
        } else if (METHOD_SHAREIMAGE.equals(call.method)) {
            shareImage(call, result);
        } else if (METHOD_SHAREMUSIC.equals(call.method)) {
            shareMusic(call, result);
        } else if (METHOD_SHAREWEBPAGE.equals(call.method)) {
            shareWebpage(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void login(@NonNull MethodCall call, @NonNull Result result) {
        String scope = call.argument(ARGUMENT_KEY_SCOPE);
        if (tencent != null) {
            tencent.login(activityPluginBinding.getActivity(), scope, loginListener);
        }
        result.success(null);
    }

    private IUiListener loginListener = new IUiListener() {
        @Override
        public void onComplete(Object o) {
            Map<String, Object> map = new HashMap<>();
            try {
                if (o != null && o instanceof JSONObject) {
                    JSONObject object = (JSONObject) o;
                    int ret = !object.isNull(ARGUMENT_KEY_RESULT_RET) ? object.getInt(ARGUMENT_KEY_RESULT_RET) : TencentRetCode.RET_FAILED;
                    String msg = !object.isNull(ARGUMENT_KEY_RESULT_MSG) ? object.getString(ARGUMENT_KEY_RESULT_MSG) : null;
                    if (ret == TencentRetCode.RET_SUCCESS) {
                        String openId = !object.isNull(ARGUMENT_KEY_RESULT_OPENID) ? object.getString(ARGUMENT_KEY_RESULT_OPENID) : null;
                        String accessToken = !object.isNull(ARGUMENT_KEY_RESULT_ACCESS_TOKEN) ? object.getString(ARGUMENT_KEY_RESULT_ACCESS_TOKEN) : null;
                        int expiresIn = !object.isNull(ARGUMENT_KEY_RESULT_EXPIRES_IN) ? object.getInt(ARGUMENT_KEY_RESULT_EXPIRES_IN) : 0;
                        long createAt = System.currentTimeMillis();
                        if (!TextUtils.isEmpty(openId) && !TextUtils.isEmpty(accessToken)) {
                            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_SUCCESS);
                            map.put(ARGUMENT_KEY_RESULT_OPENID, openId);
                            map.put(ARGUMENT_KEY_RESULT_ACCESS_TOKEN, accessToken);
                            map.put(ARGUMENT_KEY_RESULT_EXPIRES_IN, expiresIn);
                            map.put(ARGUMENT_KEY_RESULT_CREATE_AT, createAt);
                        } else {
                            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
                            map.put(ARGUMENT_KEY_RESULT_MSG, "openId or accessToken is null.");
                        }
                    } else {
                        map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
                        map.put(ARGUMENT_KEY_RESULT_MSG, msg);
                    }
                }
            } catch (JSONException e) {
                map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
                map.put(ARGUMENT_KEY_RESULT_MSG, e.getMessage());
            }
            if (channel != null) {
                channel.invokeMethod(METHOD_ONLOGINRESP, map);
            }
        }

        @Override
        public void onError(UiError uiError) {
            // 登录失败
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
            map.put(ARGUMENT_KEY_RESULT_MSG, uiError.errorMessage);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONLOGINRESP, map);
            }
        }

        @Override
        public void onCancel() {
            // 取消登录
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_USERCANCEL);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONLOGINRESP, map);
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
        int scene = call.argument(ARGUMENT_KEY_SCENE);
        if (scene == TencentScene.SCENE_QZONE) {
            String summary = call.argument(ARGUMENT_KEY_SUMMARY);
            List<String> imageUris = call.argument(ARGUMENT_KEY_IMAGEURIS);
            String videoUri = call.argument(ARGUMENT_KEY_VIDEOURI);

            Bundle params = new Bundle();
            if (!TextUtils.isEmpty(summary)) {
                params.putString(QzonePublish.PUBLISH_TO_QZONE_SUMMARY, summary);
            }
            if (imageUris != null && !imageUris.isEmpty()) {
                ArrayList<String> uris = new ArrayList<>();
                for (String imageUri : imageUris) {
                    uris.add(Uri.parse(imageUri).getPath());
                }
                params.putStringArrayList(QzonePublish.PUBLISH_TO_QZONE_IMAGE_URL, uris);
            }
            if (!TextUtils.isEmpty(videoUri)) {
                String videoPath = Uri.parse(videoUri).getPath();
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
        int scene = call.argument(ARGUMENT_KEY_SCENE);
        if (scene == TencentScene.SCENE_QQ) {
            String summary = call.argument(ARGUMENT_KEY_SUMMARY);
            Intent sendIntent = new Intent();
            sendIntent.setAction(Intent.ACTION_SEND);
            sendIntent.putExtra(Intent.EXTRA_TEXT, summary);
            sendIntent.setType("text/*");
            // 普通大众版 > 办公简洁版 > 急速轻聊版
            PackageManager packageManager = applicationContext.getPackageManager();
            List<PackageInfo> infos = packageManager.getInstalledPackages(0);
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
        int scene = call.argument(ARGUMENT_KEY_SCENE);
        if (scene == TencentScene.SCENE_QQ) {
            String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
            String appName = call.argument(ARGUMENT_KEY_APPNAME);
            int extInt = call.argument(ARGUMENT_KEY_EXTINT);

            Bundle params = new Bundle();
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
        int scene = call.argument(ARGUMENT_KEY_SCENE);
        if (scene == TencentScene.SCENE_QQ) {
            String title = call.argument(ARGUMENT_KEY_TITLE);
            String summary = call.argument(ARGUMENT_KEY_SUMMARY);
            String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
            String musicUrl = call.argument(ARGUMENT_KEY_MUSICURL);
            String targetUrl = call.argument(ARGUMENT_KEY_TARGETURL);
            String appName = call.argument(ARGUMENT_KEY_APPNAME);
            int extInt = call.argument(ARGUMENT_KEY_EXTINT);

            Bundle params = new Bundle();
            params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_AUDIO);
            params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
            if (!TextUtils.isEmpty(summary)) {
                params.putString(QQShare.SHARE_TO_QQ_SUMMARY, summary);
            }
            if (!TextUtils.isEmpty(imageUri)) {
                Uri uri = Uri.parse(imageUri);
                if (TextUtils.equals(SCHEME_FILE, uri.getScheme())) {
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
        int scene = call.argument(ARGUMENT_KEY_SCENE);
        String title = call.argument(ARGUMENT_KEY_TITLE);
        String summary = call.argument(ARGUMENT_KEY_SUMMARY);
        String imageUri = call.argument(ARGUMENT_KEY_IMAGEURI);
        String targetUrl = call.argument(ARGUMENT_KEY_TARGETURL);
        String appName = call.argument(ARGUMENT_KEY_APPNAME);
        int extInt = call.argument(ARGUMENT_KEY_EXTINT);

        Bundle params = new Bundle();
        switch (scene) {
            case TencentScene.SCENE_QQ:
                params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_DEFAULT);
                params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
                if (!TextUtils.isEmpty(summary)) {
                    params.putString(QQShare.SHARE_TO_QQ_SUMMARY, summary);
                }
                if (!TextUtils.isEmpty(imageUri)) {
                    Uri uri = Uri.parse(imageUri);
                    if (TextUtils.equals(SCHEME_FILE, uri.getScheme())) {
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
                    ArrayList<String> uris = new ArrayList<>();
                    Uri uri = Uri.parse(imageUri);
                    if (TextUtils.equals(SCHEME_FILE, uri.getScheme())) {
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
            Map<String, Object> map = new HashMap<>();
            try {
                if (o != null && o instanceof JSONObject) {
                    JSONObject object = (JSONObject) o;
                    int ret = !object.isNull(ARGUMENT_KEY_RESULT_RET) ? object.getInt(ARGUMENT_KEY_RESULT_RET) : TencentRetCode.RET_FAILED;
                    String msg = !object.isNull(ARGUMENT_KEY_RESULT_MSG) ? object.getString(ARGUMENT_KEY_RESULT_MSG) : null;
                    if (ret == TencentRetCode.RET_SUCCESS) {
                        map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_SUCCESS);
                    } else {
                        map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
                        map.put(ARGUMENT_KEY_RESULT_MSG, msg);
                    }
                }
            } catch (JSONException e) {
                map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
                map.put(ARGUMENT_KEY_RESULT_MSG, e.getMessage());
            }
            if (channel != null) {
                channel.invokeMethod(METHOD_ONSHARERESP, map);
            }
        }

        @Override
        public void onError(UiError error) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
            map.put(ARGUMENT_KEY_RESULT_MSG, error.errorMessage);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONSHARERESP, map);
            }
        }

        @Override
        public void onCancel() {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_USERCANCEL);
            if (channel != null) {
                channel.invokeMethod(METHOD_ONSHARERESP, map);
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
