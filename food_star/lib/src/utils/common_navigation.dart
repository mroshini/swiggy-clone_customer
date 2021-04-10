import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/ui/res/colors.dart';

navigateToHome({BuildContext context, int menuType = 0}) {
  Navigator.of(context).pushNamedAndRemoveUntil(
      mainHome, (Route<dynamic> route) => false,
      arguments: menuType);
//  Navigator.pushNamed(
//    context,
//    mainHome,
//  );
}

navigateToUserLocation({BuildContext context, Map<String, String> args}) {
  Navigator.pushNamed(
    context,
    searchLocation,
    arguments: args,
  );
}

void showAlertDialog({BuildContext context, String errorMessage}) {
  // flutter defined function

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        title: new Text(
          errorMessage,
          style: Theme.of(context).textTheme.display1,
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog

          FlatButton(
            child: new Text("ok"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<dynamic> showInfoAlertDialog(
    {BuildContext context, String response, Function onClicked}) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text(
      "OK",
      style: Theme.of(context).textTheme.display3,
    ),
    onPressed: () {
      // onClicked();Navigator.of(context, rootNavigator: true).pop('alert');
      Navigator.pop(context, true);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
    title: Text(
      response,
      style: Theme.of(context).textTheme.display1,
    ),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  var status = showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );

  return status;
}

Future<dynamic> showLogoutDialog(
    {BuildContext context, String response, Function onClicked}) {
  // set up the button
  Widget logOutButton = FlatButton(
    child: Text(
      "Logout",
      style: Theme.of(context).textTheme.display3.copyWith(color: darkRed),
    ),
    onPressed: () {
      Navigator.pop(context,
          true); //Navigator.of(context, rootNavigator: true).pop('alert');
    },
  );

  Widget cancelButton = FlatButton(
    child: Text(
      "Cancel",
      style: Theme.of(context).textTheme.display3,
    ),
    onPressed: () {
      Navigator.pop(context, false);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(15),
    ),
    title: Text(
      'Are you sure want to logout?',
      style: Theme.of(context).textTheme.display1,
    ),
    actions: [
      cancelButton,
      logOutButton,
    ],
  );

  // show the dialog
  var status = showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
  return status;
}
