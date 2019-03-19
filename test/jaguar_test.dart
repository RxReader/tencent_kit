import 'dart:convert';

import 'package:fake_tencent/src/domain/tencent_login_resp.dart';
import 'package:fake_tencent/src/domain/tencent_share_resp.dart';
import 'package:fake_tencent/src/domain/tencent_user_info_resp.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('smoke test - jaguar_serializer', () {
    TencentLoginResp loginResp = TencentLoginRespSerializer().fromMap(json.decode(
            '{"ret":0,"access_token":"D3A4D352A06D897D6FD4DED2B8BEEA46","openid":"A13514A5E6385A1D56E1D845303C5FDE","expires_in":7776000}')
        as Map<dynamic, dynamic>);
    expect(loginResp.ret, equals(0));
    expect(loginResp.openid, equals('A13514A5E6385A1D56E1D845303C5FDE'));
    expect(loginResp.accessToken, equals('D3A4D352A06D897D6FD4DED2B8BEEA46'));
    expect(loginResp.expiresIn, equals(7776000));

    TencentUserInfoResp userInfoResp = TencentUserInfoRespSerializer().fromMap(
        json.decode(
                '{"ret":0,"msg":"","is_lost":1,"gender":"男","is_yellow_vip":"0","city":"福州","year":"1989","level":"0","figureurl_2":"http://qzapp.qlogo.cn/qzapp/222222/942FEA70050EEAFBD4DCE2C1FC775E56/100","figureurl_1":"http://qzapp.qlogo.cn/qzapp/222222/942FEA70050EEAFBD4DCE2C1FC775E56/50","is_yellow_year_vip":"0","province":"福建","constellation":"","figureurl":"http://qzapp.qlogo.cn/qzapp/222222/942FEA70050EEAFBD4DCE2C1FC775E56/30","figureurl_type":"1","figureurl_qq":"http://thirdqq.qlogo.cn/g?b=oidb&k=aicFesDxFa5P0dImvuYicSGw&s=140","nickname":"qquser","yellow_vip_level":"0","figureurl_qq_1":"http://thirdqq.qlogo.cn/g?b=oidb&k=aicFesDxFa5P0dImvuYicSGw&s=40","vip":"0","figureurl_qq_2":"http://thirdqq.qlogo.cn/g?b=oidb&k=aicFesDxFa5P0dImvuYicSGw&s=100"}')
            as Map<dynamic, dynamic>);
    expect(userInfoResp.ret, equals(0));
    expect(userInfoResp.nickname, equals('qquser'));
    expect(
        userInfoResp.figureurlQq1,
        equals(
            'http://thirdqq.qlogo.cn/g?b=oidb&k=aicFesDxFa5P0dImvuYicSGw&s=40'));

    TencentShareResp shareResp = TencentShareRespSerializer()
        .fromMap(json.decode('{"ret":0}') as Map<dynamic, dynamic>);
    expect(shareResp.ret, equals(0));
  });
}
