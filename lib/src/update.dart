import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:msb_app/src/define.dart';
import 'package:msb_app/src/settings.dart';

class ReleaseObjectList {}

class ReleaseObject {
  final String html_url;
  final String tag_name;
  final String name;
  final String published_at;
  final String body;

  const ReleaseObject(
      {required this.html_url,
      required this.tag_name,
      required this.name,
      required this.published_at,
      required this.body});

  factory ReleaseObject.fromJson(Map<String, dynamic> json) {
    return ReleaseObject(
        html_url: json['html_url'] as String,
        tag_name: json['tag_name'] as String,
        name: json['name'] as String,
        published_at: json['published_at'] as String,
        body: json['body'] as String);
  }
}

//Return true if cloud version is newer.
Future<bool> checkUpdate(SettingsProvider provider) async {
  try {
    final res = await Dio().get(
        "https://api.github.com/repos/star-39/msb_app/releases?per_page=1");
    final rel = ReleaseObject.fromJson(res.data[0]);
    if (compareVersion(versionNumber, rel.tag_name)) {
      provider.updateAvailable = true;
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

//return true if cloud version is newer.
bool compareVersion(String now, String cloud) {
  log(now);
  log(cloud);
  now = now.replaceAll("v", "");
  cloud = cloud.replaceAll("v", "");
  final nowl = now.split(".");
  final cloudl = cloud.split(".");
  if (int.parse(nowl[0]) < int.parse(cloudl[0])) {
    return true;
  }
  if (int.parse(nowl[1]) < int.parse(cloudl[1])) {
    return true;
  }
  if (int.parse(nowl[2]) < int.parse(cloudl[2])) {
    return true;
  }
  return false;
}
