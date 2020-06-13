#import "TencentKitPlugin.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

enum TencentScene {
    SCENE_QQ = 0,
    SCENE_QZONE = 1,
};

enum TencentRetCode {
    // 网络请求成功发送至服务器，并且服务器返回数据格式正确
    // 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
    RET_SUCCESS = 0,
    // 网络异常，或服务器返回的数据格式不正确导致无法解析
    RET_FAILED = 1,
    RET_COMMON = -1,
    RET_USERCANCEL = -2,
};

@interface TencentKitPlugin () <TencentSessionDelegate, QQApiInterfaceDelegate>

@end

@implementation TencentKitPlugin {
    FlutterMethodChannel *_channel;
    TencentOAuth *_oauth;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
        [FlutterMethodChannel methodChannelWithName:@"v7lin.github.io/tencent_kit"
                                    binaryMessenger:[registrar messenger]];
    TencentKitPlugin *instance =
        [[TencentKitPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString *const METHOD_REGISTERAPP = @"registerApp";
static NSString *const METHOD_ISQQINSTALLED = @"isQQInstalled";
static NSString *const METHOD_ISTIMINSTALLED = @"isTIMInstalled";
static NSString *const METHOD_LOGIN = @"login";
static NSString *const METHOD_LOGOUT = @"logout";
static NSString *const METHOD_SHAREMOOD = @"shareMood";
static NSString *const METHOD_SHARETEXT = @"shareText";
static NSString *const METHOD_SHAREIMAGE = @"shareImage";
static NSString *const METHOD_SHAREMUSIC = @"shareMusic";
static NSString *const METHOD_SHAREWEBPAGE = @"shareWebpage";

static NSString *const METHOD_ONLOGINRESP = @"onLoginResp";
static NSString *const METHOD_ONSHARERESP = @"onShareResp";

static NSString *const ARGUMENT_KEY_APPID = @"appId";
static NSString *const ARGUMENT_KEY_UNIVERSALLINK = @"universalLink";
static NSString *const ARGUMENT_KEY_SCOPE = @"scope";
static NSString *const ARGUMENT_KEY_SCENE = @"scene";
static NSString *const ARGUMENT_KEY_TITLE = @"title";
static NSString *const ARGUMENT_KEY_SUMMARY = @"summary";
static NSString *const ARGUMENT_KEY_IMAGEURI = @"imageUri";
static NSString *const ARGUMENT_KEY_IMAGEURIS = @"imageUris";
static NSString *const ARGUMENT_KEY_VIDEOURI = @"videoUri";
static NSString *const ARGUMENT_KEY_MUSICURL = @"musicUrl";
static NSString *const ARGUMENT_KEY_TARGETURL = @"targetUrl";
static NSString *const ARGUMENT_KEY_APPNAME = @"appName";
static NSString *const ARGUMENT_KEY_EXTINT = @"extInt";

static NSString *const ARGUMENT_KEY_RESULT_RET = @"ret";
static NSString *const ARGUMENT_KEY_RESULT_MSG = @"msg";
static NSString *const ARGUMENT_KEY_RESULT_OPENID = @"openid";
static NSString *const ARGUMENT_KEY_RESULT_ACCESS_TOKEN = @"access_token";
static NSString *const ARGUMENT_KEY_RESULT_EXPIRES_IN = @"expires_in";
static NSString *const ARGUMENT_KEY_RESULT_CREATE_AT = @"create_at";

static NSString *const SCHEME_FILE = @"file";

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([METHOD_REGISTERAPP isEqualToString:call.method]) {
        NSString *appId = call.arguments[ARGUMENT_KEY_APPID];
        NSString *universalLink = call.arguments[ARGUMENT_KEY_UNIVERSALLINK];
        if (universalLink != nil) {
            _oauth = [[TencentOAuth alloc] initWithAppId:appId
                                        andUniversalLink:universalLink
                                             andDelegate:self];
        } else {
            _oauth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
        }
        result(nil);
    } else if ([METHOD_ISQQINSTALLED isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[TencentOAuth iphoneQQInstalled]]);
    } else if ([METHOD_ISTIMINSTALLED isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[TencentOAuth iphoneTIMInstalled]]);
    } else if ([METHOD_LOGIN isEqualToString:call.method]) {
        [self login:call result:result];
    } else if ([METHOD_LOGOUT isEqualToString:call.method]) {
        [self logout:call result:result];
    } else if ([METHOD_SHAREMOOD isEqualToString:call.method]) {
        [self shareMood:call result:result];
    } else if ([METHOD_SHARETEXT isEqualToString:call.method]) {
        [self shareText:call result:result];
    } else if ([METHOD_SHAREIMAGE isEqualToString:call.method]) {
        [self shareImage:call result:result];
    } else if ([METHOD_SHAREMUSIC isEqualToString:call.method]) {
        [self shareMusic:call result:result];
    } else if ([METHOD_SHAREWEBPAGE isEqualToString:call.method]) {
        [self shareWebpage:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (_oauth != nil) {
        NSString *scope = call.arguments[ARGUMENT_KEY_SCOPE];
        NSArray *permissions = [scope componentsSeparatedByString:@","];
        [_oauth authorize:permissions];
    }
    result(nil);
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (_oauth != nil) {
        [_oauth logout:self];
    }
    result(nil);
}

- (void)shareMood:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    if (scene.intValue == SCENE_QZONE) {
        NSString *summary = call.arguments[ARGUMENT_KEY_SUMMARY];
        NSArray *imageUris = call.arguments[ARGUMENT_KEY_IMAGEURIS];
        NSString *videoUri = call.arguments[ARGUMENT_KEY_VIDEOURI];

        if (videoUri == nil || videoUri.length == 0) {
            NSMutableArray *imageDatas = [NSMutableArray array];
            if (imageUris != nil && imageUris.count > 0) {
                for (NSString *imageUri in imageUris) {
                    NSURL *imageUrl = [NSURL URLWithString:imageUri];
                    NSData *imageData = [NSData dataWithContentsOfFile:imageUrl.path];
                    [imageDatas addObject:imageData];
                }
            }
            QQApiImageArrayForQZoneObject *object =
                [QQApiImageArrayForQZoneObject objectWithimageDataArray:imageDatas
                                                                  title:summary
                                                                 extMap:nil];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            [QQApiInterface sendReq:req];
        } else {
            QQApiVideoForQZoneObject *object =
                [QQApiVideoForQZoneObject objectWithAssetURL:videoUri
                                                       title:summary
                                                      extMap:nil];
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
            [QQApiInterface sendReq:req];
        }
    }
    result(nil);
}

- (void)shareText:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    if (scene.intValue == SCENE_QQ) {
        NSString *summary = call.arguments[ARGUMENT_KEY_SUMMARY];
        QQApiTextObject *object = [QQApiTextObject objectWithText:summary];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
        [QQApiInterface sendReq:req];
    }
    result(nil);
}

