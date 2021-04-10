import 'package:flutter/material.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_menu_popup.dart';

class DialogHelper {
  static showErrorDialog(BuildContext context, String message) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '$message',
            style: Theme.of(context).textTheme.display1.copyWith(fontSize: 17),
          ),
//          content: Text(
//            '$message',
//            style: Theme.of(context).textTheme.display1,
//          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ok',
                style: Theme.of(context).textTheme.display1,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });

  static showProgressDialog(context) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(child: Center(child: CircularProgressIndicator()));
      });
}

Future<int> menuPopup(
    {BuildContext context, RestaurantDetailsViewModel rootModel}) async {
  int selectedMenuIndex = await showDialog(
      context: context,
      builder: (context) => RestaurantMenuPopUpScreen(model: rootModel));

  return selectedMenuIndex;
}

Future<bool> showCartAlreadyExistsDialog({
  BuildContext parentContext,
  Map<String, dynamic> dynamicMapValue,
  int fromWhere,
  int index,
  int parentIndex,
}) async {
  bool statusOfExistingCart = await showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: AlertDialog(
              title: Text(
                'Cart Exists',
                style: Theme.of(context).textTheme.display1,
              ),
              content: Text(
                'Remove existing cart items from restaurant to add new items',
                style: Theme.of(context).textTheme.display2,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: Theme.of(context).textTheme.display1,
                  ),
                  onPressed: () {
//                        if (fromWhere == 1) {
//                          // rest dettails
//                          Provider.of<RestaurantDetailsViewModel>(
//                            parentContext,
//                            listen: false,
//                          ).updateCartAfterCancelExistCartRemoveDialog(
//                            index: index,
//                            parentIndex: parentIndex,
//                          );
//                        } else if (fromWhere == 2) {
//                          Provider.of<SearchViewModel>(
//                            parentContext,
//                            listen: false,
//                          ).updateCartAfterCancelExistCartRemoveDialog(
//                            index: index,
//                            parentIndex: parentIndex,
//                          );
//                        }
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Remove',
                    style: Theme.of(context)
                        .textTheme
                        .display1
                        .copyWith(color: darkRed),
                  ),
                  onPressed: () {
                    ApiRepository(mContext: context).restDeleteIfAlreadyExits(
                        dynamicMapValue: dynamicMapValue, context: context);
                    Navigator.of(context).pop(true);
                  },
                ),
              ]),
        );
      });
  return statusOfExistingCart;
}
