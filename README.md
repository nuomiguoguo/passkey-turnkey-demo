# turnkey_demo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## iOS passkey 配置
1、在自己的域名服务器 api-dev.app.io 跟目录下的.known 下配置 webcredentials 服务 json格式 
{
  "webcredentials": {
  "apps": [ "5R1BHA4SH3.com.app.example" ]  //app bundleId
   },
}
2、On the Apple Developer website, I have added an identifier for my application with 'Associated Domains' enabled to the Certificates, Identifiers & Profiles list of identifiers.
3、in Associated Domains in the Signing & Capabilities tab in Xcode. 
- webcredentials:api-dev.app.io?mode=developer
4、On the iOS device, enable Associated Domains for development. This is found under Settings > Developer > Universal Links: Associated Domains Development

## android passkey 配置
1、在自己的域名服务器 api-dev.app.io 跟目录下的.known 下配置 assetlinks 服务 json格式  
[
    {
        "relation": [
            "delegate_permission/common.handle_all_urls",
            "delegate_permission/common.get_login_creds"
        ],
    "target": {
    "namespace": "android_app",
    "package_name": "com.app.example", //包名与工程一致
    "sha256_cert_fingerprints": [
            "E2:21:E0:0A:EB:41:FB:E5:FC:8D:E5:E6:91:A2:E9:90:AF:9E:AE:15:EB:1E:93:BD:02:A6:DA:9F:A5:14:95:92"
        ]
        }
    }
]
2、AndroidManifest.xml 文件配置
    <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
            <data android:scheme="http"/>
            <data android:scheme="https"/>
            <data android:host="api-dev.app.io"/>
    </intent-filter>
3、app 目录下 gradle 配置签名 确保能与 assetlinks文件中sha256保持一致
