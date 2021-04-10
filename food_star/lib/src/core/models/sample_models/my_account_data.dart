import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/models/sample_models/my_account_model.dart';

class MyAccountData {
  List<MyAccountHeaderModel> afterLogin = [
    MyAccountHeaderModel(
        title: CommonStrings.account, bodyModel: bodyAccountDataAfterLogin),
    MyAccountHeaderModel(
        title: CommonStrings.general, bodyModel: bodyAccountDataTwo),
  ];

  List<MyAccountHeaderModel> beforeLogin = [
    MyAccountHeaderModel(
        title: CommonStrings.account, bodyModel: bodyAccountDataBeforeLogin),
    MyAccountHeaderModel(
        title: CommonStrings.general, bodyModel: bodyAccountDataTwo),
  ];

  List<MyAccountHeaderModel> afterSocialLogin = [
    MyAccountHeaderModel(
        title: CommonStrings.account,
        bodyModel: bodyAccountDataAfterSocialLogin),
    MyAccountHeaderModel(
        title: CommonStrings.general, bodyModel: bodyAccountDataTwo),
  ];

  static List<MyAccountBodyModel> bodyAccountDataAfterLogin = [
    MyAccountBodyModel(
      accountIcon: Icons.playlist_add_check,
      bodyTitle: CommonStrings.myOrders,
    ),
    MyAccountBodyModel(
      accountIcon: Icons.local_offer,
      bodyTitle: CommonStrings.favourites,
    ),
    MyAccountBodyModel(
      accountIcon: Icons.edit_location,
      bodyTitle: CommonStrings.manageAddress,
    ),
    MyAccountBodyModel(
      accountIcon: Icons.settings_backup_restore,
      bodyTitle: CommonStrings.changePassword,
    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.payment,
//      bodyTitle: CommonStrings.payment,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.language,
      bodyTitle: CommonStrings.changeLanguage,
    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.help_outline,
//      bodyTitle: CommonStrings.changeCurrency,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.people_outline,
      bodyTitle: CommonStrings.inviteFriends,
    ),
  ];

  static List<MyAccountBodyModel> bodyAccountDataAfterSocialLogin = [
    MyAccountBodyModel(
      accountIcon: Icons.playlist_add_check,
      bodyTitle: CommonStrings.myOrders,
    ),
    MyAccountBodyModel(
      accountIcon: Icons.local_offer,
      bodyTitle: CommonStrings.favourites,
    ),
    MyAccountBodyModel(
      accountIcon: Icons.edit_location,
      bodyTitle: CommonStrings.manageAddress,
    ),

//    MyAccountBodyModel(
//      accountIcon: Icons.payment,
//      bodyTitle: CommonStrings.payment,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.language,
      bodyTitle: CommonStrings.changeLanguage,
    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.help_outline,
//      bodyTitle: CommonStrings.changeCurrency,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.people_outline,
      bodyTitle: CommonStrings.inviteFriends,
    ),
  ];

  static List<MyAccountBodyModel> bodyAccountDataBeforeLogin = [
//    MyAccountBodyModel(
//      accountIcon: Icons.playlist_add_check,
//      bodyTitle: CommonStrings.myOrders,
//    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.local_offer,
//      bodyTitle: CommonStrings.favourites,
//    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.edit_location,
//      bodyTitle: CommonStrings.manageAddress,
//    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.settings_backup_restore,
//      bodyTitle: CommonStrings.changePassword,
//    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.payment,
//      bodyTitle: CommonStrings.payment,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.language,
      bodyTitle: CommonStrings.changeLanguage,
    ),
//    MyAccountBodyModel(
//      accountIcon: Icons.help_outline,
//      bodyTitle: CommonStrings.changeCurrency,
//    ),
    MyAccountBodyModel(
      accountIcon: Icons.people_outline,
      bodyTitle: CommonStrings.inviteFriends,
    ),
  ];

  static List<MyAccountBodyModel> bodyAccountDataTwo = [
    MyAccountBodyModel(
      accountIcon: Icons.description,
      bodyTitle: 'Privacy Policy',
    ),
    MyAccountBodyModel(
      accountIcon: Icons.note,
      bodyTitle: 'Terms Of Service',
    )
  ];
}
