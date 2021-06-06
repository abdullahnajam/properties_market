import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  Future<bool> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool language = prefs.getBool('language') ?? false;
    print("pref $language");
    return language;

  }
  setPref(bool language)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setBool('language', language);
  }
}