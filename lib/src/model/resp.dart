import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'resp.g.dart';

abstract class TencentResp {
  const TencentResp({
    required this.ret,
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
  final String? msg;

  bool get isSuccessful => ret == RET_SUCCESS;

  bool get isCancelled => ret == RET_USERCANCEL;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentLoginResp extends TencentResp {
  const TencentLoginResp({
    required super.ret,
    super.msg,
    this.openid,
    this.accessToken,
    this.expiresIn,
    this.createAt,
  });

  factory TencentLoginResp.fromJson(Map<String, dynamic> json) =>
      _$TencentLoginRespFromJson(json);

  final String? openid;
  final String? accessToken;
  final int? expiresIn;
  final int? createAt;

  bool? get isExpired => isSuccessful
      ? DateTime.now().millisecondsSinceEpoch - createAt! >= expiresIn! * 1000
      : null;

  @override
  Map<String, dynamic> toJson() => _$TencentLoginRespToJson(this);
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentShareMsgResp extends TencentResp {
  const TencentShareMsgResp({
    required super.ret,
    super.msg,
  });

  factory TencentShareMsgResp.fromJson(Map<String, dynamic> json) =>
      _$TencentShareMsgRespFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TencentShareMsgRespToJson(this);
}
