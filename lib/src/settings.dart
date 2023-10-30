
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

const KEY_PUBLISHER = "settings_publisher";
const DEFAULT_PUBLISHER = "@moe_sticker_bot";
bool settingsInitialized = false;

class SettingsProvider with ChangeNotifier {
  String _publisher = DEFAULT_PUBLISHER;
  bool _updateAvailable = false;

  String get publisher => _publisher;
  bool get updateAvailable => _updateAvailable;

  set publisher(String value) {
    _publisher = value;
    setPublisher(value);
    notifyListeners();
  }

  set updateAvailable(bool value) {
    _updateAvailable = value;
    notifyListeners();
  }
}

void initSettings(SettingsProvider provider) async {
  if (settingsInitialized) {
    return;
  }
  final prefs = await SharedPreferences.getInstance();
  var publisher = prefs.getString(KEY_PUBLISHER);
  if (publisher == null) {
    prefs.setString(KEY_PUBLISHER, DEFAULT_PUBLISHER);
    provider.publisher = DEFAULT_PUBLISHER;
  } else {
    provider.publisher = publisher;
  }
  settingsInitialized = true;
}

Future<String> getPublisher() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(KEY_PUBLISHER) ?? DEFAULT_PUBLISHER;
}

void setPublisher(String s) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(KEY_PUBLISHER, s);
}
