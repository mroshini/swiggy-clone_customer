import 'package:flutter/cupertino.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';

String emailValidation(String value) {
  if (value.isEmpty) {
    return 'Please fill this field';
  } else if (!CommonStrings.emailRegEx.hasMatch(value)) {
    return "Please enter valid email address";
  } else {
    return null;
  }
}

String mobileNumberValidation(String value) {
  if (value.isEmpty) {
    return 'Please fill this field';
  } else if (!CommonStrings.mobileRegEx.hasMatch(value)) {
    return "Please enter valid number";
  } else if (value.length < 10 || value.length > 10) {
    return "Please enter valid number";
  } else {
    return null;
  }
}

String mobileNumberValidationInCart(String value, BuildContext context) {
  if (value.isEmpty) {
    showSnackbar(message: 'Please fill this field', context: context);
    return "";
  } else if (!CommonStrings.mobileRegEx.hasMatch(value)) {
    showSnackbar(message: 'Please enter valid number', context: context);
    return "";
  } else if (value.length < 10 || value.length > 10) {
    showSnackbar(message: 'Please enter valid number', context: context);
    return "";
  } else {
    return null;
  }
}

String passwordValidation(String value) {
  if (value.isEmpty) {
    return 'Please fill this field';
  } else if (value.length < 6) {
    return "Password atleast contains 6 letters";
  } else {
    return null;
  }
}

String nameValidation(String value) {
  if (value.isEmpty) {
    return 'Please fill this field';
  } else {
    return null;
  }
}