- (void)shareImage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    if (scene.intValue == SCENE_QQ) {
        NSString *imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
        // NSString *appName = call.arguments[ARGUMENT_KEY_APPNAME];
        // NSNumber *extInt = call.arguments[ARGUMENT_KEY_EXTINT];

        NSURL *imageUrl = [NSURL URLWithString:imageUri];
        NSData *imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        QQApiImageObject *object = [QQApiImageObject objectWithData:imageData
                                                   previewImageData:nil
                                                              title:nil
                                                        description:nil];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
        [QQApiInterface sendReq:req];
    }
    result(nil);
}

- (void)shareMusic:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    NSString *title = call.arguments[ARGUMENT_KEY_TITLE];
    NSString *summary = call.arguments[ARGUMENT_KEY_SUMMARY];
    NSString *imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
    NSString *musicUrl = call.arguments[ARGUMENT_KEY_MUSICURL];
    NSString *targetUrl = call.arguments[ARGUMENT_KEY_TARGETURL];
    // NSString *appName = call.arguments[ARGUMENT_KEY_APPNAME];
    // NSNumber *extInt = call.arguments[ARGUMENT_KEY_EXTINT];
    if (scene.intValue == SCENE_QQ) {
        QQApiAudioObject *object = nil;
        NSURL *imageUrl = [NSURL URLWithString:imageUri];
        if ([SCHEME_FILE isEqualToString:imageUrl.scheme]) {
            NSData *imageData = [NSData dataWithContentsOfFile:imageUrl.path];
            object = [QQApiAudioObject objectWithURL:[NSURL URLWithString:targetUrl]
                                               title:title
                                         description:summary
                                    previewImageData:imageData];
        } else {
            object = [QQApiAudioObject objectWithURL:[NSURL URLWithString:targetUrl]
                                               title:title
                                         description:summary
                                     previewImageURL:imageUrl];
        }
        object.flashURL = [NSURL URLWithString:musicUrl];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
        [QQApiInterface sendReq:req];
    }
    result(nil);
}

