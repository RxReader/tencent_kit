// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_share_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$TencentShareRespSerializer
    implements Serializer<TencentShareResp> {
  @override
  Map<String, dynamic> toMap(TencentShareResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'ret', model.ret);
    setMapValue(ret, 'msg', model.msg);
    return ret;
  }

  @override
  TencentShareResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new TencentShareResp(
        ret: map['ret'] as int ?? getJserDefault('ret'),
        msg: map['msg'] as String ?? getJserDefault('msg'));
    return obj;
  }
}
