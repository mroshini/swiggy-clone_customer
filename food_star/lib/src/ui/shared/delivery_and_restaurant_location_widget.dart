import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';

Column deliveryAndRestaurantLocationColumn(
        {BuildContext context,
        String lineOne,
        TextStyle styleOne,
        String lineTwo}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          lineOne,
          style: styleOne,
        ),
        verticalSizedBox(),
        Text(
          lineTwo,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.display1,
        ),
      ],
    );
