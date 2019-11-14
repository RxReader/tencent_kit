// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_login_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentLoginResp _$TencentLoginRespFromJson(Map json) {
  return TencentLoginResp(
    ret: json['ret'] as int ?? 0,
    msg: json['msg'] as String,
    openid: json['openid'] as String,
    accessToken: json['access_token'] as String,
    expiresIn: json['expires_in'] as int,
    createAt: json['create_at'] as int,
  );
}

Map<String, dynamic> _$TencentLoginRespToJson(TencentLoginResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
      'openid': instance.openid,
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'create_at': instance.createAt,
    };
