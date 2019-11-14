// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_share_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentShareResp _$TencentShareRespFromJson(Map json) {
  return TencentShareResp(
    ret: json['ret'] as int ?? 0,
    msg: json['msg'] as String,
  );
}

Map<String, dynamic> _$TencentShareRespToJson(TencentShareResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
    };
