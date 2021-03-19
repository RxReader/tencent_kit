// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_sdk_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentSdkResp _$TencentSdkRespFromJson(Map<String, dynamic> json) {
  return TencentSdkResp(
    ret: json['ret'] as int? ?? 0,
    msg: json['msg'] as String?,
  );
}

Map<String, dynamic> _$TencentSdkRespToJson(TencentSdkResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
    };
