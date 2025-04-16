import {
  AbilityAware,
  AbilityPluginBinding,
  Any,
  FlutterManager,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
  NewWantListener,
} from '@ohos/flutter_ohos';
import { IQQOpenApi, QQOpenApiFactory, ApiCallback, AuthResponse } from '@tencent/qq-open-sdk'
import { AbilityConstant, Want } from '@kit.AbilityKit';

enum TencentRetCode {
  RET_SUCCESS = 0,
  RET_FAILED = 1,
  RET_COMMON = -1,
  RET_CANCEL = -2
}

const KEY_RET_CODE = "ret";
const KEY_RET_MSG = "msg";

/** TencentKitPlugin **/
export default class TencentKitPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware, NewWantListener {
  private channel: MethodChannel | null = null;
  private binding: AbilityPluginBinding | null = null;
  private tencent: IQQOpenApi | null = null;
  private modeServerSide: boolean = false;

  getUniqueClassName(): string {
    return "TencentKitPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/tencent_kit");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.channel = null;
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.binding = binding;
    binding.addOnNewWantListener(this);
  }

  onDetachedFromAbility(): void {
    this.binding = null;
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    this.tencent?.handleResult(want)
  }

  authListener: ApiCallback<AuthResponse> = {
    onComplete: (response: AuthResponse): void => {
      const resp: Map<string, Any> = new Map();
      try {
        if (response.ret == TencentRetCode.RET_SUCCESS) {
          // 服务端模式时, access_token 设置为为 authCode, 当前 SDK 不支持客户端模式(因此 null)
          const accessToken: string | null = this.modeServerSide ? response.authCode : null;
          resp.set(KEY_RET_CODE, TencentRetCode.RET_SUCCESS);
          resp.set("openid", response.openId);
          resp.set("access_token", accessToken);
          resp.set("expires_in", response.expiresIn);
          resp.set("create_at", response.authTime);
        } else {
          resp.set("ret", TencentRetCode.RET_COMMON);
        }
      } catch (e) {
        resp.set(KEY_RET_CODE, TencentRetCode.RET_COMMON);
        resp.set(KEY_RET_MSG, `${e}`);
      }
      this.channel?.invokeMethod("onLoginResp", resp);
    },
    onError: (msg: string | null): void => {
      const resp: Map<string, Any> = new Map();
      resp.set(KEY_RET_CODE, TencentRetCode.RET_FAILED);
      resp.set(KEY_RET_MSG, msg);
      this.channel?.invokeMethod("onLoginResp", resp);
    },
    onCancel: (msg: string | null): void => {
      const resp: Map<string, Any> = new Map();
      resp.set(KEY_RET_CODE, TencentRetCode.RET_CANCEL);
      resp.set(KEY_RET_MSG, msg);
      this.channel?.invokeMethod("onLoginResp", resp);
    }
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "setIsPermissionGranted":
        // 当前 SDK 不支持此方法，暂时返回 null
        result.success(null);
        break;
      case "registerApp":
        this.registerApp(call, result);
        break;
      case "isQQInstalled":
        result.success(this.tencent != null && this.tencent.isQQInstalled());
        break;
      case "isTIMInstalled":
        // TIM 并未适配 harmonyOS, 暂时返回 false
        result.success(false);
        break;
      case "login":
        this.login(call, result);
        break;
      case "loginServerSide":
        this.loginServerSide(call, result);
        break;
      default:
        result.notImplemented();
    }
  }

  private getUIContext(): UIContext {
    const uiAbility = this.binding!.getAbility();
    const windowState = FlutterManager.getInstance().getWindowStage(uiAbility);
    const window = windowState.getMainWindowSync();
    return window.getUIContext();
  }

  private registerApp(call: MethodCall, result: MethodResult) {
    const appId: number = parseInt(call.argument("appId") as string);
    this.tencent = QQOpenApiFactory.createApi(appId, {
      autoHandleAuthResult: true,
      forceEnableWeb: false,
    });
    result.success(null);
  }

  private login(call: MethodCall, result: MethodResult) {
    // this.modeServerSide = false; // 客户端授权
    // 当前 SDK 仅支持 ServerSide 授权，暂时不处理
    this.tencent?.login({
      scope: "all",
      useQrCode: false,
      networkTimeout: 0,
      forceWebLogin: false
    }, this.authListener);
    result.success(null);
  }

  private loginServerSide(call: MethodCall, result: MethodResult) {
    this.modeServerSide = true; // 服务端授权
    const scope: string = call.argument("scope");
    const qrcode: boolean = call.argument("qrcode");
    this.tencent?.login({
      scope: scope,
      useQrCode: qrcode,
      forceWebLogin: qrcode || !this.tencent!.isQQInstalled(), // H5 授权, 二维码登录或 QQ 未安装时强制启用
      networkTimeout: 0, // 不限制, 由 SDK 自行决定
    }, this.authListener);
    result.success(null);
  }
}