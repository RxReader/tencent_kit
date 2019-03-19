import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:fake_tencent/src/domain/tencent_resp.dart';

part 'tencent_login_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class TencentLoginRespSerializer extends Serializer<TencentLoginResp>
    with _$TencentLoginRespSerializer {}

class TencentLoginResp extends TencentResp {
  TencentLoginResp({
    int ret,
    String msg,
    this.openid,
    this.accessToken,
    this.expiresIn,
  }) : super(ret: ret, msg: msg);

  final String openid;
  final String accessToken;
  final int expiresIn;
}
