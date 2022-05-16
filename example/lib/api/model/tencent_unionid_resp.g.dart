// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_unionid_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentUnionidResp _$TencentUnionidRespFromJson(Map<String, dynamic> json) {
  return TencentUnionidResp(
    error: json['error'] as int? ?? 0,
    errorDescription: json['error_description'] as String?,
    clientId: json['client_id'] as String?,
    openid: json['openid'] as String?,
    unionid: json['unionid'] as String?,
  );
}

Map<String, dynamic> _$TencentUnionidRespToJson(TencentUnionidResp instance) =>
    <String, dynamic>{
      'error': instance.error,
      'error_description': instance.errorDescription,
      'client_id': instance.clientId,
      'openid': instance.openid,
      'unionid': instance.unionid,
    };
