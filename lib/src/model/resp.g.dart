// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResp _$LoginRespFromJson(Map<String, dynamic> json) {
  return LoginResp(
    ret: json['ret'] as int? ?? 0,
    msg: json['msg'] as String?,
    openid: json['openid'] as String?,
    accessToken: json['access_token'] as String?,
    expiresIn: json['expires_in'] as int?,
    createAt: json['create_at'] as int?,
  );
}

Map<String, dynamic> _$LoginRespToJson(LoginResp instance) => <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
      'openid': instance.openid,
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'create_at': instance.createAt,
    };

ShareMsgResp _$ShareMsgRespFromJson(Map<String, dynamic> json) {
  return ShareMsgResp(
    ret: json['ret'] as int? ?? 0,
    msg: json['msg'] as String?,
  );
}

Map<String, dynamic> _$ShareMsgRespToJson(ShareMsgResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
    };
