# msb_app
## Moe Sticker App

__This app is part of the [moe-sticker-bot](https://github.com/star-39/moe-sticker-bot) suite.__

__這個app是 [moe-sticker-bot](https://github.com/star-39/moe-sticker-bot) 套件的一部分.__


## Features/功能

* Export sticker set from Telegram to WhatsApp.

* Supports iOS and Android.

* 匯出Telegram貼圖包到WhatsApp。

* 支援iOS和Android。

### For Developers/開發者資訊
This app utilizes https://pub.dev/packages/whatsapp_stickers_exporter

這個app使用 https://pub.dev/packages/whatsapp_stickers_exporter


## Install/安裝

### Android
Download latest APK and install:

下載最新的APK然後安裝：

https://github.com/star-39/msb_app/releases/latest/download/msb_app.apk

### iPhone
Requires AltStore, you can [search Google for how to install AltStore](https://www.google.com/search?q=how+to+install+altstore).

Once you get it installed, download latest IPA on your iphone and open it with AltStore.

需要安裝AltStore, 您可以[搜尋Google如何安裝AltStore](https://www.google.com/search?q=altstore教學)。

安裝完成後， 在iPhone上下載最新的IPA檔案， 然後用AltStore打開。

IPA:

https://github.com/star-39/msb_app/releases/latest/download/msb_app.ipa


## Screenshots

<image src="https://user-images.githubusercontent.com/75669297/221397295-8a6aee6a-3fa4-4129-a2f3-f5f4fe04bf40.png" width="300"/>  <image src="https://user-images.githubusercontent.com/75669297/221521875-9cabbe7d-ec91-4380-b126-cae5fd575d39.png" width="250"/>


<img width="300" src="https://user-images.githubusercontent.com/75669297/218153727-5fb1d3e0-3770-4dc8-a2b5-3e0ecd89a003.png"/> <img width="300" src="https://user-images.githubusercontent.com/75669297/221529085-2581bcca-fe49-46b0-8123-5614e90a838c.png"/>


## Build

Install Flutter: https://docs.flutter.dev/get-started/install

### iOS
macOS 10.15+ is recommended.

Please open `ios/Runner.xcworkspace` in Xcode and sign the app, then:
```sh
flutter build ios --dart-define=MSB_BOT_NAME=moe_sticker_bot
```

### Android
Make sure you have set-up JDK environment, you can verify with `flutter doctor`

Create a file named android/key.properties that contains a reference to your keystore:
```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=<location of the key store file, such as /Users/<user name>/upload-keystore.jks>
```

For details, please refer to https://docs.flutter.dev/deployment/android#create-an-upload-keystore

Build:
```sh
flutter build apk --dart-define=MSB_BOT_NAME=moe_sticker_bot 
```

## Development
Use `msb://` URI to invoke msb_app.

### Routes
#### `/export`
Params:

* `sn`: Sticker set name.
* `qid`: Query ID.
* `hex`: Hex verification code.
* `ws`: Target WebApp website. 

#### `/settings`
#### `/about`

## License
GPL v3

![image](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)
