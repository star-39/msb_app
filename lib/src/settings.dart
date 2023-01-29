import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_PUBLISHER = "settings_publisher";
const DEFAULT_PUBLISHER = "@moe_sticker_bot";
var currentPublisher = "";



class SettingsProvider with ChangeNotifier {
  var _publisher = currentPublisher;
  String get publisher => _publisher;

  set publisher(String value) {
    _publisher = value;
    setPublisher(value);
    notifyListeners();
  }
}

void initSettings() async {
  final prefs = await SharedPreferences.getInstance();
  var publisher = prefs.getString(KEY_PUBLISHER);
  if (publisher == null) {
    prefs.setString(KEY_PUBLISHER, DEFAULT_PUBLISHER);
    currentPublisher = DEFAULT_PUBLISHER;
  } else {
    currentPublisher = publisher;
  }
}

Future<String> getPublisher() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(KEY_PUBLISHER) ?? DEFAULT_PUBLISHER;
}

void setPublisher(String s) async {
  // currentPublisher = s;
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_PUBLISHER, s);
}