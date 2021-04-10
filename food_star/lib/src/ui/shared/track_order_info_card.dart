import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';

class TrackOrderInfoCard extends StatefulWidget {
  @override
  _TrackOrderInfoCardState createState() => _TrackOrderInfoCardState();
}

class _TrackOrderInfoCardState extends State<TrackOrderInfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(showLocationMapScreen,
            arguments: 4 // show order success details below map
            );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: appColor,
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your order has been placed successfully. \n Tap to track your order',
                  style: Theme.of(context).textTheme.display1.copyWith(
                        color: white,
                        fontSize: 11,
                      ),
                ),
                verticalSizedBox(),
                Expanded(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
