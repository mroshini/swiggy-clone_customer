import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/res/colors.dart';

class ShopClosedWidget extends StatelessWidget {
  final int status;
  final String nextAvailableText;
  final bool showIcon;

  ShopClosedWidget(
      {this.status = 0, this.nextAvailableText = "", this.showIcon = true});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          showIcon && status == 0
              ? WidgetSpan(
                  child: Icon(
                    Icons.access_time,
                    size: 15,
                    color: status == 0 ? darkRed : darkGreen,
                  ),
                )
              : TextSpan(text: " "),
//          TextSpan(
//            text: status == 0 ? 'Closed' : "Opened",
//            style: Theme.of(context).textTheme.display1.copyWith(
//                color: status == 0 ? darkRed : darkGreen, fontSize: 13),
//          ),
//          TextSpan(
//            text: "  ",
//            style: TextStyle(
//                fontSize: 16.0, fontWeight: FontWeight.w600, color: darkRed),
//          ),
          TextSpan(
            text: status == 0 ? '$nextAvailableText' : "",
            style: Theme.of(context)
                .textTheme
                .display1
                .copyWith(fontSize: 13, color: darkRed),
          ),
        ],
      ),
    );
  }
}

RichText shopOpenedWidget(
        {BuildContext context,
        int status = 0,
        String nextAvailableText = ""}) =>
    RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              Icons.access_time,
              size: 15,
              color: darkGreen,
            ),
          ),
          TextSpan(
            text: "Available",
            style: Theme.of(context).textTheme.display2.copyWith(
                color: darkGreen, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
