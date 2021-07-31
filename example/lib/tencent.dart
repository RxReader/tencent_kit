import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tencent_kit/tencent_kit.dart';
import 'package:tencent_kit_example/model/api/tencent_user_info_resp.dart';
import 'package:tencent_kit_example/model/unionid/tencent_unionid_resp.dart';

extension MixerTencent on Tencent {

  /// 用户信息
  /// https://wiki.connect.qq.com/get_user_info
  Future<TencentUserInfoResp> getUserInfo({
    required String appId,
    required String openid,
    required String accessToken,
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://graph.qq.com/user/get_user_info?access_token=$accessToken&oauth_consumer_key=$appId&openid=$openid'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final ContentType? contentType = response.headers.contentType;
        final Encoding encoding =
            Encoding.getByName(contentType?.charset) ?? utf8;
        final String content = await encoding.decodeStream(response);
        return TencentUserInfoResp.fromJson(
            json.decode(content) as Map<String, dynamic>);
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }

  /// UnionID
  /// https://wiki.connect.qq.com/unionid%E4%BB%8B%E7%BB%8D
  Future<TencentUnionidResp> getUnionId({
    required String accessToken,
    String unionid = '1',
  }) {
    return HttpClient()
        .getUrl(Uri.parse(
            'https://graph.qq.com/oauth2.0/me?access_token=$accessToken&unionid=$unionid'))
        .then((HttpClientRequest request) {
      return request.close();
    }).then((HttpClientResponse response) async {
      if (response.statusCode == HttpStatus.ok) {
        final ContentType? contentType = response.headers.contentType;
        final Encoding encoding =
            Encoding.getByName(contentType?.charset) ?? utf8;
        final String callback = await encoding.decodeStream(response);
        // 腾讯有毒 callback( $json );
        final RegExp exp = RegExp(r'callback\( (.*) \)\;');
        final Match? match = exp.firstMatch(callback);
        if (match?.groupCount == 1) {
          final String? content = match!.group(1);
          if (content != null) {
            return TencentUnionidResp.fromJson(
                json.decode(content) as Map<String, dynamic>);
          }
        }
      }
      throw HttpException(
          'HttpResponse statusCode: ${response.statusCode}, reasonPhrase: ${response.reasonPhrase}.');
    });
  }
}
