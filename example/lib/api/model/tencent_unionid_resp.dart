import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tencent_unionid_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentUnionidResp {
  const TencentUnionidResp({
    required this.error,
    this.errorDescription,
    this.clientId,
    this.openid,
    this.unionid,
  });

  factory TencentUnionidResp.fromJson(Map<String, dynamic> json) =>
      _$TencentUnionidRespFromJson(json);

  @JsonKey(
    defaultValue: ERROR_SUCCESS,
  )
  final int error;
  final String? errorDescription;
  final String? clientId;
  final String? openid;
  final String? unionid;

  static const int ERROR_SUCCESS = 0;

  bool get isSuccessful => error == ERROR_SUCCESS;

  Map<String, dynamic> toJson() => _$TencentUnionidRespToJson(this);

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
