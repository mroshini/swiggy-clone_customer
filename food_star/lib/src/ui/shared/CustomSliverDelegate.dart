import 'package:flutter/material.dart';

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 2 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 2,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              backgroundColor: Colors.green,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              elevation: 0.0,
//              title: Opacity(
//                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
//                  child: Text("Test")),
            ),
          ),
          Positioned(
            top: cardTopPosition > 0 ? 300 : 0,
            child: Card(
              elevation: 20.0,
              child: Image.asset(
                'assets/images/food2.jpg',
                height: 50,
                width: 80,
              ),
            ),
          ),
//          Positioned(
//            left: 0.0,
//            right: 0.0,
//            top: cardTopPosition > 0 ? cardTopPosition : 0,
//            bottom: 0.0,
//            child: Opacity(
//              opacity: percent,
//              child: Padding(
//                padding: EdgeInsets.symmetric(horizontal: 30 * percent),
//                child: Card(
//                  elevation: 20.0,
//                  child: Image.asset('assets/images/food2.jpg'),
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
