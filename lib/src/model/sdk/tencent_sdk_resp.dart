import 'package:json_annotation/json_annotation.dart';

abstract class TencentSdkResp {
  TencentSdkResp({
    this.ret,
    this.msg,
  });

  /// 网络请求成功发送至服务器，并且服务器返回数据格式正确
  /// 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
  static const int RET_SUCCESS = 0;

  /// 网络异常，或服务器返回的数据格式不正确导致无法解析
  static const int RET_FAILED = 1;

  static const int RET_COMMON = -1;

  static const int RET_USERCANCEL = -2;

  @JsonKey(
    defaultValue: RET_SUCCESS,
  )
  final int ret;
  final String msg;

  bool isSuccessful() => ret == RET_SUCCESS;
}
