import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:shimmer/shimmer.dart';

Container showShimmer(BuildContext context) => Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      height: 63.5,
      child: Row(
        children: <Widget>[
          Shimmer.fromColors(
            baseColor: Colors.grey[100],
            highlightColor: Colors.grey[200],
            child: Container(
              width: 80,
              height: 80.0,
              color: Colors.white,
            ),
          ),
          horizontalSizedBoxTwenty(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              verticalSizedBox(),
              Shimmer.fromColors(
                baseColor: Colors.grey[100],
                highlightColor: Colors.grey[200],
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 10.0,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
