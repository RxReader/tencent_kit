import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_tencent/src/domain/tencent_base_resp.dart';
import 'package:meta/meta.dart';

part 'tencent_share_resp.jser.dart';

@GenSerializer()
class TencentShareRespSerializer extends Serializer<TencentShareResp>
    with _$TencentShareRespSerializer {}

class TencentShareResp extends TencentBaseResp {
  TencentShareResp({
    @required int ret,
    @required String msg,
  }) : super(ret: ret, msg: msg);
}
