import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/res/colors.dart';

class CustomRaisedButton extends StatelessWidget {
  final String title;
  final Function buttonHandler;

  CustomRaisedButton(this.title, this.buttonHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        color: appColor,
        child: Text(
          title,
        ),
        onPressed: buttonHandler,
      ),
    );
  }
}
