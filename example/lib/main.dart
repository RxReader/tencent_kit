import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:tencent_kit_example/api/model/tencent_api_resp.dart';
import 'package:tencent_kit_example/api/model/tencent_unionid_resp.dart';
import 'package:tencent_kit_example/api/tencent_api.dart';

const String _TENCENT_APPID = 'your tencent appId';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<BaseResp> _respSubs;

  LoginResp? _loginResp;

  @override
  void initState() {
    super.initState();
    _respSubs = Tencent.respStream().listen(_listenLogin);
  }

  void _listenLogin(BaseResp resp) {
    if (resp is LoginResp) {
      _loginResp = resp;
      final String content = 'login: ${resp.openid} - ${resp.accessToken}';
      _showTips('登录', content);
    } else if (resp is ShareMsgResp) {
      final String content = 'share: ${resp.ret} - ${resp.msg}';
      _showTips('分享', content);
    }
  }

  @override
  void dispose() {
    _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tencent Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('3.1.0 之后的版本请先获取权限'),
            onTap: () async {
              await Tencent.setIsPermissionGranted(granted: true);
              _showTips('授权', '已授权获取设备信息/同意隐私协议');
            },
          ),
          ListTile(
            title: Text('注册APP'),
            onTap: () async {
              await Tencent.registerApp(appId: _TENCENT_APPID);
              _showTips('注册APP', '注册成功');
            },
          ),
          ListTile(
            title: Text('环境检查'),
            onTap: () async {
              final String content =
                  'QQ install: ${await Tencent.isQQInstalled()}\nTIM install: ${await Tencent.isTIMInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: Text('登录'),
            onTap: () {
              Tencent.login(
                scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
              );
            },
          ),
          ListTile(
            title: Text('获取用户信息'),
            onTap: () async {
              if ((_loginResp?.isSuccessful ?? false) &&
                  !(_loginResp!.isExpired ?? true)) {
                final TencentUserInfoResp userInfo =
                    await TencentApi.getUserInfo(
                  appId: _TENCENT_APPID,
                  openid: _loginResp!.openid!,
                  accessToken: _loginResp!.accessToken!,
                );
                if (userInfo.isSuccessful) {
                  _showTips('用户信息',
                      '${userInfo.nickname} - ${userInfo.gender} - ${userInfo.genderType}');
                } else {
                  _showTips('用户信息', '${userInfo.ret} - ${userInfo.msg}');
                }
              }
            },
          ),
          ListTile(
            title: Text('获取UnionID'),
            onTap: () async {
              if ((_loginResp?.isSuccessful ?? false) &&
                  !(_loginResp!.isExpired ?? true)) {
                final TencentUnionidResp unionid = await TencentApi.getUnionId(
                  accessToken: _loginResp!.accessToken!,
                );
                if (unionid.isSuccessful) {
                  _showTips('UnionID',
                      '${unionid.clientId} - ${unionid.openid} - ${unionid.unionid}');
                } else {
                  _showTips('UnionID',
                      '${unionid.error} - ${unionid.errorDescription}');
                }
              }
            },
          ),
          ListTile(
            title: Text('分享说说'),
            onTap: () {
              Tencent.shareMood(
                scene: TencentScene.SCENE_QZONE,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: Text('文本分享'),
            onTap: () {
              Tencent.shareText(
                scene: TencentScene.SCENE_QQ,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              await Tencent.shareImage(
                scene: TencentScene.SCENE_QQ,
                imageUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: Text('网页分享'),
            onTap: () {
              Tencent.shareWebpage(
                scene: TencentScene.SCENE_QQ,
                title: 'title',
                targetUrl: 'https://www.baidu.com/',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showTips(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
        );
      },
    );
  }
}
