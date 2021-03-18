import 'package:json_annotation/json_annotation.dart';
import 'package:tencent_kit/src/model/api/tencent_api_resp.dart';

part 'tencent_user_info_resp.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentUserInfoResp extends TencentApiResp {
  const TencentUserInfoResp({
    int? ret,
    String? msg,
    this.isLost,
    this.nickname,
    this.gender,
    this.genderType,
    this.province,
    this.city,
    this.year,
    this.constellation,
    this.figureurl,
    this.figureurl1,
    this.figureurl2,
    this.figureurlQq,
    this.figureurlQq1,
    this.figureurlQq2,
    this.figureurlType,
    this.isYellowVip,
    this.vip,
    this.yellowVipLevel,
    this.level,
    this.isYellowYearVip,
  }) : super(ret: ret, msg: msg);

  factory TencentUserInfoResp.fromJson(Map<String, dynamic> json) =>
      _$TencentUserInfoRespFromJson(json);

  final int? isLost;
  final String? nickname;
  final String? gender; // 男/女
  final int? genderType; // 男/女 - 1
  final String? province;
  final String? city;
  final String? year;
  final String? constellation;
  final String? figureurl;
  @JsonKey(
    name: 'figureurl_1',
  )
  final String? figureurl1;
  @JsonKey(
    name: 'figureurl_2',
  )
  final String? figureurl2;
  final String? figureurlQq; // 140 * 140
  @JsonKey(
    name: 'figureurl_qq_1',
  )
  final String? figureurlQq1; // 大小为40×40像素的QQ头像URL。
  @JsonKey(
    name: 'figureurl_qq_2',
  )
  final String?
      figureurlQq2; // 大小为100×100像素的QQ头像URL。需要注意，不是所有的用户都拥有QQ的100x100的头像，但40x40像素则是一定会有。
  final String? figureurlType;
  final String? isYellowVip;
  final String? vip;
  final String? yellowVipLevel;
  final String? level;
  final String? isYellowYearVip;

  bool get isMale => gender == '男';

  bool get isFemale => gender == '女';

  String? get headImgUrl {
    if (figureurlQq?.isNotEmpty != true) {
      return figureurlQq;
    }
    if (figureurlQq2?.isNotEmpty != true) {
      return figureurlQq2;
    }
    if (figureurlQq1?.isNotEmpty != true) {
      return figureurlQq1;
    }
    if (figureurl2?.isNotEmpty != true) {
      return figureurl2;
    }
    if (figureurl1?.isNotEmpty != true) {
      return figureurl1;
    }
    return figureurl;
  }

  Map<String, dynamic> toJson() => _$TencentUserInfoRespToJson(this);
}
