# fake_tencent

[![Build Status](https://cloud.drone.io/api/badges/v7lin/fake_tencent/status.svg)](https://cloud.drone.io/v7lin/fake_tencent)
[![GitHub tag](https://img.shields.io/github/tag/v7lin/fake_tencent.svg)](https://github.com/v7lin/fake_tencent/releases)
[![pub package](https://img.shields.io/pub/v/fake_tencent.svg)](https://pub.dartlang.org/packages/fake_tencent)

flutter版腾讯(QQ)SDK

## fake 系列 libraries

1. [flutter版okhttp3](https://github.com/v7lin/fake_http)
2. [flutter版微信SDK](https://github.com/v7lin/fake_wechat)
3. [flutter版腾讯(QQ)SDK](https://github.com/v7lin/fake_tencent)
4. [flutter版新浪微博SDK](https://github.com/v7lin/fake_weibo)
5. [flutter版支付宝SDK](https://github.com/v7lin/fake_alipay)

## android

````
...
android {
    ...
    defaultConfig{
        ...
        manifestPlaceholders = [TENCENT_APP_ID: "${appId}"]
        ...
    }
    ...
}
...
````

````
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
````

## ios

````
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
tencent: identifier=tencent schemes=tencent${appId}
````

````
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>wtloginmqq2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqqwpa</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqq</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
````

## flutter

|分享类型|说说|图片|音乐|视频|网页|
|:---:|:---:|:---:|:---:|:---:|:---:|
|QQ|不支持|支持|支持|不支持|支持|
|QZone|支持|不支持|不支持|不支持|支持|

### snapshot
````
dependencies:
  fake_tencent:
    git:
      url: https://github.com/v7lin/fake_tencent.git
````

### release
````
latestVersion = 0.0.1+1
````

````
dependencies:
  fake_tencent: ^${latestVersion}
````

### example
[示例](./example/lib/main.dart)

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.io/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
