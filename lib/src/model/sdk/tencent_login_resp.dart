import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/sdk/tencent_sdk_resp.dart';

part 'tencent_login_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentLoginResp extends TencentSdkResp {
  TencentLoginResp({
    int ret,
    String msg,
    this.openid,
    this.accessToken,
    this.expiresIn,
    this.createAt,
  }) : super(ret: ret, msg: msg);

  factory TencentLoginResp.fromJson(Map<dynamic, dynamic> json) =>
      _$TencentLoginRespFromJson(json);

  final String openid;
  final String accessToken;
  final int expiresIn;
  final int createAt;

  bool isExpired() {
    return DateTime.now().millisecondsSinceEpoch - createAt >= expiresIn * 1000;
  }

  Map<dynamic, dynamic> toJson() => _$TencentLoginRespToJson(this);
}
