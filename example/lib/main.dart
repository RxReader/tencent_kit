import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:okhttp_kit/okhttp_kit.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:tencent_kit/tencent_kit.dart';

void main() => runApp(MyApp());

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
  static const String _TENCENT_APPID = 'your tencent appId';

  final Tencent _tencent = Tencent()..registerApp(appId: _TENCENT_APPID);

  StreamSubscription<TencentLoginResp> _login;
  StreamSubscription<TencentShareResp> _share;

  TencentLoginResp _loginResp;

  @override
  void initState() {
    super.initState();
    _login = _tencent.loginResp().listen(_listenLogin);
    _share = _tencent.shareResp().listen(_listenShare);
  }

  void _listenLogin(TencentLoginResp resp) {
    _loginResp = resp;
    String content = 'login: ${resp.openid} - ${resp.accessToken}';
    _showTips('登录', content);
  }

  void _listenShare(TencentShareResp resp) {
    String content = 'share: ${resp.ret} - ${resp.msg}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    _login?.cancel();
    _login = null;
    _share?.cancel();
    _share = null;
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
              String content =
                  'QQ install: ${await _tencent.isQQInstalled()}\nTIM install: ${await _tencent.isTIMInstalled()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              _tencent.login(
                scope: <String>[TencentScope.GET_SIMPLE_USERINFO],
              );
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () async {
              if (_loginResp != null &&
                  _loginResp.isSuccessful &&
                  !_loginResp.isExpired) {
                TencentUserInfoResp userInfo = await _tencent.getUserInfo(
                  appId: _TENCENT_APPID,
                  openid: _loginResp.openid,
                  accessToken: _loginResp.accessToken,
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
              if (_loginResp != null &&
                  _loginResp.isSuccessful &&
                  !_loginResp.isExpired) {
                TencentUnionidResp unionid = await _tencent.getUnionId(
                  accessToken: _loginResp.accessToken,
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
              _tencent.shareMood(
                scene: TencentScene.SCENE_QZONE,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('文本分享'),
            onTap: () {
              _tencent.shareText(
                scene: TencentScene.SCENE_QQ,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              OkHttpClient client = OkHttpClientBuilder().build();
              Response resp = await client
                  .newCall(RequestBuilder()
                      .get()
                      .url(HttpUrl.parse(
                          'https://www.baidu.com/img/bd_logo1.png?where=super'))
                      .build())
                  .enqueue();
              if (resp.isSuccessful()) {
                Directory saveDir = Platform.isIOS
                    ? await path_provider.getApplicationDocumentsDirectory()
                    : await path_provider.getExternalStorageDirectory();
                File saveFile = File(path.join(saveDir.path, 'timg.png'));
                if (!saveFile.existsSync()) {
                  saveFile.createSync(recursive: true);
                  saveFile.writeAsBytesSync(
                    await resp.body().bytes(),
                    flush: true,
                  );
                }
                await _tencent.shareImage(
                  scene: TencentScene.SCENE_QQ,
                  imageUri: Uri.file(saveFile.path),
                );
              }
            },
          ),
          ListTile(
            title: const Text('网页分享'),
            onTap: () {
              _tencent.shareWebpage(
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
