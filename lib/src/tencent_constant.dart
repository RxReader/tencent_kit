class TencentScope {
  TencentScope._();

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

class TencentScene {
  TencentScene._();

  /// QQ
  static const int SCENE_QQ = 0;

  /// QZone
  static const int SCENE_QZONE = 1;
}

class TencentQZoneFlag {
  TencentQZoneFlag._();

  /// 默认是不隐藏分享到QZone按钮且不自动打开分享到QZone的对话框
  static const int DEFAULT = 0;

  /// 分享时自动打开分享到QZone的对话框
  static const int AUTO_OPEN = 1;

  /// 分享时隐藏分享到QZone按钮
  static const int ITEM_HIDE = 2;
}
