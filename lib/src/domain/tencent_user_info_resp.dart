import 'package:fake_tencent/src/domain/tencent_base_resp.dart';
import 'package:jaguar_serializer/jaguar_serializer.dart';
import 'package:meta/meta.dart';

part 'tencent_user_info_resp.jser.dart';

@GenSerializer(nameFormatter: toSnakeCase)
class TencentUserInfoRespSerializer extends Serializer<TencentUserInfoResp>
    with _$TencentUserInfoRespSerializer {}

class TencentUserInfoResp extends TencentBaseResp {
  TencentUserInfoResp({
    @required int ret,
    @required String msg,
    this.nickname,
    this.gender,
    this.figureurlQq1,
    this.figureurlQq2,
    this.figureurl1,
    this.figureurl2,
    this.figureurl,
    this.vip,
    this.level,
    this.isYellowVip,
    this.isYellowYearVip,
    this.yellowVipLevel,
  }) : super(ret: ret, msg: msg);

  final String nickname;

  /// 男/女
  final String gender;
  final String figureurlQq1;
  final String figureurlQq2;
  final String figureurl1;
  final String figureurl2;
  final String figureurl;
  final String vip;
  final String level;
  final String isYellowVip;
  final String isYellowYearVip;
  final String yellowVipLevel;

  bool isMale() {
    return gender == '男';
  }

  bool isFemale() {
    return gender == '女';
  }

  String headImgUrl() {
    if (figureurlQq2 != null && figureurlQq2.isNotEmpty) {
      return figureurlQq2;
    }
    if (figureurlQq1 != null && figureurlQq1.isNotEmpty) {
      return figureurlQq1;
    }
    if (figureurl2 != null && figureurl2.isNotEmpty) {
      return figureurl2;
    }
    if (figureurl1 != null && figureurl1.isNotEmpty) {
      return figureurl1;
    }
    return figureurl;
  }
}
