import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/sdk/tencent_sdk_resp.dart';

part 'tencent_share_resp.g.dart';

@JsonSerializable(
  anyMap: true,
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentShareResp extends TencentSdkResp {
  TencentShareResp({
    int ret,
    String msg,
  }) : super(ret: ret, msg: msg);

  factory TencentShareResp.fromJson(Map<dynamic, dynamic> json) =>
      _$TencentShareRespFromJson(json);

  Map<dynamic, dynamic> toJson() => _$TencentShareRespToJson(this);
}
