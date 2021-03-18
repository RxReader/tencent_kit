import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/sdk/tencent_sdk_resp.dart';

part 'tencent_share_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentShareResp extends TencentSdkResp {
  const TencentShareResp({
    int? ret,
    String? msg,
  }) : super(ret: ret, msg: msg);

  factory TencentShareResp.fromJson(Map<String, dynamic> json) =>
      _$TencentShareRespFromJson(json);

  Map<String, dynamic> toJson() => _$TencentShareRespToJson(this);
}
