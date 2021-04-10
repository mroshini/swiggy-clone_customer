import 'package:flutter/cupertino.dart';

class MyAccountBodyModel {
  IconData accountIcon;
  String bodyTitle;

  MyAccountBodyModel({
    @required this.accountIcon,
    @required this.bodyTitle,
  });
}

class MyAccountHeaderModel {
  String title;
  List<MyAccountBodyModel> bodyModel;

  MyAccountHeaderModel({
    @required this.title,
    @required this.bodyModel,
  });
}
