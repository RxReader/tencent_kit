import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/sdk/tencent_sdk_resp.dart';

part 'tencent_login_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentLoginResp extends TencentSdkResp {
  const TencentLoginResp({
    required int ret,
    String? msg,
    this.openid,
    this.accessToken,
    this.expiresIn,
    this.createAt,
  }) : super(ret: ret, msg: msg);

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
