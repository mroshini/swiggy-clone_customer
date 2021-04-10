import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

Row paymentDetailRow(
        {String textValueOne = "",
        TextStyle styleOne,
        bool showSubTextOne = false,
        String subTextValueOne = "",
        TextStyle styleSubTextOne,
        String textValueTwo = "",
        TextStyle styleTwo,
        Function onPressedTextTwo,
        Function onPressedTextOne}) =>
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                textValueOne,
                overflow: TextOverflow.ellipsis,
                style: styleOne,
              ),
              SizedBox(
                height: 5.0,
              ),
//              Visibility(
//                visible: showSubTextOne,
//                child: Text(
//                  subTextValueOne,
//                  style: styleSubTextOne,
//                ),
//              ),
            ],
          ),
        ),
        Flexible(
          child: Material(
            color: transparent,
            child: InkWell(
              onTap: onPressedTextTwo,
              child: Text(
                textValueTwo,
                style: styleTwo,
              ),
            ),
          ),
        ),
      ],
    );

IconButton closeIconButton({BuildContext context, Function onClicked}) =>
    IconButton(
      icon: Icon(
        Icons.close,
        size: 25,
      ),
      onPressed: () {
        //Navigator.of(context).pop();
        onClicked();
      },
    );

Future<bool> openBottomSheet(BuildContext context, Widget routeName,
    {bool scrollControlled = false}) async {
  bool popStatusOfBottomSheet = await showModalBottomSheet(
    builder: (context) => routeName,
    context: context,
    isScrollControlled: scrollControlled,
  );
  return popStatusOfBottomSheet;
}

Future<String> openFoodItemEditBottomSheet(
    BuildContext context, Widget routeName,
    {bool scrollControlled = false}) async {
  String popStatusOfBottomSheet = await showModalBottomSheet(
    builder: (context) => routeName,
    context: context,
    isScrollControlled: scrollControlled,
  );
  return popStatusOfBottomSheet;
}

Center dragIcon() => Center(
      child: Icon(Icons.drag_handle, color: Colors.grey),
    );

endOfScrollIfNoItemsAvailable(BuildContext context) => Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Center(
        child: Image.asset(
          'assets/images/foodstar_logo.png',
          height: 100,
          width: 100,
        ),
      ),
    );

Row freeDeliveryWidget(BuildContext context) => Row(
      children: <Widget>[
        Image.asset(
          "assets/images/percentage.jpg",
          width: 20,
          height: 20,
          color: Colors.green,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          CommonStrings.freeDelivery,
          style: Theme.of(context).textTheme.display1.copyWith(fontSize: 14),
        ),
      ],
    );

SharedPreferences prefs;

showShareIntent(String content) async {
  String urlToRedirect = "";
  await initPref();
  if (fetchTargetPlatform() == "android") {
    urlToRedirect = prefs.getString(SharedPreferenceKeys.androidPlayStoreLink);
  } else {
    urlToRedirect = prefs.getString(SharedPreferenceKeys.appleStoreLink);
  }

  Share.share('$content $urlToRedirect', subject: 'Share with');
}

initPref() async {
  if (prefs == null) prefs = await SharedPreferences.getInstance();
}
