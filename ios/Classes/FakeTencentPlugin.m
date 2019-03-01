#import "FakeTencentPlugin.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface FakeTencentPlugin () <TencentSessionDelegate, QQApiInterfaceDelegate>

@end

enum FakeTencentScene {
    SCENE_QQ = 0,
    SCENE_QZONE = 1,
};

enum FakeTencentErrorCode {
    ERRORCODE_SUCCESS = 0,
    ERRORCODE_COMMON = -1,
    ERRORCODE_USERCANCEL = -2,
};

@implementation FakeTencentPlugin {
    FlutterMethodChannel * _channel;
    TencentOAuth * _oauth;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"v7lin.github.io/fake_tencent"
                                     binaryMessenger:[registrar messenger]];
    FakeTencentPlugin* instance = [[FakeTencentPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

static NSString * const METHOD_REGISTERAPP = @"registerApp";
static NSString * const METHOD_ISQQINSTALLED = @"isQQInstalled";
static NSString * const METHOD_ISQQSUPPORTSSOLOGIN = @"isQQSupportSSOLogin";
static NSString * const METHOD_SETACCESSTOKEN = @"setAccessToken";
static NSString * const METHOD_LOGIN = @"login";
static NSString * const METHOD_LOGOUT = @"logout";
static NSString * const METHOD_GETUSERINFO = @"getUserInfo";
static NSString * const METHOD_SHAREMOOD = @"shareMood";
static NSString * const METHOD_SHAREIMAGE = @"shareImage";
static NSString * const METHOD_SHAREMUSIC = @"shareMusic";
static NSString * const METHOD_SHAREWEBPAGE = @"shareWebpage";

static NSString * const METHOD_ONLOGINRESP = @"onLoginResp";
static NSString * const METHOD_ONGETUSERINFORESP = @"onGetUserInfoResp";
static NSString * const METHOD_ONSHARERESP = @"onShareResp";

static NSString * const ARGUMENT_KEY_APPID = @"appId";
static NSString * const ARGUMENT_KEY_OPENID = @"openId";
static NSString * const ARGUMENT_KEY_ACCESSTOKEN = @"accessToken";
static NSString * const ARGUMENT_KEY_EXPIRATIONDATE = @"expirationDate";
static NSString * const ARGUMENT_KEY_SCOPE = @"scope";
static NSString * const ARGUMENT_KEY_SCENE = @"scene";
static NSString * const ARGUMENT_KEY_TITLE = @"title";
static NSString * const ARGUMENT_KEY_SUMMARY = @"summary";
static NSString * const ARGUMENT_KEY_IMAGEURI = @"imageUri";
static NSString * const ARGUMENT_KEY_IMAGEURIS = @"imageUris";
static NSString * const ARGUMENT_KEY_VIDEOURI = @"videoUri";
static NSString * const ARGUMENT_KEY_MUSICURL = @"musicUrl";
static NSString * const ARGUMENT_KEY_TARGETURL = @"targetUrl";
static NSString * const ARGUMENT_KEY_APPNAME = @"appName";
static NSString * const ARGUMENT_KEY_EXTINT = @"extInt";

static NSString * const ARGUMENT_KEY_RESULT_ERRORCODE = @"errorCode";
static NSString * const ARGUMENT_KEY_RESULT_ERRORMSG = @"errorMsg";
static NSString * const ARGUMENT_KEY_RESULT_OPENID = @"openId";
static NSString * const ARGUMENT_KEY_RESULT_ACCESSTOKEN = @"accessToken";
static NSString * const ARGUMENT_KEY_RESULT_EXPIRATIONDATE = @"expirationDate";

static NSString * const SCHEME_FILE = @"file";

-(instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([METHOD_REGISTERAPP isEqualToString:call.method]) {
        NSString * appId = call.arguments[ARGUMENT_KEY_APPID];
        _oauth = [[TencentOAuth alloc] initWithAppId:appId andDelegate:self];
        result(nil);
    } else if ([METHOD_ISQQINSTALLED isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[TencentOAuth iphoneQQInstalled]]);
    } else if ([METHOD_ISQQSUPPORTSSOLOGIN isEqualToString:call.method]) {
        result([NSNumber numberWithBool:[TencentOAuth iphoneQQSupportSSOLogin]]);
    } else if ([METHOD_SETACCESSTOKEN isEqualToString:call.method]) {
        [self setAccessToken:call result:result];
    } else if ([METHOD_LOGIN isEqualToString:call.method]) {
        [self login:call result:result];
    } else if ([METHOD_LOGOUT isEqualToString:call.method]) {
        [self logout:call result:result];
    } else if ([METHOD_GETUSERINFO isEqualToString:call.method]) {
        [self getUserInfo:call result:result];
    } else if ([METHOD_SHAREMOOD isEqualToString:call.method]) {
        [self shareMood:call result:result];
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

-(void)setAccessToken:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString * openId = call.arguments[ARGUMENT_KEY_OPENID];
    NSString * accessToken = call.arguments[ARGUMENT_KEY_ACCESSTOKEN];
    NSNumber * expirationDate = call.arguments[ARGUMENT_KEY_EXPIRATIONDATE];
    NSTimeInterval seconds = expirationDate.longLongValue / 1000.0;
    [_oauth setOpenId:openId];
    [_oauth setAccessToken:accessToken];
    [_oauth setExpirationDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
    result(nil);
}

-(void)login:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString * scope = call.arguments[ARGUMENT_KEY_SCOPE];
    NSArray * permissions = [scope componentsSeparatedByString:@","];
    [_oauth authorize:permissions];
    result(nil);
}

-(void)logout:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_oauth logout:self];
    result(nil);
}

