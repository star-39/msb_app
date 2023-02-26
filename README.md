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
This app utilizes [whatsapp_stickers_exporter](https://pub.dev/packages/whatsapp_stickers_exporter), which is aslo part of the [moe-sticker-bot](https://github.com/star-39/moe-sticker-bot) suite, and is available here: https://github.com/star-39/whatsapp_stickers_exporter.

這個app使用 [whatsapp_stickers_exporter](https://pub.dev/packages/whatsapp_stickers_exporter)。 其也是 [moe-sticker-bot](https://github.com/star-39/moe-sticker-bot) 套件的一部分, 專案位於: https://github.com/star-39/whatsapp_stickers_exporter.

![スクリーンショット 2023-01-21 午前12 27 44](https://user-images.githubusercontent.com/75669297/213735948-487bdcb0-15d1-4565-b55a-97ee98390225.png)



## Build

Install Flutter: https://docs.flutter.dev/get-started/install

### iOS
macOS 10.15+ is recommended.

Please open `ios/Runner.xcworkspace` in Xcode and sign the app, then:
```sh
flutter build ipa \
 --dart-define=MSB_WEBAPP_URL=https://msb.cloudns.asia/webapp \
 --dart-define=MSB_BOT_NAME=moe_sticker_bot
```

### Android
Make sure you have set-up JDK 11 environment, you can verify with `flutter doctor`

Please edit `android/key.properties` to sign the app, then pass following arguments:

```sh
flutter build ipa \
 --dart-define=MSB_WEBAPP_URL=https://msb.cloudns.asia/webapp \
 --dart-define=MSB_BOT_NAME=moe_sticker_bot \
 -P=storePassword=your_pass \
 -P=keyPassword=your_pass
```

## License
GPL v3

![image](https://www.gnu.org/graphics/gplv3-with-text-136x68.png)