import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

//Container showLocationShimmer(BuildContext context) => Container(
//      alignment: Alignment.centerLeft,
//      margin: const EdgeInsets.symmetric(
//        vertical: 10.0,
//        horizontal: 15.0,
//      ),
//      height: 10.5,
//      child: Shimmer.fromColors(
//        baseColor: Colors.grey[100],
//        highlightColor: Colors.grey[200],
//        child: Container(
//          width: 50,
//          height: 5.0,
//          color: Colors.green,
//        ),
//      ),
//    );

class ShowLocationShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      height: 10.5,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100],
        highlightColor: Colors.grey[200],
        child: Container(
          width: 50,
          height: 5.0,
          color: Colors.green,
        ),
      ),
    );
  }
}

class ShowCurrentLocationShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 15.0,
      ),
      height: 10.5,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100],
        highlightColor: Colors.grey[200],
        child: Container(
          width: 80,
          height: 10.0,
          color: Colors.green,
        ),
      ),
    );
  }
}