-(void)getUserInfo:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_oauth getUserInfo];
    result(nil);
}

-(void)shareMood:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber * scene = call.arguments[ARGUMENT_KEY_SCENE];
    if (scene.intValue == SCENE_QZONE) {
        NSString * summary = call.arguments[ARGUMENT_KEY_SUMMARY];
        NSArray * imageUris = call.arguments[ARGUMENT_KEY_IMAGEURIS];
        NSString * videoUri = call.arguments[ARGUMENT_KEY_VIDEOURI];
        
        if (videoUri == nil || videoUri.length == 0) {
            NSMutableArray * imageDatas = [NSMutableArray array];
            if (imageUris != nil && imageUris.count > 0) {
                for (NSString * imageUri in imageUris) {
                    UIImage *image = [UIImage imageWithContentsOfFile:[NSURL URLWithString:imageUri].path];
                    NSData * imageData = UIImagePNGRepresentation(image);
                    if (imageData == nil) {
                        imageData = UIImageJPEGRepresentation(image, 1);
                    }
                    [imageDatas addObject:imageData];
                }
            }
            QQApiImageArrayForQZoneObject * object = [QQApiImageArrayForQZoneObject objectWithimageDataArray:imageDatas title:summary extMap:nil];
            SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent: object];
            [QQApiInterface sendReq:req];
        } else {
            QQApiVideoForQZoneObject * object = [QQApiVideoForQZoneObject objectWithAssetURL:videoUri title:summary extMap:nil];
            SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent: object];
            [QQApiInterface sendReq:req];
        }
    }
    result(nil);
}

-(void)shareImage:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber * scene = call.arguments[ARGUMENT_KEY_SCENE];
    if (scene.intValue == SCENE_QQ) {
        NSString * imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
//        NSString * appName = call.arguments[ARGUMENT_KEY_APPNAME];
//        NSNumber * extInt = call.arguments[ARGUMENT_KEY_EXTINT];
        
        UIImage *image = [UIImage imageWithContentsOfFile:[NSURL URLWithString:imageUri].path];
        NSData * imageData = UIImagePNGRepresentation(image);
        NSData * thumbData = nil;
        if (imageData == nil) {
            imageData = UIImageJPEGRepresentation(image, 1);
            thumbData = UIImageJPEGRepresentation(image, 0.2);
        } else {
            thumbData = imageData;
        }
        QQApiImageObject * object = [QQApiImageObject objectWithData:imageData previewImageData:thumbData title:nil description:nil];
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent: object];
        [QQApiInterface sendReq:req];
    }
    result(nil);
}

-(void)shareMusic:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber * scene = call.arguments[ARGUMENT_KEY_SCENE];
    NSString * title = call.arguments[ARGUMENT_KEY_TITLE];
    NSString * summary = call.arguments[ARGUMENT_KEY_SUMMARY];
    NSString * imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
    NSString * musicUrl = call.arguments[ARGUMENT_KEY_MUSICURL];
    NSString * targetUrl = call.arguments[ARGUMENT_KEY_TARGETURL];
//    NSString * appName = call.arguments[ARGUMENT_KEY_APPNAME];
//    NSNumber * extInt = call.arguments[ARGUMENT_KEY_EXTINT];
    if (scene.intValue == SCENE_QQ) {
        QQApiAudioObject * object = nil;
        NSURL * uri = [NSURL URLWithString:imageUri];
        if ([SCHEME_FILE isEqualToString:uri.scheme]) {
            UIImage *image = [UIImage imageWithContentsOfFile:uri.path];
            NSData * imageData = UIImagePNGRepresentation(image);
            if (imageData == nil) {
                imageData = UIImageJPEGRepresentation(image, 1);
            }
            object = [QQApiAudioObject objectWithURL:[NSURL URLWithString:targetUrl] title:title description:summary previewImageData:imageData];
        } else {
            object = [QQApiAudioObject objectWithURL:[NSURL URLWithString:targetUrl] title:title description:summary previewImageURL:[NSURL URLWithString:musicUrl]];
        }
        SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent: object];
        [QQApiInterface sendReq:req];
    }
    result(nil);
}

