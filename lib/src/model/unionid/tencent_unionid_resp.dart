import 'package:json_annotation/json_annotation.dart';

part 'tencent_unionid_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentUnionidResp {
  TencentUnionidResp({
    this.error,
    this.errorDescription,
    this.clientId,
    this.openid,
    this.unionid,
  });

  factory TencentUnionidResp.fromJson(Map<dynamic, dynamic> json) =>
      _$TencentUnionidRespFromJson(json);

  @JsonKey(
    defaultValue: ERROR_SUCCESS,
  )
  final int error;
  final String errorDescription;
  final String clientId;
  final String openid;
  final String unionid;

  static const int ERROR_SUCCESS = 0;

  bool isSuccessful() => error == ERROR_SUCCESS;

  Map<dynamic, dynamic> toJson() => _$TencentUnionidRespToJson(this);
}
