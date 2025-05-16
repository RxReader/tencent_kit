# tencent_kit

[![Pub Package](https://img.shields.io/pub/v/tencent_kit.svg)](https://pub.dev/packages/tencent_kit)
[![License](https://img.shields.io/github/license/RxReader/tencent_kit)](https://github.com/RxReader/tencent_kit/blob/master/LICENSE)

Flutter 版腾讯(QQ)SDK

## 相关工具

* [Flutter版微信SDK](https://github.com/RxReader/wechat_kit)
* [Flutter版腾讯(QQ)SDK](https://github.com/RxReader/tencent_kit)
* [Flutter版新浪微博SDK](https://github.com/RxReader/weibo_kit)
* [Flutter版支付宝SDK](https://github.com/RxReader/alipay_kit)
* [Flutter版深度链接](https://github.com/RxReader/link_kit)
* [Flutter版walle渠道打包工具](https://github.com/RxReader/walle_kit)

## Dart/Flutter Pub 私服

* [simple_pub_server](https://github.com/RxReader/simple_pub_server)

## 相关文档

* [腾讯开放平台](https://open.tencent.com/)
* [QQ互联](http://wiki.connect.qq.com/)
* [QQ 创建、填写及校验UniversalLinks](https://wiki.connect.qq.com/%E5%A1%AB%E5%86%99%E5%8F%8A%E6%A0%A1%E9%AA%8Cuniversallinks)
* [Apple Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html)

## 开始使用

### Android

```txt
# 不需要做任何额外接入工作
# 配置已集成到脚本里
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

### iOS

> 暂不支持 SceneDelegate，详见文档 [iOS_SDK环境搭建](https://wiki.connect.qq.com/ios_sdk%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%ba)

```txt
# 不需要做任何额外接入工作
# 配置已集成到脚本里
```

* Universal Links

apple-app-site-association - 通过 https://${your applinks domain}/.well-known/apple-app-site-association 链接可访问

示例:

https://${your applinks domain}/universal_link/${example_app}/qq_conn/${appId}

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "${your team id}.${your app bundle id}",
        "paths": [
          "/universal_link/${example_app}/qq_conn/${your tencent app id}/*"
        ]
      }
    ]
  }
}
```

> ⚠️ 很多 SDK 都会用到 universal_link，可为不同 SDK 分配不同的 path 以作区分

### HarmonyOS

* 当前在 `HarmonyOS` 平台, 仅支持 `setIsPermissionGranted/registerApp/isQQInstalled/loginServerSide`
* 由于 SDK 限制，当前仅支持 Server-Side 模式登录，请调用 `loginServerSide` 方法登录, 支持拉起 App 授权或 H5 授权 (qrcode 为 true 即可)
* 为了 API 统一, Server-Side 模式授权返回的 auth code 存储在 `TencentLoginResp.accessToken` (不要当成客户端的 token 使用)
* 详情阅读官方文档: [harmonyos_sdk 环境搭建](https://wiki.connect.qq.com/harmonyos_sdk%e7%8e%af%e5%a2%83%e6%90%ad%e5%bb%ba), 并阅读最后的说明
* 关于在后端使用 code 换取 access_token 的问题, 请参考官方文档: [通过Authorization Code获取Access Token](https://wiki.connect.qq.com/%E4%BD%BF%E7%94%A8authorization_code%E8%8E%B7%E5%8F%96access_token#:~:text=Step2%EF%BC%9A%E9%80%9A%E8%BF%87Authorization%20Code%E8%8E%B7%E5%8F%96Access%20Token) , `redirect_uri` 一般为 `auth://tauth.qq.com/`

项目中 module.json5 的 "module" 节点下配置 querySchemes

```json5
"querySchemes": [
    "https",
    "qqopenapi"
]
```

在 Ability 的 skills 节点中配置 scheme

```json5
"skills": [
 {
    "entities": [
      "entity.system.browsable"
    ],
    "actions": [
      "ohos.want.action.viewData"
    ],
    "uris": [
      {
        "scheme": "qqopenapi", // 接收 QQ 回调数据
        "host": "102061317", // 业务申请的互联 appId
        "path": "auth",
        "linkFeature": "Login",
      }
    ]
  }
]
```

### Flutter

|分享类型|说说(图/文/视频)|文本|图片|音乐|视频|网页|
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|QQ|不支持|不支持|支持|支持|不支持|支持|
|QZone|支持|不支持|不支持|不支持|不支持|支持|

* 注意

⚠️⚠️⚠️ registerApp 前必须先调用 setIsPermissionGranted [issues/60](https://github.com/RxReader/tencent_kit/issues/60) [issues/79](https://github.com/RxReader/tencent_kit/issues/79)

* 兼容

flutter 2.5 兼容问题 [issues/54](https://github.com/RxReader/tencent_kit/issues/54)

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    # 兼容 Flutter 2.5
    target.build_configurations.each do |config|
      # config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'i386 arm64'
    end
  end
end
```

* 配置

```yaml
dependencies:
  tencent_kit: ^${latestTag}
#  tencent_kit:
#    git:
#      url: https://github.com/RxReader/tencent_kit.git

tencent_kit:
  app_id: ${your tencent app id}
  universal_link: https://${your applinks domain}/universal_link/${example_app}/qq_conn/${your tencent app id}/ # 可选项目
```

* 安装（仅iOS）

```shell
# step.1 安装必要依赖
sudo gem install plist
# step.2 切换工作目录，插件里为 example/ios/，普通项目为 ios/
cd example/ios/
# step.3 执行脚本
pod install
```

## 示例

[示例](./example/lib/main.dart)

## Star History

![stars](https://starchart.cc/rxreader/tencent_kit.svg)
