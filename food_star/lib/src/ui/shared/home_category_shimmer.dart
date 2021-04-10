import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeCategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 70,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: categoryColors[index],
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[100],
                  highlightColor: Colors.grey[200],
                  child: Container(
                    height: 80,
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      // color: categoryColors[index],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
