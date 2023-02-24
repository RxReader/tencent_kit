class TencentScope {
  const TencentScope._();

  /// 发表一条说说到QQ空间(需要申请权限)
  static const String kAddTopic = 'add_topic';

  /// 发表一篇日志到QQ空间(需要申请权限)
  static const String kAddOneBlog = 'add_one_blog';

  /// 创建一个QQ空间相册(需要申请权限)
  static const String kAddAlbum = 'add_album';

  /// 上传一张照片到QQ空间相册(需要申请权限)
  static const String kUploadPic = 'upload_pic';

  /// 获取用户QQ空间相册列表(需要申请权限)
  static const String kListAlbum = 'list_album';

  /// 同步分享到QQ空间、腾讯微博
  static const String kAddShare = 'add_share';

  /// 验证是否认证空间粉丝
  static const String kCheckPageFans = 'check_page_fans';

  /// 获取登录用户自己的详细信息
  static const String kGetInfo = 'get_info';

  /// 获取其他用户的详细信息
  static const String kGetOtherInfo = 'get_other_info';

  /// 获取会员用户基本信息
  static const String kGetVipInfo = 'get_vip_info';

  /// 获取会员用户详细信息
  static const String kGetVipRichInfo = 'get_vip_rich_info';

  /// 获取用户信息
  static const String kGetUserInfo = 'get_user_info';

  /// 移动端获取用户信息
  static const String kGetSimpleUserInfo = 'get_simple_userinfo';

  /// 所有权限
  static const String kAll = 'all';
}

class TencentScene {
  const TencentScene._();

  /// QQ
  static const int kScene_QQ = 0;

  /// QZone
  static const int kScene_QZone = 1;
}

class TencentQZoneFlag {
  const TencentQZoneFlag._();

  /// 默认是不隐藏分享到QZone按钮且不自动打开分享到QZone的对话框
  static const int kDefault = 0;

  /// 分享时自动打开分享到QZone的对话框
  static const int kAutoOpen = 1;

  /// 分享时隐藏分享到QZone按钮
  static const int kItemHide = 2;
}
