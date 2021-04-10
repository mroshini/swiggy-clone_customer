import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/sample_models/languages_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/language_changer.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguageScreen extends StatefulWidget {
  @override
  _ChangeLanguageScreenState createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  var language = LanguagesData().languages;
  SharedPreferences prefs;
  var selectedLanguage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectedLanguageIndex();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  void setSelectedLanguageIndex() async {
    await initPref();
    prefs.setInt(SharedPreferenceKeys.selectedIndex, selectedLanguage);
  }

  void getSelectedLanguageIndex() async {
    await initPref();
    selectedLanguage = prefs.getInt(SharedPreferenceKeys.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          S.of(context).languages,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: Consumer<LanguageManager>(
        builder: (context, locale, child) {
          return ListView.separated(
              itemCount: language.length,
              separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[200],
                  ),
              itemBuilder: (context, index) {
                return Material(
                  color: transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        S.load(language[index].languageCode == "ar"
                            ? Locale("ar", '')
                            : Locale("${language[index].languageCode}",
                                "${language[index].languageCountryCode}"));

                        locale.changeLanguage(language[index].languageCode,
                            language[index].languageCountryCode);

                        //  print("appLocale ${locale.appLocale}");

//                        language.indexOf(LanguagesModel(
//                            languageCode: "${locale.appLocale}",
//                            languageName: null));

                        selectedLanguage = index;

                        setSelectedLanguageIndex();

                        print("Languages \"${language[index].languageCode}\"");
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    language[index].flag,
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      selectedLanguage == index ? true : false,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      color: appColor.withOpacity(0.50),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            horizontalSizedBoxTwenty(),
                            Column(
                              children: <Widget>[
                                Text(language[index].languageName),
                                verticalSizedBox(),
                                Text(language[index].translatedLanguageName),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
