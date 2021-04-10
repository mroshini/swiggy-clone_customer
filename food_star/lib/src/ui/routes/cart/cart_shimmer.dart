import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

Column showCartShimmer(BuildContext context) => Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 15.0,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150.0,
                child: Shimmer.fromColors(
                  child: Card(
                    color: Colors.grey[400],
                  ),
                  baseColor: Colors.grey[200],
                  highlightColor: Colors.white,
                  direction: ShimmerDirection.ltr,
                ),
              ),
            ),
          ),
        ),
        verticalSizedBoxTwenty(),
        ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return showShimmer(context);
            }),
        verticalSizedBoxTwenty(),
//        Column(
//          children: <Widget>[
//            Row(
//              children: <Widget>[
//                Shimmer.fromColors(
//                  baseColor: Colors.grey[100],
//                  highlightColor: Colors.grey[200],
//                  child: Container(
//                    width: 40,
//                    height: 40.0,
//                    color: Colors.white,
//                  ),
//                ),
//                horizontalSizedBoxTwenty(),
//                Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Shimmer.fromColors(
//                      baseColor: Colors.grey[100],
//                      highlightColor: Colors.grey[200],
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 2,
//                        height: 10.0,
//                        color: Colors.white,
//                      ),
//                    ),
//                    verticalSizedBox(),
//                    Shimmer.fromColors(
//                      baseColor: Colors.grey[100],
//                      highlightColor: Colors.grey[200],
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 5,
//                        height: 10.0,
//                        color: Colors.green,
//                      ),
//                    ),
//                    verticalSizedBox(),
//                    Shimmer.fromColors(
//                      baseColor: Colors.grey[100],
//                      highlightColor: Colors.grey[200],
//                      child: Container(
//                        width: MediaQuery.of(context).size.width / 3,
//                        height: 10.0,
//                        color: Colors.green,
//                      ),
//                    ),
//                  ],
//                ),
//              ],
//            ),
//            Shimmer.fromColors(
//              baseColor: Colors.grey[100],
//              highlightColor: Colors.grey[200],
//              child: Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: Container(
//                  width: MediaQuery.of(context).size.width,
//                  height: 40.0,
//                  color: Colors.white,
//                ),
//              ),
//            ),
//          ],
//        )
      ],
    );
