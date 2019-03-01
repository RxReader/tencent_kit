import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class FakeTencentScope {
  FakeTencentScope._();

  /// 发表一条说说到QQ空间(需要申请权限)
  static const String OPEN_PERMISSION_ADD_TOPIC = 'add_topic';

  /// 发表一篇日志到QQ空间(需要申请权限)
  static const String OPEN_PERMISSION_ADD_ONE_BLOG = 'add_one_blog';

  /// 创建一个QQ空间相册(需要申请权限)
  static const String OPEN_PERMISSION_ADD_ALBUM = 'add_album';

  /// 上传一张照片到QQ空间相册(需要申请权限)
  static const String OPEN_PERMISSION_UPLOAD_PIC = 'upload_pic';

  /// 获取用户QQ空间相册列表(需要申请权限)
  static const String OPEN_PERMISSION_LIST_ALBUM = 'list_album';

  /// 同步分享到QQ空间、腾讯微博
  static const String OPEN_PERMISSION_ADD_SHARE = 'add_share';

  /// 验证是否认证空间粉丝
  static const String OPEN_PERMISSION_CHECK_PAGE_FANS = 'check_page_fans';

  /// 获取登录用户自己的详细信息
  static const String OPEN_PERMISSION_GET_INFO = 'get_info';

  /// 获取其他用户的详细信息
  static const String OPEN_PERMISSION_GET_OTHER_INFO = 'get_other_info';

  /// 获取会员用户基本信息
  static const String OPEN_PERMISSION_GET_VIP_INFO = 'get_vip_info';

  /// 获取会员用户详细信息
  static const String OPEN_PERMISSION_GET_VIP_RICH_INFO = 'get_vip_rich_info';

  /// 获取用户信息
  static const String GET_USER_INFO = 'get_user_info';

  /// 移动端获取用户信息
  static const String GET_SIMPLE_USERINFO = 'get_simple_userinfo';

  /// 所有权限
  static const String ALL = 'all';
}

class FakeTencentScene {
  FakeTencentScene._();

  /// QQ
  static const int SCENE_QQ = 0;

  /// QZone
  static const int SCENE_QZONE = 1;
}

class FakeTencentQZoneFlag {
  FakeTencentQZoneFlag._();

  /// 默认是不隐藏分享到QZone按钮且不自动打开分享到QZone的对话框
  static const int DEFAULT = 0;

  /// 分享时自动打开分享到QZone的对话框
  static const int AUTO_OPEN = 1;

  /// 分享时隐藏分享到QZone按钮
  static const int ITEM_HIDE = 2;
}

class FakeTencentErrorCode {
  FakeTencentErrorCode._();

  static const int ERRORCODE_SUCCESS = 0;
  static const int ERRORCODE_COMMON = -1;
  static const int ERRORCODE_USERCANCEL = -2;
}

abstract class FakeTencentBaseResp {
  FakeTencentBaseResp({
    @required this.errorCode,
    @required this.errorMsg,
  });

  final int errorCode;
  final String errorMsg;
}

