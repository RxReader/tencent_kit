# tencent_kit

[![Build Status](https://cloud.drone.io/api/badges/v7lin/fake_tencent/status.svg)](https://cloud.drone.io/v7lin/fake_tencent)
[![Codecov](https://codecov.io/gh/v7lin/fake_tencent/branch/master/graph/badge.svg)](https://codecov.io/gh/v7lin/fake_tencent)
[![GitHub Tag](https://img.shields.io/github/tag/v7lin/fake_tencent.svg)](https://github.com/v7lin/fake_tencent/releases)
[![Pub Package](https://img.shields.io/pub/v/tencent_kit.svg)](https://pub.dartlang.org/packages/tencent_kit)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/v7lin/fake_tencent/blob/master/LICENSE)

flutter版腾讯(QQ)SDK

## flutter toolkit

* [flutter版微信SDK](https://github.com/v7lin/fake_wechat)
* [flutter版腾讯(QQ)SDK](https://github.com/v7lin/fake_tencent)
* [flutter版新浪微博SDK](https://github.com/v7lin/fake_weibo)
* [flutter版支付宝SDK](https://github.com/v7lin/fake_alipay)
* [flutter版腾讯(信鸽)推送SDK](https://github.com/v7lin/fake_push)
* [flutter版talkingdata移动统计SDK](https://github.com/v7lin/fake_analytics)

## dart/flutter 私服

* [simple_pub_server](https://github.com/v7lin/simple_pub_server)

## docs

* [腾讯开放平台](https://open.tencent.com/)
* [QQ互联](http://wiki.connect.qq.com/)
* [Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

## android

```
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
```

```
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

## ios

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
tencent: identifier=tencent schemes=tencent${appId}
```

```
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
```

```
Universal Links

Capabilities -> Associated Domain -> Domain -> applinks:${your applinks}
```

## flutter

|分享类型|说说(图/文/视频)|文本|图片|音乐|视频|网页|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|QQ|不支持|不支持|支持|支持|不支持|支持|
|QZone|支持|不支持|不支持|不支持|不支持|支持|

* snapshot

```
dependencies:
  tencent_kit:
    git:
      url: https://github.com/v7lin/fake_tencent.git
```

* release

```
dependencies:
  tencent_kit: ^${latestTag}
```

* example

[示例](./example/lib/main.dart)

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
