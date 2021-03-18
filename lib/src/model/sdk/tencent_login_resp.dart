import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/sdk/tencent_sdk_resp.dart';

part 'tencent_login_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentLoginResp extends TencentSdkResp {
  const TencentLoginResp({
    int? ret,
    String? msg,
    required this.openid,
    required this.accessToken,
    required this.expiresIn,
    required this.createAt,
  }) : super(ret: ret, msg: msg);

  factory TencentLoginResp.fromJson(Map<String, dynamic> json) =>
      _$TencentLoginRespFromJson(json);

  final String openid;
  final String accessToken;
  final int expiresIn;
  final int createAt;

  bool get isExpired =>
      DateTime.now().millisecondsSinceEpoch - createAt >= expiresIn * 1000;

  Map<String, dynamic> toJson() => _$TencentLoginRespToJson(this);
}
