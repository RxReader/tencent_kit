import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_path_provider/fake_path_provider.dart';
import 'package:fake_tencent/fake_tencent.dart';
import 'package:path/path.dart' as path;

void main() {
  runZoned(() {
    runApp(MyApp());
  }, onError: (Object error, StackTrace stack) {
    print(error);
    print(stack);
  });

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
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
  Tencent _tencent;

  StreamSubscription<TencentLoginResp> _login;
  StreamSubscription<TencentUserInfoResp> _userInfo;
  StreamSubscription<TencentShareResp> _share;

  TencentLoginResp _loginResp;

  @override
  void initState() {
    super.initState();
    _tencent = Tencent();
    _tencent.registerApp(appId: '222222');
    _login = _tencent.loginResp().listen(_listenLogin);
    _userInfo = _tencent.userInfoResp().listen(_listenUserInfo);
    _share = _tencent.shareResp().listen(_listenShare);
  }

  void _listenLogin(TencentLoginResp resp) {
    _loginResp = resp;
    String content = 'login: ${resp.openid} - ${resp.accessToken}';
    _showTips('登录', content);
  }

  void _listenUserInfo(TencentUserInfoResp resp) {
    String content = 'user info: ${resp.nickname} - ${resp.gender}';
    _showTips('用户', content);
  }

  void _listenShare(TencentShareResp resp) {
    String content = 'share: ${resp.ret} - ${resp.msg}';
    _showTips('分享', content);
  }

  @override
  void dispose() {
    if (_login != null) {
      _login.cancel();
    }
    if (_userInfo != null) {
      _userInfo.cancel();
    }
    if (_share != null) {
      _share.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Tencent Demo'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('环境检查'),
            onTap: () async {
              String content =
                  'tencent: ${await _tencent.isQQInstalled()} - ${await _tencent.isQQSupportSSOLogin()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              _tencent.login(
                scope: [TencentScope.GET_SIMPLE_USERINFO],
              );
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () {
              if (_loginResp != null &&
                  _loginResp.ret == TencentResp.RET_SUCCESS) {
                if (DateTime.now().millisecondsSinceEpoch -
                        _loginResp.createAt <
                    _loginResp.expiresIn * 1000) {
                  _tencent.getUserInfo(
                    openId: _loginResp.openid,
                    accessToken: _loginResp.accessToken,
                    expiresIn: _loginResp.expiresIn,
                    createAt: _loginResp.createAt,
                  );
                }
              }
            },
          ),
          ListTile(
            title: const Text('分享文字'),
            onTap: () {
              _tencent.shareMood(
                scene: TencentScene.SCENE_QZONE,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('图片分享'),
            onTap: () async {
              AssetImage image = const AssetImage('images/icon/timg.gif');
              AssetBundleImageKey key =
                  await image.obtainKey(createLocalImageConfiguration(context));
              ByteData imageData = await key.bundle.load(key.name);
              Directory saveDir = await PathProvider.getDocumentsDirectory();
              File saveFile = File('${saveDir.path}${path.separator}timg.gif');
              if (!saveFile.existsSync()) {
                saveFile.createSync(recursive: true);
                saveFile.writeAsBytesSync(imageData.buffer.asUint8List(),
                    flush: true);
              }
              await _tencent.shareImage(
                scene: TencentScene.SCENE_QQ,
                imageUri: Uri.file(saveFile.path),
              );
            },
          ),
          ListTile(
            title: const Text('分享链接'),
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
    showDialog(
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
