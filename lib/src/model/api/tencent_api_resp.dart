import 'package:json_annotation/json_annotation.dart';

abstract class TencentApiResp {
  TencentApiResp({
    this.ret,
    this.msg,
  });

  /// 网络请求成功发送至服务器，并且服务器返回数据格式正确
  /// 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
  static const int RET_SUCCESS = 0;

  @JsonKey(
    defaultValue: RET_SUCCESS,
  )
  final int ret;
  final String msg;

  bool isSuccessful() => ret == RET_SUCCESS;
}
