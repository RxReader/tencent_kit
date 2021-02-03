# tencent_kit

[![Build Status](https://cloud.drone.io/api/badges/v7lin/tencent_kit/status.svg)](https://cloud.drone.io/v7lin/tencent_kit)
[![Codecov](https://codecov.io/gh/v7lin/tencent_kit/branch/master/graph/badge.svg)](https://codecov.io/gh/v7lin/tencent_kit)
[![GitHub Tag](https://img.shields.io/github/tag/v7lin/tencent_kit.svg)](https://github.com/v7lin/tencent_kit/releases)
[![Pub Package](https://img.shields.io/pub/v/tencent_kit.svg)](https://pub.dartlang.org/packages/tencent_kit)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/v7lin/tencent_kit/blob/master/LICENSE)

flutter版腾讯(QQ)SDK

## flutter toolkit

* [flutter版微信SDK](https://github.com/v7lin/wechat_kit)
* [flutter版腾讯(QQ)SDK](https://github.com/v7lin/tencent_kit)
* [flutter版新浪微博SDK](https://github.com/v7lin/weibo_kit)
* [flutter版支付宝SDK](https://github.com/v7lin/alipay_kit)
* [flutter版walle渠道打包工具](https://github.com/v7lin/walle_kit)

## dart/flutter 私服

* [simple_pub_server](https://github.com/v7lin/simple_pub_server)

## docs

* [腾讯开放平台](https://open.tencent.com/)
* [QQ互联](http://wiki.connect.qq.com/)
* [Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

## android

```groovy
buildscript {
    dependencies {
        // Android 11兼容，需升级Gradle到3.5.4/3.6.4/4.x.y
        classpath 'com.android.tools.build:gradle:3.5.4'
    }
}
```

```groovy
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
腾讯有毒吗？module.modulemap 的内容都没提供完整，特么搞得我差了半天
```

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
tencent: identifier=tencent schemes=tencent${appId}
```

```
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

	<key>LSApplicationQueriesSchemes</key>
	<array>
		<string>tim</string>
		<string>mqq</string>
		<string>mqqapi</string>
		<string>mqqbrowser</string>
		<string>mttbrowser</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV4</string>
		<string>mqzone</string>
		<string>mqzoneopensdk</string>
		<string>mqzoneopensdkapi</string>
		<string>mqzoneopensdkapi19</string>
		<string>mqzoneopensdkapiV2</string>
		<string>mqqapiwallet</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkavatar</string>
		<string>mqqopensdkminiapp</string>
		<string>mqqopensdkdataline</string>
		<string>mqqgamebindinggroup</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>tencentapi.qq.reqContent</string>
		<string>tencentapi.qzone.reqContent</string>
		<string>mqqthirdappgroup</string>
		<string>mqqopensdklaunchminiapp</string>
		<string>mqqopensdkproxylogin</string>
		<string>mqqopensdknopasteboard</string>
	</array>
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoads</key>
		<true/>
		<key>NSExceptionDomains</key>
		<dict>
			<key>gtimg.cn</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>idqqimg.com</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<string>NO</string>
				<key>NSIncludesSubdomains</key>
				<string>YES</string>
			</dict>
			<key>qlogo.cn</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>qplus.com</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>qq.com</key>
			<dict>
				<key>NSExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSExceptionRequiresForwardSecrecy</key>
				<false/>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
		</dict>
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
      url: https://github.com/v7lin/tencent_kit.git
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
