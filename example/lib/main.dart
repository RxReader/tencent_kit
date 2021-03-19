import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:tencent_kit/tencent_kit.dart';

const String _TENCENT_APPID = 'your tencent appId';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Tencent.instance.registerApp(appId: _TENCENT_APPID);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  late final StreamSubscription<TencentLoginResp> _login =
      Tencent.instance.loginResp().listen(_listenLogin);
  late final StreamSubscription<TencentSdkResp> _share =
      Tencent.instance.shareResp().listen(_listenShare);

  TencentLoginResp? _loginResp;

  @override
  void initState() {
    super.initState();
  }

  void _listenLogin(TencentLoginResp resp) {
    _loginResp = resp;
    final String content = 'login: ${resp.openid} - ${resp.accessToken}';
    _showTips('登录', content);
  }

  void _listenShare(TencentSdkResp resp) {
    final String content = 'share: ${resp.ret} - ${resp.msg}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    _login.cancel();
    _share.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tencent Kit Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              final String content =
                  'QQ install: ${await Tencent.instance.isQQInstalled()}\nTIM install: ${await Tencent.instance.isTIMInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              Tencent.instance.login(
                scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
              );
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () async {
              if ((_loginResp?.isSuccessful ?? false) &&
                  !(_loginResp!.isExpired ?? true)) {
                final TencentUserInfoResp userInfo =
                    await Tencent.instance.getUserInfo(
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
            title: const Text('获取UnionID'),
            onTap: () async {
              if ((_loginResp?.isSuccessful ?? false) &&
                  !(_loginResp!.isExpired ?? true)) {
                final TencentUnionidResp unionid =
                    await Tencent.instance.getUnionId(
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
            title: const Text('分享说说'),
            onTap: () {
              Tencent.instance.shareMood(
                scene: TencentScene.SCENE_QZONE,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('文本分享'),
            onTap: () {
              Tencent.instance.shareText(
                scene: TencentScene.SCENE_QQ,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              final File file = await DefaultCacheManager().getSingleFile(
                  'https://www.baidu.com/img/bd_logo1.png?where=super');
              await Tencent.instance.shareImage(
                scene: TencentScene.SCENE_QQ,
                imageUri: Uri.file(file.path),
              );
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              Tencent.instance.shareWebpage(
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
