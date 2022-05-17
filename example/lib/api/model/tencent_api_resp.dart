import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'tencent_api_resp.g.dart';

abstract class TencentApiResp {
  const TencentApiResp({
    required this.ret,
    this.msg,
  });

  /// 网络请求成功发送至服务器，并且服务器返回数据格式正确
  /// 这里包括所请求业务操作失败的情况，例如没有授权等原因导致
  static const int RET_SUCCESS = 0;

  @JsonKey(
    defaultValue: RET_SUCCESS,
  )
  final int ret;
  final String? msg;

  bool get isSuccessful => ret == RET_SUCCESS;

  Map<String, dynamic> toJson();

  @override
  String toString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class TencentUserInfoResp extends TencentApiResp {
  const TencentUserInfoResp({
    required super.ret,
    super.msg,
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
  });

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
    if (figureurlQq?.isNotEmpty ?? false) {
      return figureurlQq;
    }
    if (figureurlQq2?.isNotEmpty ?? false) {
      return figureurlQq2;
    }
    if (figureurlQq1?.isNotEmpty ?? false) {
      return figureurlQq1;
    }
    if (figureurl2?.isNotEmpty ?? false) {
      return figureurl2;
    }
    if (figureurl1?.isNotEmpty ?? false) {
      return figureurl1;
    }
    return figureurl;
  }

  @override
  Map<String, dynamic> toJson() => _$TencentUserInfoRespToJson(this);
}
