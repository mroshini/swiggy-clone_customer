import 'package:flutter/material.dart';

class LanguagesModel {
  String languageName;
  String translatedLanguageName;
  String languageCode;
  String languageCountryCode;
  String flag;

  LanguagesModel(
      {@required this.languageName,
      this.translatedLanguageName,
      this.languageCountryCode,
      @required this.languageCode,
      this.flag});
}

class LanguagesData {
  List<LanguagesModel> languages = [
    LanguagesModel(
        languageName: 'English',
        translatedLanguageName: 'English',
        languageCode: "en",
        languageCountryCode: "US",
        flag: 'assets/images/us.png'),
    LanguagesModel(
        languageName: 'Arabic',
        translatedLanguageName: 'عربى',
        languageCode: 'ar',
        languageCountryCode: ' ',
        flag: 'assets/images/arabic.png'),
    LanguagesModel(
        languageName: 'Tamil',
        translatedLanguageName: 'தமிழ்',
        languageCode: 'ta',
        languageCountryCode: ' ',
        flag: 'assets/images/india.png'),
  ];
}
