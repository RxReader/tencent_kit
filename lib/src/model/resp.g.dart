// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentLoginResp _$TencentLoginRespFromJson(Map json) => TencentLoginResp(
      ret: (json['ret'] as num?)?.toInt() ?? 0,
      msg: json['msg'] as String?,
      openid: json['openid'] as String?,
      accessToken: json['access_token'] as String?,
      expiresIn: (json['expires_in'] as num?)?.toInt(),
      createAt: (json['create_at'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TencentLoginRespToJson(TencentLoginResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
      'openid': instance.openid,
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'create_at': instance.createAt,
    };

TencentShareMsgResp _$TencentShareMsgRespFromJson(Map json) =>
    TencentShareMsgResp(
      ret: (json['ret'] as num?)?.toInt() ?? 0,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$TencentShareMsgRespToJson(
        TencentShareMsgResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
    };
