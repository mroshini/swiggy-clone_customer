//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/material.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
//import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
//import 'package:foodstar/src/ui/shared/sizedbox.dart';
//import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
//import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
//
//class SeeAllSearchRestaurantScreen extends StatefulWidget {
//  @override
//  _SeeAllSearchRestaurantScreenState createState() =>
//      _SeeAllSearchRestaurantScreenState();
//}
//
//class _SeeAllSearchRestaurantScreenState
//    extends State<SeeAllSearchRestaurantScreen> {
//  @override
//  Widget build(BuildContext context) {
//    return BaseWidget<SearchViewModel>(
//        model: SearchViewModel(context: context),
//        onModelReady: (model) => model.seeAllDishByKeyWord(""),
//        builder: (BuildContext context, SearchViewModel model, Widget child) {
//          return Scaffold(
//            body: SafeArea(
//              child: Container(
//                child: Column(
//                  children: <Widget>[
//                    Expanded(
//                      child: model.state == BaseViewState.Busy
//                          ? ListView.builder(
//                              itemCount: 5,
//                              itemBuilder: (context, index) {
//                                return showShimmer(context);
//                              })
//                          : ListView.builder(
//                              itemCount: model.searchList.length ?? 0,
//                              itemBuilder: (context, index) {
//                                return GestureDetector(
//                                  onTap: () {
//                                    model.saveClickedThroughSearch(
//                                        searchEditController.text,
//                                        model.searchList[index].id.toString(),
//                                        model.searchList[index].id.toString());
//                                  },
//                                  child: Container(
//                                    child: Row(
//                                      children: <Widget>[
//                                        ClipRRect(
//                                          borderRadius:
//                                              BorderRadius.circular(10.0),
//                                          child: Hero(
//                                            tag: "search$index",
//                                            child: model.searchList[index]
//                                                        .src ==
//                                                    " "
//                                                ? Image.asset(
//                                                    'assets/images/no_image.png',
//                                                    height: 50.0,
//                                                    width: 50.0,
//                                                  )
//                                                : CachedNetworkImage(
//                                                    imageUrl: model
//                                                        .searchList[index].src,
//                                                    placeholder:
//                                                        (context, url) =>
//                                                            imageShimmer(),
//                                                    errorWidget:
//                                                        (context, url, error) =>
//                                                            Icon(Icons.error),
//                                                    fit: BoxFit.fill,
//                                                    height: 50.0,
//                                                    width: 50.0,
//                                                  ),
//                                          ),
//                                        ),
//                                        horizontalSizedBox(),
//                                        Row(
//                                          children: <Widget>[
//                                            Icon(model.type == "Dish"
//                                                ? Icons.fastfood
//                                                : Icons.restaurant),
//                                            Text(
//                                              model.searchList[index].name,
//                                              overflow: TextOverflow.ellipsis,
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display1,
//                                            ),
//                                          ],
//                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                );
//                              },
//                            ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          );
//        });
//  }
//}
