package io.github.v7lin.tencent_kit;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.tencent.connect.common.Constants;
import com.tencent.connect.share.QQShare;
import com.tencent.connect.share.QzonePublish;
import com.tencent.connect.share.QzoneShare;
import com.tencent.open.im.IM;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * TencentKitPlugin
 */
public class TencentKitPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "v7lin.github.io/tencent_kit");
        TencentKitPlugin plugin = new TencentKitPlugin(registrar, channel);
        registrar.addActivityResultListener(plugin);
        channel.setMethodCallHandler(plugin);
    }

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

    private static final String METHOD_REGISTERAPP = "registerApp";
    private static final String METHOD_ISINSTALLED = "isInstalled";
    private static final String METHOD_ISREADY = "isReady";
    private static final String METHOD_LOGIN = "login";
    private static final String METHOD_LOGOUT = "logout";
    private static final String METHOD_SHAREMOOD = "shareMood";
    private static final String METHOD_SHAREIMAGE = "shareImage";
    private static final String METHOD_SHAREMUSIC = "shareMusic";
    private static final String METHOD_SHAREWEBPAGE = "shareWebpage";
    private static final String START_CONVERSATION = "startConversation";

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
    private static final String ARGUMENT_KEY_QQ = "qq";

    private static final String ARGUMENT_KEY_RESULT_RET = "ret";
    private static final String ARGUMENT_KEY_RESULT_MSG = "msg";
    private static final String ARGUMENT_KEY_RESULT_OPENID = "openid";
    private static final String ARGUMENT_KEY_RESULT_ACCESS_TOKEN = "access_token";
    private static final String ARGUMENT_KEY_RESULT_EXPIRES_IN = "expires_in";
    private static final String ARGUMENT_KEY_RESULT_CREATE_AT = "create_at";

    private static final String SCHEME_FILE = "file";

    private final Registrar registrar;
    private final MethodChannel channel;

    private Tencent tencent;

    private TencentKitPlugin(Registrar registrar, MethodChannel channel) {
        this.registrar = registrar;
        this.channel = channel;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (METHOD_REGISTERAPP.equals(call.method)) {
            final String appId = call.argument(ARGUMENT_KEY_APPID);
//            final String universalLink = call.argument(ARGUMENT_KEY_UNIVERSALLINK);
            tencent = Tencent.createInstance(appId, registrar.context().getApplicationContext());
            result.success(null);
        } else if (METHOD_ISINSTALLED.equals(call.method)) {
            boolean isInstalled = false;
            PackageManager packageManager = registrar.context().getPackageManager();
            List<PackageInfo> infos = packageManager.getInstalledPackages(0);
            if (infos != null && !infos.isEmpty()) {
                for (PackageInfo info : infos) {
                    // 普通大众版 > 办公简洁版 > 急速轻聊版
                    if ("com.tencent.mobileqq".equals(info.packageName)
                            || "com.tencent.tim".equals(info.packageName)
                            || "com.tencent.qqlite".equals(info.packageName)) {
                        isInstalled = true;
                        break;
                    }
                }
            }
            result.success(isInstalled);
        } else if (METHOD_ISREADY.equals(call.method)) {
            result.success(tencent != null && tencent.isReady());
        } else if (METHOD_LOGIN.equals(call.method)) {
            login(call, result);
        } else if (METHOD_LOGOUT.equals(call.method)) {
            logout(call, result);
        } else if (METHOD_SHAREMOOD.equals(call.method)) {
            shareMood(call, result);
        } else if (METHOD_SHAREIMAGE.equals(call.method)) {
            shareImage(call, result);
        } else if (METHOD_SHAREMUSIC.equals(call.method)) {
            shareMusic(call, result);
        } else if (METHOD_SHAREWEBPAGE.equals(call.method)) {
            shareWebpage(call, result);
        } else if (START_CONVERSATION.equals(call.method)) {
            startConversation(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void login(MethodCall call, Result result) {
        if (tencent != null) {
            String scope = call.argument(ARGUMENT_KEY_SCOPE);
            tencent.login(registrar.activity(), scope, loginListener);
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
                            tencent.setOpenId(openId);
                            tencent.setAccessToken(accessToken, String.valueOf(expiresIn));
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
            channel.invokeMethod(METHOD_ONLOGINRESP, map);
        }

        @Override
        public void onError(UiError uiError) {
            // 登录失败
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
            map.put(ARGUMENT_KEY_RESULT_MSG, uiError.errorMessage);
            channel.invokeMethod(METHOD_ONLOGINRESP, map);
        }

        @Override
        public void onCancel() {
            // 取消登录
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_USERCANCEL);
            channel.invokeMethod(METHOD_ONLOGINRESP, map);
        }
    };

    private void logout(MethodCall call, Result result) {
        if (tencent != null) {
            tencent.logout(registrar.context());
            result.success(null);
        }
    }

    private void shareMood(MethodCall call, Result result) {
        if (tencent != null) {
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
                tencent.publishToQzone(registrar.activity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareImage(MethodCall call, Result result) {
        if (tencent != null) {
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
                tencent.shareToQQ(registrar.activity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareMusic(MethodCall call, Result result) {
        if (tencent != null) {
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
                tencent.shareToQQ(registrar.activity(), params, shareListener);
            }
        }
        result.success(null);
    }

    private void shareWebpage(MethodCall call, Result result) {
        if (tencent != null) {
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
                    tencent.shareToQQ(registrar.activity(), params, shareListener);
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
                    tencent.shareToQzone(registrar.activity(), params, shareListener);
                    break;
                default:
                    break;
            }
        }
        result.success(null);
    }

    private void startConversation(MethodCall call, Result result) {
        if (tencent == null) {
            result.error(String.valueOf(IM.IM_UNKNOWN_TYPE), "Should register app at first", null);
            return;
        }
        if (!tencent.isReady()) {
            result.error(String.valueOf(IM.IM_UNKNOWN_TYPE), "Should login at first", null);
            return;
        }
        String qq = call.argument(ARGUMENT_KEY_QQ);
        android.app.Activity activity = registrar.activity();
        String packageName = activity.getApplicationContext().getPackageName();
        int ret = tencent.startIMAio(activity, qq, packageName);
        if (ret == IM.IM_SUCCESS) {
            result.success("0");
            return;
        }
        String errorMsg;
        switch (ret) {
            case IM.IM_SHOULD_DOWNLOAD:
                errorMsg = "Should download latest version of MobileQQ";
                break;
            case IM.IM_UIN_EMPTY:
            case IM.IM_LENGTH_SHORT:
            case IM.IM_UIN_NOT_DIGIT:
                errorMsg = "QQ number is invalid";
                break;
            case IM.IM_UNKNOWN_TYPE:
            default:
                errorMsg = "Unknown type";
                break;
        }
        result.error(String.valueOf(ret), errorMsg, null);
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
            channel.invokeMethod(METHOD_ONSHARERESP, map);
        }

        @Override
        public void onError(UiError error) {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_COMMON);
            map.put(ARGUMENT_KEY_RESULT_MSG, error.errorMessage);
            channel.invokeMethod(METHOD_ONSHARERESP, map);
        }

        @Override
        public void onCancel() {
            Map<String, Object> map = new HashMap<>();
            map.put(ARGUMENT_KEY_RESULT_RET, TencentRetCode.RET_USERCANCEL);
            channel.invokeMethod(METHOD_ONSHARERESP, map);
        }
    };

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
}
