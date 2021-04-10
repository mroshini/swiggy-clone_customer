import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/res/colors.dart';

showSnackbar({BuildContext context, String message, TextStyle messageStyle}) {
  final scaff = Scaffold.of(context);

  scaff.showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: messageStyle ??
            Theme.of(context).textTheme.display1.copyWith(
                  color: white,
                ),
      ),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 3),
//    action: SnackBarAction(
//      label: 'UNDO',
//      onPressed: scaff.hideCurrentSnackBar,
//    ),
    ),
  );
}
