import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';

class NoSearchItemsAvailableScreen extends StatelessWidget {
  final String title;

  NoSearchItemsAvailableScreen({this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Image.asset(
            'assets/images/no_restaurant.png',
            height: 100,
            width: 100,
          ),
        ),
        verticalSizedBox(),
        Text(
          title,
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
  }
}