-(void)shareWebpage:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber * scene = call.arguments[ARGUMENT_KEY_SCENE];
    NSString * title = call.arguments[ARGUMENT_KEY_TITLE];
    NSString * summary = call.arguments[ARGUMENT_KEY_SUMMARY];
    NSString * imageUri = call.arguments[ARGUMENT_KEY_IMAGEURI];
    NSString * targetUrl = call.arguments[ARGUMENT_KEY_TARGETURL];
//    NSString * appName = call.arguments[ARGUMENT_KEY_APPNAME];
//    NSNumber * extInt = call.arguments[ARGUMENT_KEY_EXTINT];
    
    QQApiNewsObject * object = nil;
    NSURL * uri = [NSURL URLWithString:imageUri];
    if ([SCHEME_FILE isEqualToString:uri.scheme]) {
        UIImage *image = [UIImage imageWithContentsOfFile:uri.path];
        NSData * imageData = UIImagePNGRepresentation(image);
        if (imageData == nil) {
            imageData = UIImageJPEGRepresentation(image, 1);
        }
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetUrl] title:title description:summary previewImageData:imageData];
    } else {
        object = [QQApiNewsObject objectWithURL:[NSURL URLWithString:targetUrl] title:title description:summary previewImageURL:[NSURL URLWithString:imageUri]];
    }
    SendMessageToQQReq * req = [SendMessageToQQReq reqWithContent: object];
    if (scene.intValue == SCENE_QQ) {
        [QQApiInterface sendReq:req];
    } else if (scene.intValue == SCENE_QZONE) {
        [QQApiInterface SendReqToQZone:req];
    }
    result(nil);
}

# pragma mark - AppDelegate

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [QQApiInterface handleOpenURL:url delegate:self] || ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [QQApiInterface handleOpenURL:url delegate:self] || ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [QQApiInterface handleOpenURL:url delegate:self] || ([TencentOAuth CanHandleOpenURL:url] && [TencentOAuth HandleOpenURL:url]);
}

# pragma mark - TencentSessionDelegate

-(void)tencentDidLogin {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if (_oauth.accessToken != nil && _oauth.accessToken.length > 0) {
        NSString * openId = _oauth.openId;
        NSString * accessToken = _oauth.accessToken;
        long long expirationDate = _oauth.expirationDate.timeIntervalSince1970 * 1000;
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_SUCCESS] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
        [dictionary setValue:openId forKey:ARGUMENT_KEY_RESULT_OPENID];
        [dictionary setValue:accessToken forKey:ARGUMENT_KEY_RESULT_ACCESSTOKEN];
        [dictionary setValue:[NSNumber numberWithLongLong:expirationDate] forKey:ARGUMENT_KEY_RESULT_EXPIRATIONDATE];
    } else {
        // 登录失败
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_COMMON] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    }
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

-(void)tencentDidNotLogin:(BOOL)cancelled {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if (cancelled) {
        // 取消登录
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_USERCANCEL] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    } else {
        // 登录失败
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_COMMON] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    }
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

-(void)tencentDidNotNetWork {
    // 登录失败
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_COMMON] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
    [_channel invokeMethod:METHOD_ONLOGINRESP arguments:dictionary];
}

-(void)getUserInfoResponse:(APIResponse *)response {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if (response.retCode == URLREQUEST_SUCCEED) {
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_SUCCESS] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
        NSDictionary * json = response.jsonResponse;
        [dictionary addEntriesFromDictionary:json];
    } else {
        [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_COMMON] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
        [dictionary setValue:response.errorMsg forKey:ARGUMENT_KEY_RESULT_ERRORMSG];
    }
    [_channel invokeMethod:METHOD_ONGETUSERINFORESP arguments:dictionary];
}

# pragma mark - QQApiInterfaceDelegate

-(void)onReq:(QQBaseReq *)req {
    
}

- (void)onResp:(QQBaseResp *)resp {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        switch (resp.result.intValue) {
            case 0:
                // 分享成功
                [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_SUCCESS] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
                break;
            case -4:
                // 用户取消
                [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_USERCANCEL] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
                break;
            default:
                [dictionary setValue:[NSNumber numberWithInt:ERRORCODE_COMMON] forKey:ARGUMENT_KEY_RESULT_ERRORCODE];
                NSString * errorMsg = [NSString stringWithFormat:@"result: %@, description: %@.", resp.result, resp.errorDescription];
                [dictionary setValue:errorMsg forKey:ARGUMENT_KEY_RESULT_ERRORMSG];
                break;
        }
        [_channel invokeMethod:METHOD_ONSHARERESP arguments:dictionary];
    }
}

-(void)isOnlineResponse:(NSDictionary *)response {
    
}

@end