- (void)shareWebpage:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSNumber *scene = call.arguments[ARGUMENT_KEY_SCENE];
    NSString *title = call.arguments[ARGUMENT_KEY_TITLE];
    NSString *summary = call.arguments[ARGUMENT_KEY_SUMMARY];
    NSString *imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
    NSString *targetUrl = call.arguments[ARGUMENT_KEY_TARGETURL];
    // NSString *appName = call.arguments[ARGUMENT_KEY_APPNAME];
    // NSNumber *extInt = call.arguments[ARGUMENT_KEY_EXTINT];

    QQApiNewsObject *object = nil;
    NSURL *imageUrl = [NSURL URLWithString:imageUri];
    if ([SCHEME_FILE isEqualToString:imageUrl.scheme]) {
        NSData *imageData = [NSData dataWithContentsOfFile:imageUrl.path];
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetUrl]
                                          title:title
                                    description:summary
                               previewImageData:imageData];
    } else {
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetUrl]
                                          title:title
                                    description:summary
                                previewImageURL:imageUrl];
    }
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:object];
    if (scene.intValue == SCENE_QQ) {
        [QQApiInterface sendReq:req];
    } else if (scene.intValue == SCENE_QZONE) {
        [QQApiInterface SendReqToQZone:req];
    }
    result(nil);
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return
        [QQApiInterface handleOpenURL:url
                             delegate:self] ||
        ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    return
        [QQApiInterface handleOpenURL:url
                             delegate:self] ||
        ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
                (NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return
        [QQApiInterface handleOpenURL:url
                             delegate:self] ||
        ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

- (BOOL)application:(UIApplication *)application
    continueUserActivity:(NSUserActivity *)userActivity
      restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    if ([userActivity.activityType
            isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
        if (url != nil) {
            return [QQApiInterface handleOpenUniversallink:url delegate:self] ||
                   ([TencentOAuth CanHandleUniversalLink:url] &&
                    [TencentOAuth HandleUniversalLink:url]);
        }
    }
    return NO;
}

#pragma mark - TencentSessionDelegate

- (void)tencentDidLogin {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (_oauth.accessToken != nil && _oauth.accessToken.length > 0) {
        NSString *openId = _oauth.openId;
        NSString *accessToken = _oauth.accessToken;
        long long expiresIn =
            ceil(_oauth.expirationDate.timeIntervalSinceNow); // 向上取整
        long long createAt = [[NSDate date] timeIntervalSince1970] * 1000.0;
        [dictionary setValue:[NSNumber numberWithInt:RET_SUCCESS]
                      forKey:ARGUMENT_KEY_RESULT_RET];
        [dictionary setValue:openId forKey:ARGUMENT_KEY_RESULT_OPENID];
        [dictionary setValue:accessToken forKey:ARGUMENT_KEY_RESULT_ACCESS_TOKEN];
        [dictionary setValue:[NSNumber numberWithLongLong:expiresIn]
                      forKey:ARGUMENT_KEY_RESULT_EXPIRES_IN];
        [dictionary setValue:[NSNumber numberWithLongLong:createAt]
                      forKey:ARGUMENT_KEY_RESULT_CREATE_AT];
    } else {
        // 登录失败
        [dictionary setValue:[NSNumber numberWithInt:RET_COMMON]
                      forKey:ARGUMENT_KEY_RESULT_RET];
    }
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (cancelled) {
        // 取消登录
        [dictionary setValue:[NSNumber numberWithInt:RET_USERCANCEL]
                      forKey:ARGUMENT_KEY_RESULT_RET];
    } else {
        // 登录失败
        [dictionary setValue:[NSNumber numberWithInt:RET_COMMON]
                      forKey:ARGUMENT_KEY_RESULT_RET];
    }
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

- (void)tencentDidNotNetWork {
    // 登录失败
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:RET_COMMON]
                  forKey:ARGUMENT_KEY_RESULT_RET];
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req {
}

- (void)onResp:(QQBaseResp *)resp {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        switch (resp.result.intValue) {
            case 0:
                // 分享成功
                [dictionary setValue:[NSNumber numberWithInt:RET_SUCCESS]
                              forKey:ARGUMENT_KEY_RESULT_RET];
                break;
            case -4:
                // 用户取消
                [dictionary setValue:[NSNumber numberWithInt:RET_USERCANCEL]
                              forKey:ARGUMENT_KEY_RESULT_RET];
                break;
            default:
                [dictionary setValue:[NSNumber numberWithInt:RET_COMMON]
                              forKey:ARGUMENT_KEY_RESULT_RET];
                NSString *errorMsg =
                    [NSString stringWithFormat:@"result: %@, description: %@.",
                                               resp.result, resp.errorDescription];
                [dictionary setValue:errorMsg forKey:ARGUMENT_KEY_RESULT_MSG];
                break;
        }
        [_channel invokeMethod:METHOD_ONSHARERESP arguments:dictionary];
    }
}

- (void)isOnlineResponse:(NSDictionary *)response {
}

@end
