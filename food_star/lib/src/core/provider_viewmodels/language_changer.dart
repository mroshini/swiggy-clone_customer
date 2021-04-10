import 'package:flutter/cupertino.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager extends ChangeNotifier {
  Locale _appLocale;
  SharedPreferences prefs;
  String language;

  Locale get appLocale => _appLocale;

  LanguageManager() {
    // _appLocale = Locale("en", '');
    _loadLocaleFromPref();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  void changeLanguage(String languageCode, String countryCode) async {
    await initPref();
    print("Lanugage -- $languageCode,$countryCode");

    if (languageCode == "ar") {
      _appLocale = Locale("ar");
      await prefs.setString(SharedPreferenceKeys.translateLanguageCode, 'ar');
      await prefs.setString(SharedPreferenceKeys.countryCode, '');
    } else {
      _appLocale = Locale("$languageCode");

      await prefs.setString(
          SharedPreferenceKeys.translateLanguageCode, languageCode);
      await prefs.setString(SharedPreferenceKeys.countryCode, countryCode);
    }
    print("Lanugage11 -- $languageCode,$countryCode");
    notifyListeners();
  }

  _loadLocaleFromPref() async {
    await initPref();
    print("_loadLocaleFromPref1 -- ${prefs.getString(
      SharedPreferenceKeys.translateLanguageCode,
    )}");
    language = prefs.getString(
          SharedPreferenceKeys.translateLanguageCode,
        ) ??
        "en";
    //prefs.getString(SharedPreferenceKeys.countryCode)
    _appLocale =
        Locale(language, prefs.getString(SharedPreferenceKeys.countryCode));

    print("_loadLocaleFromPref -- ${prefs.getString(
      SharedPreferenceKeys.translateLanguageCode,
    )}");

    notifyListeners();
  }
}
