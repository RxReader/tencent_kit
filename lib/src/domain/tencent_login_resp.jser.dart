// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_login_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$TencentLoginRespSerializer
    implements Serializer<TencentLoginResp> {
  @override
  Map<String, dynamic> toMap(TencentLoginResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'openid', model.openid);
    setMapValue(ret, 'access_token', model.accessToken);
    setMapValue(ret, 'expires_in', model.expiresIn);
    setMapValue(ret, 'create_at', model.createAt);
    setMapValue(ret, 'ret', model.ret);
    setMapValue(ret, 'msg', model.msg);
    return ret;
  }

  @override
  TencentLoginResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new TencentLoginResp(
        ret: map['ret'] as int ?? getJserDefault('ret'),
        msg: map['msg'] as String ?? getJserDefault('msg'),
        openid: map['openid'] as String ?? getJserDefault('openid'),
        accessToken:
            map['access_token'] as String ?? getJserDefault('accessToken'),
        expiresIn: map['expires_in'] as int ?? getJserDefault('expiresIn'),
        createAt: map['create_at'] as int ?? getJserDefault('createAt'));
    return obj;
  }
}
