import 'dart:math';

import 'package:msb_app/src/define.dart';
import 'package:url_launcher/url_launcher.dart';


void launchTGBot() async {
  final Uri tgDeepLink = Uri.parse('tg://resolve?domain=$botName');
  final Uri url = Uri.parse('https://t.me/$botName');
  try {
    await launchUrl(tgDeepLink);
  } on Exception {
    try {
      await launchUrl(url);
    } on Exception {}
  }
}

void openHomePage() async {
  final Uri uri = Uri.parse('https://github.com/star-39/moe-sticker-bot');
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on Exception {}
}

Random _random = Random();

String secHex(int length) {
  StringBuffer sb = StringBuffer();
  for (var i = 0; i < length; i++) {
    sb.write(_random.nextInt(16).toRadixString(16));
  }
  return sb.toString();
}