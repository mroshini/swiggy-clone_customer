import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:shimmer/shimmer.dart';

Column showCartAndFavoritesShimmer(BuildContext context) => Column(
      children: <Widget>[
        Container(
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
              baseColor: Colors.grey[100],
              highlightColor: Colors.white,
              direction: ShimmerDirection.ltr,
            ),
          ),
        ),
        verticalSizedBoxTwenty(),
        showShimmer(context),
      ],
    );