class FakeTencentLoginResp extends FakeTencentBaseResp {
  FakeTencentLoginResp._({
    @required int errorCode,
    @required String errorMsg,
    this.openId,
    this.accessToken,
    this.expirationDate,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String openId;
  final String accessToken;
  final int expirationDate;
}

class FakeTencentUserInfoResp extends FakeTencentBaseResp {
  FakeTencentUserInfoResp._({
    @required int errorCode,
    @required String errorMsg,
    this.nickName,
    this.gender,
    this.figureurlQQ1,
    this.figureurlQQ2,
    this.figureurl1,
    this.figureurl2,
    this.figureurl,
    this.vip,
    this.level,
    this.isYellowVip,
    this.isYellowYearVip,
    this.yellowVipLevel,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);

  final String nickName;

  /// 男/女
  final String gender;
  final String figureurlQQ1;
  final String figureurlQQ2;
  final String figureurl1;
  final String figureurl2;
  final String figureurl;
  final String vip;
  final String level;
  final String isYellowVip;
  final String isYellowYearVip;
  final String yellowVipLevel;

  bool isMale() {
    return gender == '男';
  }

  bool isFemale() {
    return gender == '女';
  }

  String headImgUrl() {
    if (figureurlQQ2 != null && figureurlQQ2.isNotEmpty) {
      return figureurlQQ2;
    }
    if (figureurlQQ1 != null && figureurlQQ1.isNotEmpty) {
      return figureurlQQ1;
    }
    if (figureurl2 != null && figureurl2.isNotEmpty) {
      return figureurl2;
    }
    if (figureurl1 != null && figureurl1.isNotEmpty) {
      return figureurl1;
    }
    return figureurl;
  }
}

class FakeTencentShareResp extends FakeTencentBaseResp {
  FakeTencentShareResp._({
    @required int errorCode,
    @required String errorMsg,
  }) : super(errorCode: errorCode, errorMsg: errorMsg);
}

class FakeTencent {
  static const String _METHOD_REGISTERAPP = 'registerApp';
  static const String _METHOD_ISQQINSTALLED = 'isQQInstalled';
  static const String _METHOD_ISQQSUPPORTSSOLOGIN = 'isQQSupportSSOLogin';
  static const String _METHOD_SETACCESSTOKEN = 'setAccessToken';
  static const String _METHOD_LOGIN = 'login';
  static const String _METHOD_LOGOUT = 'logout';
  static const String _METHOD_GETUSERINFO = 'getUserInfo';
  static const String _METHOD_SHAREMOOD = 'shareMood';
  static const String _METHOD_SHAREIMAGE = 'shareImage';
  static const String _METHOD_SHAREMUSIC = 'shareMusic';
  static const String _METHOD_SHAREWEBPAGE = 'shareWebpage';

  static const String _METHOD_ONLOGINRESP = 'onLoginResp';
  static const String _METHOD_ONGETUSERINFORESP = 'onGetUserInfoResp';
  static const String _METHOD_ONSHARERESP = "onShareResp";

  static const String _ARGUMENT_KEY_APPID = 'appId';
  static const String _ARGUMENT_KEY_OPENID = 'openId';
  static const String _ARGUMENT_KEY_ACCESSTOKEN = 'accessToken';
  static const String _ARGUMENT_KEY_EXPIRATIONDATE = 'expirationDate';
  static const String _ARGUMENT_KEY_SCOPE = 'scope';
  static const String _ARGUMENT_KEY_SCENE = 'scene';
  static const String _ARGUMENT_KEY_TITLE = 'title';
  static const String _ARGUMENT_KEY_SUMMARY = 'summary';
  static const String _ARGUMENT_KEY_IMAGEURI = 'imageUri';
  static const String _ARGUMENT_KEY_IMAGEURIS = 'imageUris';
  static const String _ARGUMENT_KEY_VIDEOURI = 'videoUri';
  static const String _ARGUMENT_KEY_MUSICURL = 'musicUrl';
  static const String _ARGUMENT_KEY_TARGETURL = 'targetUrl';
  static const String _ARGUMENT_KEY_APPNAME = 'appName';
  static const String _ARGUMENT_KEY_EXTINT = 'extInt';

  static const String _ARGUMENT_KEY_RESULT_ERRORCODE = 'errorCode';
  static const String _ARGUMENT_KEY_RESULT_ERRORMSG = 'errorMsg';
  static const String _ARGUMENT_KEY_RESULT_OPENID = 'openId';
  static const String _ARGUMENT_KEY_RESULT_ACCESSTOKEN = 'accessToken';
  static const String _ARGUMENT_KEY_RESULT_EXPIRATIONDATE = 'expirationDate';

  static const String _ARGUMENT_KEY_RESULT_NICKNAME = 'nickname';
  static const String _ARGUMENT_KEY_RESULT_GENDER = 'gender';
  static const String _ARGUMENT_KEY_RESULT_FIGUREURL_QQ_1 = 'figureurl_qq_1';
  static const String _ARGUMENT_KEY_RESULT_FIGUREURL_QQ_2 = 'figureurl_qq_2';
  static const String _ARGUMENT_KEY_RESULT_FIGUREURL_1 = 'figureurl_1';
  static const String _ARGUMENT_KEY_RESULT_FIGUREURL_2 = 'figureurl_2';
  static const String _ARGUMENT_KEY_RESULT_FIGUREURL = 'figureurl';
  static const String _ARGUMENT_KEY_RESULT_VIP = 'vip';
  static const String _ARGUMENT_KEY_RESULT_LEVEL = 'level';
  static const String _ARGUMENT_KEY_RESULT_IS_YELLOW_VIP = 'is_yellow_vip';
  static const String _ARGUMENT_KEY_RESULT_IS_YELLOW_YEAR_VIP =
      'is_yellow_year_vip';
  static const String _ARGUMENT_KEY_RESULT_YELLOW_VIP_LEVEL =
      'yellow_vip_level';

  static const String _SCHEME_FILE = 'file';

  static const MethodChannel _channel =
      MethodChannel('v7lin.github.io/fake_tencent');

  final StreamController<FakeTencentLoginResp> _loginRespStreamController =
      StreamController<FakeTencentLoginResp>.broadcast();

  final StreamController<FakeTencentUserInfoResp>
      _userInfoRespStreamController =
      StreamController<FakeTencentUserInfoResp>.broadcast();

  final StreamController<FakeTencentShareResp> _shareRespStreamController =
      StreamController<FakeTencentShareResp>.broadcast();

  Future<void> registerApp({
    @required String appId,
  }) {
    assert(appId != null && appId.isNotEmpty);
    _channel.setMethodCallHandler(_handleMethod);
    return _channel.invokeMethod(
      _METHOD_REGISTERAPP,
      <String, dynamic>{
        _ARGUMENT_KEY_APPID: appId,
      },
    );
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case _METHOD_ONLOGINRESP:
        _loginRespStreamController.add(FakeTencentLoginResp._(
          errorCode: call.arguments[_ARGUMENT_KEY_RESULT_ERRORCODE] as int,
          errorMsg: call.arguments[_ARGUMENT_KEY_RESULT_ERRORMSG] as String,
          openId: call.arguments[_ARGUMENT_KEY_RESULT_OPENID] as String,
          accessToken:
              call.arguments[_ARGUMENT_KEY_RESULT_ACCESSTOKEN] as String,
          expirationDate:
              call.arguments[_ARGUMENT_KEY_RESULT_EXPIRATIONDATE] as int,
        ));
        break;
      case _METHOD_ONGETUSERINFORESP:
        _userInfoRespStreamController.add(FakeTencentUserInfoResp._(
          errorCode: call.arguments[_ARGUMENT_KEY_RESULT_ERRORCODE] as int,
          errorMsg: call.arguments[_ARGUMENT_KEY_RESULT_ERRORMSG] as String,
          nickName: call.arguments[_ARGUMENT_KEY_RESULT_NICKNAME] as String,
          gender: call.arguments[_ARGUMENT_KEY_RESULT_GENDER] as String,
          figureurlQQ1:
              call.arguments[_ARGUMENT_KEY_RESULT_FIGUREURL_QQ_1] as String,
          figureurlQQ2:
              call.arguments[_ARGUMENT_KEY_RESULT_FIGUREURL_QQ_2] as String,
          figureurl1:
              call.arguments[_ARGUMENT_KEY_RESULT_FIGUREURL_1] as String,
          figureurl2:
              call.arguments[_ARGUMENT_KEY_RESULT_FIGUREURL_2] as String,
          figureurl: call.arguments[_ARGUMENT_KEY_RESULT_FIGUREURL] as String,
          vip: call.arguments[_ARGUMENT_KEY_RESULT_VIP] as String,
          level: call.arguments[_ARGUMENT_KEY_RESULT_LEVEL] as String,
          isYellowVip:
              call.arguments[_ARGUMENT_KEY_RESULT_IS_YELLOW_VIP] as String,
          isYellowYearVip:
              call.arguments[_ARGUMENT_KEY_RESULT_IS_YELLOW_YEAR_VIP] as String,
          yellowVipLevel:
              call.arguments[_ARGUMENT_KEY_RESULT_YELLOW_VIP_LEVEL] as String,
        ));
        break;
      case _METHOD_ONSHARERESP:
        _shareRespStreamController.add(FakeTencentShareResp._(
          errorCode: call.arguments[_ARGUMENT_KEY_RESULT_ERRORCODE] as int,
          errorMsg: call.arguments[_ARGUMENT_KEY_RESULT_ERRORMSG] as String,
        ));
        break;
    }
  }

  Stream<FakeTencentLoginResp> loginResp() {
    return _loginRespStreamController.stream;
  }

  Stream<FakeTencentUserInfoResp> userInfoResp() {
    return _userInfoRespStreamController.stream;
  }

  Stream<FakeTencentShareResp> shareResp() {
    return _shareRespStreamController.stream;
  }

  Future<bool> isQQInstalled() async {
    return (await _channel.invokeMethod(_METHOD_ISQQINSTALLED)) as bool;
  }

  Future<bool> isQQSupportSSOLogin() async {
    return (await _channel.invokeMethod(_METHOD_ISQQSUPPORTSSOLOGIN)) as bool;
  }

  Future<void> setAccessToken({
    @required String openId,
    @required String accessToken,
    @required int expirationDate,
  }) {
    assert(openId != null && openId.isNotEmpty);
    assert(accessToken != null && accessToken.isNotEmpty);
    return _channel.invokeMethod(
      _METHOD_SETACCESSTOKEN,
      <String, dynamic>{
        _ARGUMENT_KEY_OPENID: openId,
        _ARGUMENT_KEY_ACCESSTOKEN: accessToken,
        _ARGUMENT_KEY_EXPIRATIONDATE: expirationDate,
      },
    );
  }

  Future<void> login({
    @required List<String> scope,
  }) {
    assert(scope != null && scope.isNotEmpty);
    return _channel.invokeMethod(
      _METHOD_LOGIN,
      <String, dynamic>{
        _ARGUMENT_KEY_SCOPE: scope.join(','),
      },
    );
  }

  Future<void> logout() {
    return _channel.invokeMethod(_METHOD_LOGOUT);
  }

  Future<void> getUserInfo() {
    return _channel.invokeMethod(_METHOD_GETUSERINFO);
  }

  Future<void> shareMood({
    @required int scene,
    String summary,
    List<Uri> imageUris,
    Uri videoUri,
  }) {
    assert(scene == FakeTencentScene.SCENE_QZONE);
    assert((summary != null && summary.isNotEmpty) ||
        (imageUris != null && imageUris.isNotEmpty) ||
        (videoUri != null && videoUri.isScheme(_SCHEME_FILE)));
    if (imageUris != null && imageUris.isNotEmpty) {
      imageUris.forEach((Uri imageUri) {
        assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
      });
    }
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURIS: imageUris != null ? new List.generate(imageUris.length, (int index) {
//        return imageUris[index].toString();
//      }) : null,
//      _ARGUMENT_KEY_VIDEOURI: videoUri != null ? videoUri.toString() : null,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_SUMMARY, () => summary);
    }
    if (imageUris != null && imageUris.isNotEmpty) {
      map.putIfAbsent(
          _ARGUMENT_KEY_IMAGEURIS,
          () => List<String>.generate(imageUris.length, (int index) {
                return imageUris[index].toString();
              }));
    }
    if (videoUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_VIDEOURI, () => videoUri.toString());
    }
    return _channel.invokeMethod(_METHOD_SHAREMOOD, map);
  }

  Future<void> shareImage({
    @required int scene,
    @required Uri imageUri,
    String appName,
    int extInt = FakeTencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == FakeTencentScene.SCENE_QQ);
    assert(imageUri != null && imageUri.isScheme(_SCHEME_FILE));
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_IMAGEURI: imageUri.toString(),
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREIMAGE, map);
  }

  Future<void> shareMusic({
    @required int scene,
    @required String title,
    String summary,
    Uri imageUri,
    @required String musicUrl,
    @required String targetUrl,
    String appName,
    int extInt = FakeTencentQZoneFlag.DEFAULT,
  }) {
    assert(scene == FakeTencentScene.SCENE_QQ);
    assert(title != null && title.isNotEmpty);
    assert(musicUrl != null && musicUrl.isNotEmpty);
    assert(targetUrl != null && targetUrl.isNotEmpty);
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURI: imageUri != null ? imageUri.toString() : null,
      _ARGUMENT_KEY_MUSICURL: musicUrl,
      _ARGUMENT_KEY_TARGETURL: targetUrl,
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (summary != null && summary.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_SUMMARY, () => summary);
    }
    if (imageUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_IMAGEURI, () => imageUri.toString());
    }
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREMUSIC, map);
  }

  Future<void> shareWebpage({
    @required int scene,
    @required String title,
    String summary,
    Uri imageUri,
    @required String targetUrl,
    String appName,
    int extInt = FakeTencentQZoneFlag.DEFAULT,
  }) {
    assert(title != null && title.isNotEmpty);
    assert(targetUrl != null && targetUrl.isNotEmpty);
    Map<String, dynamic> map = <String, dynamic>{
      _ARGUMENT_KEY_SCENE: scene,
      _ARGUMENT_KEY_TITLE: title,
//      _ARGUMENT_KEY_SUMMARY: summary,
//      _ARGUMENT_KEY_IMAGEURI: imageUri != null ? imageUri.toString() : null,
      _ARGUMENT_KEY_TARGETURL: targetUrl,
//      _ARGUMENT_KEY_APPNAME: appName,
      _ARGUMENT_KEY_EXTINT: extInt,
    };

    /// 兼容 iOS 空安全 -> NSNull
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    if (imageUri != null) {
      map.putIfAbsent(_ARGUMENT_KEY_IMAGEURI, () => imageUri.toString());
    }
    if (appName != null && appName.isNotEmpty) {
      map.putIfAbsent(_ARGUMENT_KEY_APPNAME, () => appName);
    }
    return _channel.invokeMethod(_METHOD_SHAREWEBPAGE, map);
  }
}

class FakeTencentProvider extends InheritedWidget {
  FakeTencentProvider({
    Key key,
    @required this.tencent,
    @required Widget child,
  }) : super(key: key, child: child);

  final FakeTencent tencent;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    FakeTencentProvider oldProvider = oldWidget as FakeTencentProvider;
    return tencent != oldProvider.tencent;
  }

  static FakeTencentProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(FakeTencentProvider)
        as FakeTencentProvider;
  }
}
