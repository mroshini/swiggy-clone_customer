import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:shimmer/shimmer.dart';

class AddressListShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 15.0,
            ),
            height: 63.5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    width: 30,
                    height: 20.0,
                  ),
                ),
                horizontalSizedBox(),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                      verticalSizedBox(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: MediaQuery.of(context).size.width / 5,
                          height: 10.0,
                          color: Colors.green,
                        ),
                      ),
//                verticalSizedBox(),
//                Shimmer.fromColors(
//                  baseColor: Colors.grey[100],
//                  highlightColor: Colors.grey[200],
//                  child: Container(
//                    width: MediaQuery.of(context).size.width / 3,
//                    height: 10.0,
//                    color: Colors.green,
//                  ),
//                ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
