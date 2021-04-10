import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FavoritesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            child: Shimmer.fromColors(
              child: Card(
                color: Colors.grey[400],
              ),
              baseColor: Colors.grey[100],
              highlightColor: Colors.white,
              direction: ShimmerDirection.ltr,
            ),
          ),
        );
      },
    );
  }
}
