import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/buttons/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String title,
    double borderRadius = 10.0,
    VoidCallback onPressed,
    Color buttonColor,
  }) : super(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          color: buttonColor ?? appColor,
          borderRadius: borderRadius,
          onPressed: onPressed,
        );
}
