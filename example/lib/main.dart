import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fake_tencent/fake_tencent.dart';

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
    Tencent tencent = Tencent();
    tencent.registerApp(appId: '222222');
    return TencentProvider(
      tencent: tencent,
      child: MaterialApp(
        home: Home(tencent: tencent),
      ),
    );
  }
}

class Home extends StatefulWidget {
  Home({
    Key key,
    @required this.tencent,
  }) : super(key: key);

  final Tencent tencent;

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  StreamSubscription<TencentLoginResp> _login;
  StreamSubscription<TencentUserInfoResp> _userInfo;
  StreamSubscription<TencentShareResp> _share;

  TencentLoginResp _loginResp;
  DateTime _loginDate;

  @override
  void initState() {
    super.initState();
    _login = widget.tencent.loginResp().listen(_listenLogin);
    _userInfo = widget.tencent.userInfoResp().listen(_listenUserInfo);
    _share = widget.tencent.shareResp().listen(_listenShare);
  }

  void _listenLogin(TencentLoginResp resp) {
    _loginDate = DateTime.now();
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
                  'tencent: ${await widget.tencent.isQQInstalled()} - ${await widget.tencent.isQQSupportSSOLogin()}';
              _showTips('环境检查', content);
            },
          ),
          ListTile(
            title: const Text('登录'),
            onTap: () {
              widget.tencent.login(
                scope: [TencentScope.GET_SIMPLE_USERINFO],
              );
            },
          ),
          ListTile(
            title: const Text('获取用户信息'),
            onTap: () {
              if (_loginDate != null && _loginResp != null &&
                  _loginResp.ret == TencentResp.RET_SUCCESS) {
                if (DateTime.now().millisecondsSinceEpoch - _loginResp.createAt < _loginResp.expiresIn * 1000) {
                  widget.tencent.getUserInfo(
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
              widget.tencent.shareMood(
                scene: TencentScene.SCENE_QZONE,
                summary: '分享测试',
              );
            },
          ),
          ListTile(
            title: const Text('分享链接'),
            onTap: () {
              widget.tencent.shareWebpage(
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
