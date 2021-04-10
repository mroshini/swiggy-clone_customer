//import 'package:flutter/material.dart';
//import 'package:foodstar/generated/l10n.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
//import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
//import 'package:foodstar/src/ui/res/colors.dart';
//
//class ShowTopAndRecentSearchScreen extends StatefulWidget {
//  @override
//  _ShowTopAndRecentSearchScreenState createState() =>
//      _ShowTopAndRecentSearchScreenState();
//}
//
//class _ShowTopAndRecentSearchScreenState
//    extends State<ShowTopAndRecentSearchScreen> {
//  @override
//  Widget build(BuildContext context) {
//    return BaseWidget <SearchViewModel>(
//        model: SearchViewModel(context: context),
//        onModelReady: (model) => model.getAlreadySearchedData(),
//        builder:
//            (BuildContext context, SearchViewModel model, Widget child) {
//          return Column(
//            mainAxisSize: MainAxisSize.min,
//            children: <Widget>[
//              Padding(
//                padding: const EdgeInsets.all(
//                  10.0,
//                ),
//                child: Row(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text(title, style: Theme
//                        .of(context)
//                        .textTheme
//                        .display1),
//                    Text(
//                      S
//                          .of(context)
//                          .clear,
//                      style: Theme
//                          .of(context)
//                          .textTheme
//                          .display2
//                          .copyWith(
//                        color: darkRed,
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                height: 50,
//                child: ListView.builder(
//                  itemCount: searchedValues.length,
//                  shrinkWrap: true,
//                  scrollDirection: Axis.horizontal,
//                  itemBuilder: (context, index) {
//                    return Padding(
//                      padding: const EdgeInsets.all(10.0),
//                      child: Container(
//                        decoration: BoxDecoration(
//                          border: Border.all(
//                            color: Colors.grey,
//                          ),
//                          borderRadius: BorderRadius.circular(
//                            7.0,
//                          ),
//                        ),
//                        child: Wrap(
//                          children: <Widget>[
//                            Center(
//                              child: Padding(
//                                padding: const EdgeInsets.symmetric(
//                                  vertical: 5.0,
//                                  horizontal: 5.0,
//                                ),
//                                child: Row(
//                                  children: <Widget>[
//                                    Icon(
//                                      Icons.access_time,
//                                      size: 14,
//                                    ),
//                                    SizedBox(
//                                      width: 5,
//                                    ),
//                                    Text(
//                                      searchedValues[index].keyword,
//                                      style: Theme
//                                          .of(context)
//                                          .textTheme
//                                          .display2
//                                          .copyWith(fontSize: 13),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    );
//                  },
//                ),
//              ),
//            ],
//          );
//        });
//  }
