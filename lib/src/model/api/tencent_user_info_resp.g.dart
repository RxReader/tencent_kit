// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_user_info_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TencentUserInfoResp _$TencentUserInfoRespFromJson(Map<String, dynamic> json) {
  return TencentUserInfoResp(
    ret: json['ret'] as int? ?? 0,
    msg: json['msg'] as String?,
    isLost: json['is_lost'] as int?,
    nickname: json['nickname'] as String?,
    gender: json['gender'] as String?,
    genderType: json['gender_type'] as int?,
    province: json['province'] as String?,
    city: json['city'] as String?,
    year: json['year'] as String?,
    constellation: json['constellation'] as String?,
    figureurl: json['figureurl'] as String?,
    figureurl1: json['figureurl_1'] as String?,
    figureurl2: json['figureurl_2'] as String?,
    figureurlQq: json['figureurl_qq'] as String?,
    figureurlQq1: json['figureurl_qq_1'] as String?,
    figureurlQq2: json['figureurl_qq_2'] as String?,
    figureurlType: json['figureurl_type'] as String?,
    isYellowVip: json['is_yellow_vip'] as String?,
    vip: json['vip'] as String?,
    yellowVipLevel: json['yellow_vip_level'] as String?,
    level: json['level'] as String?,
    isYellowYearVip: json['is_yellow_year_vip'] as String?,
  );
}

Map<String, dynamic> _$TencentUserInfoRespToJson(
        TencentUserInfoResp instance) =>
    <String, dynamic>{
      'ret': instance.ret,
      'msg': instance.msg,
      'is_lost': instance.isLost,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'gender_type': instance.genderType,
      'province': instance.province,
      'city': instance.city,
      'year': instance.year,
      'constellation': instance.constellation,
      'figureurl': instance.figureurl,
      'figureurl_1': instance.figureurl1,
      'figureurl_2': instance.figureurl2,
      'figureurl_qq': instance.figureurlQq,
      'figureurl_qq_1': instance.figureurlQq1,
      'figureurl_qq_2': instance.figureurlQq2,
      'figureurl_type': instance.figureurlType,
      'is_yellow_vip': instance.isYellowVip,
      'vip': instance.vip,
      'yellow_vip_level': instance.yellowVipLevel,
      'level': instance.level,
      'is_yellow_year_vip': instance.isYellowYearVip,
    };
