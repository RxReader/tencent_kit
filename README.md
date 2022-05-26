# tencent_kit

[![Pub Package](https://img.shields.io/pub/v/tencent_kit.svg)](https://pub.dev/packages/tencent_kit)
[![License](https://img.shields.io/github/license/RxReader/tencent_kit)](https://github.com/RxReader/tencent_kit/blob/master/LICENSE)

flutter版腾讯(QQ)SDK

## flutter toolkit

* [flutter版微信SDK](https://github.com/rxreader/wechat_kit)
* [flutter版腾讯(QQ)SDK](https://github.com/rxreader/tencent_kit)
* [flutter版新浪微博SDK](https://github.com/rxreader/weibo_kit)
* [flutter版支付宝SDK](https://github.com/rxreader/alipay_kit)
* [flutter版walle渠道打包工具](https://github.com/rxreader/walle_kit)

## dart/flutter 私服

* [simple_pub_server](https://github.com/rxreader/simple_pub_server)

## docs

* [腾讯开放平台](https://open.tencent.com/)
* [QQ互联](http://wiki.connect.qq.com/)
* [Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

## android

```groovy
android {
    defaultConfig{
        addManifestPlaceholders([
                TENCENT_APP_ID: "your tencent appId"
        ])
    }
}
```

```
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

## ios

```
出于插件的基本需求，将 SDK 的 module.modulemap 内容修改

改前
module TencentOpenApi{
    umbrella header "TencentOpenApiUmbrellaHeader.h"
    export *
}

改后
framework module TencentOpenApi{
    umbrella header "TencentOpenApiUmbrellaHeader.h"
    export *
}
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
		<string>mqqopensdkcheckauth</string>
	</array>
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

* break change
  * 4.0.0: 按标准插件书写重构
  * 3.1.0: 新增 setIsPermissionGranted 函数，设置是否已授权获取设备信息/是否同意隐私协议
  * 3.0.0: 重构
  * 2.1.0: nullsafety & 不再支持 Android embedding v1 & Tencent 单例

* compat
  * flutter 2.5 兼容问题 [issues/54](https://github.com/RxReader/tencent_kit/issues/54)
  ```
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      flutter_additional_ios_build_settings(target)
      # 兼容 Flutter 2.5
      target.build_configurations.each do |config|
  #       config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'
      end
    end
  end
  ```

* snapshot

```
dependencies:
  tencent_kit:
    git:
      url: https://github.com/rxreader/tencent_kit.git
```

* release

```
dependencies:
  tencent_kit: ^${latestTag}
```

* example

[示例](./example/lib/main.dart)

## Star History

![stars](https://starchart.cc/rxreader/tencent_kit.svg)
