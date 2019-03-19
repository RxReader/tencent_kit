import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_tencent/src/domain/tencent_resp.dart';

part 'tencent_share_resp.jser.dart';

@GenSerializer()
class TencentShareRespSerializer extends Serializer<TencentShareResp>
    with _$TencentShareRespSerializer {}

class TencentShareResp extends TencentResp {
  TencentShareResp({
    int ret,
    String msg,
  }) : super(ret: ret, msg: msg);
}
