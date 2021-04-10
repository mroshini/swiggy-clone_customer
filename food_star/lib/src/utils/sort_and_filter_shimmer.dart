import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:shimmer/shimmer.dart';

class SortAndFilterShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    width: 80,
                    height: 20.0,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
        horizontalSizedBox(),
        Expanded(
          flex: 2,
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          width: 15,
                          height: 15.0,
                        ),
                      ),
                      horizontalSizedBoxTwenty(),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[100],
                        highlightColor: Colors.grey[200],
                        child: Container(
                          width: 80,
                          height: 10.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}
