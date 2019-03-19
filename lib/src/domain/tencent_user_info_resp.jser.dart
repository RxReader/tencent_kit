// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tencent_user_info_resp.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$TencentUserInfoRespSerializer
    implements Serializer<TencentUserInfoResp> {
  @override
  Map<String, dynamic> toMap(TencentUserInfoResp model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'nickname', model.nickname);
    setMapValue(ret, 'gender', model.gender);
    setMapValue(ret, 'figureurl_qq_1', model.figureurlQq1);
    setMapValue(ret, 'figureurl_qq_2', model.figureurlQq2);
    setMapValue(ret, 'figureurl_1', model.figureurl1);
    setMapValue(ret, 'figureurl_2', model.figureurl2);
    setMapValue(ret, 'figureurl', model.figureurl);
    setMapValue(ret, 'vip', model.vip);
    setMapValue(ret, 'level', model.level);
    setMapValue(ret, 'is_yellow_vip', model.isYellowVip);
    setMapValue(ret, 'is_yellow_year_vip', model.isYellowYearVip);
    setMapValue(ret, 'yellow_vip_level', model.yellowVipLevel);
    setMapValue(ret, 'ret', model.ret);
    setMapValue(ret, 'msg', model.msg);
    return ret;
  }

  @override
  TencentUserInfoResp fromMap(Map map) {
    if (map == null) return null;
    final obj = new TencentUserInfoResp(
        ret: map['ret'] as int ?? getJserDefault('ret'),
        msg: map['msg'] as String ?? getJserDefault('msg'),
        nickname: map['nickname'] as String ?? getJserDefault('nickname'),
        gender: map['gender'] as String ?? getJserDefault('gender'),
        figureurlQq1:
            map['figureurl_qq_1'] as String ?? getJserDefault('figureurlQq1'),
        figureurlQq2:
            map['figureurl_qq_2'] as String ?? getJserDefault('figureurlQq2'),
        figureurl1:
            map['figureurl_1'] as String ?? getJserDefault('figureurl1'),
        figureurl2:
            map['figureurl_2'] as String ?? getJserDefault('figureurl2'),
        figureurl: map['figureurl'] as String ?? getJserDefault('figureurl'),
        vip: map['vip'] as String ?? getJserDefault('vip'),
        level: map['level'] as String ?? getJserDefault('level'),
        isYellowVip:
            map['is_yellow_vip'] as String ?? getJserDefault('isYellowVip'),
        isYellowYearVip: map['is_yellow_year_vip'] as String ??
            getJserDefault('isYellowYearVip'),
        yellowVipLevel: map['yellow_vip_level'] as String ??
            getJserDefault('yellowVipLevel'));
    return obj;
  }
}
