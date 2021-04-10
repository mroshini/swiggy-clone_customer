//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:foodstar/generated/l10n.dart';
//import 'package:foodstar/src/core/models/api_models/already_searched_keyword_model.dart';
//import 'package:foodstar/src/core/models/sample_models/home_model_data.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
//import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
//import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
//import 'package:foodstar/src/ui/res/colors.dart';
//import 'package:foodstar/src/ui/routes/search/sort_filter_screen.dart';
//import 'package:foodstar/src/ui/shared/home_search_listView_widget.dart';
//import 'package:foodstar/src/ui/shared/others.dart';
//import 'package:foodstar/src/ui/shared/sizedbox.dart';
//import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
//import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
//
//class SearchScreen extends StatefulWidget {
//  @override
//  _SearchScreenState createState() => _SearchScreenState();
//}
//
//class _SearchScreenState extends State<SearchScreen> {
//  var currentIndex = 0;
//  TextEditingController searchEditController = TextEditingController();
//  FocusNode searchTextFocus = new FocusNode();
//  var homeInfo = HomeModelData().homeInfo;
//  bool _showShimmerView = false;
//  bool showSearchList = false;
//  bool isSearching = false;
//
//  List<String> _recentSearch = [
//    'KFC',
//    "Domino's Pizza",
//    'Sekar Konar mess',
//    "Domino's Pizza",
//    'Sekar Konar mess'
//  ];
//
//  List<String> _imagePath = [
//    "assets/images/food2.jpg",
//    "assets/images/food1.jpg",
//    "assets/images/food3.jpg",
//    "assets/images/food1.jpg",
//    "assets/images/food2.jpg",
//    "assets/images/food1.jpg",
//    "assets/images/food3.jpg",
//    "assets/images/food1.jpg",
//    "assets/images/food2.jpg",
//    "assets/images/food1.jpg",
//    "assets/images/food3.jpg",
//    "assets/images/food1.jpg",
//  ];
//
//  @override
//  void initState() {
//    super.initState();
//    // create a future delayed function that will change showInagewidget to true after 5 seconds
//
//    Future.delayed(const Duration(seconds: 1), () {
//      setState(() {
//        _showShimmerView = true;
//      });
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      resizeToAvoidBottomInset: false,
//      body: SafeArea(
//        child: BaseWidget<SearchViewModel>(
//            model: SearchViewModel(context: context),
//            onModelReady: (model) => model.getAlreadySearchedData(),
//            builder:
//                (BuildContext context, SearchViewModel model, Widget child) {
//              return Column(
//                children: <Widget>[
//                  Container(
//                    child: Padding(
//                      padding: const EdgeInsets.all(15.0),
//                      child: Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Flexible(
//                            child: Container(
//                              decoration: BoxDecoration(
//                                color: Colors.grey[100],
//                                borderRadius: BorderRadius.circular(
//                                  5.0,
//                                ),
//                              ),
//                              height: 50,
//                              width: MediaQuery.of(context).size.width,
//                              child: TextField(
//                                focusNode: searchTextFocus,
//                                onChanged: (value) {
//                                  print(" showSearchList ${value.length}");
//                                  if (value.length >= 3) {
//                                    setState(() {
//                                      isSearching = true;
//                                    });
//                                    model.searchByDishKeyWord(
//                                      searchFor: "search",
//                                      keyword: value,
//                                    );
//                                  } else {
//                                    //no need to call api
//                                  }
//                                },
//                                controller: searchEditController,
//                                style: TextStyle(
//                                  fontStyle: FontStyle.normal,
//                                  color: Colors.black,
//                                  fontSize: 16,
//                                ),
//                                decoration: InputDecoration(
//                                  hintText: S.of(context).searchRestaurants,
//                                  border: InputBorder.none,
//                                  hintStyle: TextStyle(
//                                    fontSize: 16,
//                                    color: Colors.grey,
//                                  ),
//                                  prefixIcon: searchTextFocus.hasFocus
//                                      ? (searchEditController.text == "")
//                                          ? IconButton(
//                                              icon: Icon(
//                                                Icons.search,
//                                                color: Colors.black,
//                                              ),
//                                              onPressed: () {
//                                                searchEditController.text = "";
//                                              },
//                                            )
//                                          : IconButton(
//                                              icon: Icon(
//                                                Icons.arrow_back,
//                                                color: Colors.black,
//                                              ),
//                                              onPressed: () {
//                                                //   Navigator.of(context).pop();
//                                                setState(() {
//                                                  isSearching = false;
//                                                  //   showSearchList = false;
//                                                  searchEditController.text =
//                                                      "";
//                                                });
//                                              },
//                                            )
//                                      : IconButton(
//                                          icon: Icon(
//                                            Icons.search,
//                                            color: Colors.black,
//                                          ),
//                                          onPressed: () {
//                                            searchEditController.text = "";
//                                          },
//                                        ),
//                                ),
//                              ),
//                            ),
//                          ),
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Material(
//                            color: transparent,
//                            child: InkWell(
//                              child: Container(
//                                height: 50,
//                                width: 40,
//                                decoration: BoxDecoration(
//                                  color: Colors.grey[100],
//                                  borderRadius: BorderRadius.circular(5.0),
//                                ),
//                                child: IconButton(
//                                  icon: Icon(
//                                    Icons.filter_list,
//                                    color: Colors.black,
//                                  ),
//                                  onPressed: () {
//                                    openBottomSheet(context, SortFilterScreen(),
//                                        scrollControlled: true);
//                                  },
//                                ),
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                  ),
//                  Visibility(
//                    visible: isSearching ? false : true,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Visibility(
//                          visible:
//                              model.recentSearch.length != 0 ? true : false,
//                          child: showRecentAndTopSearchList(
//                            S.of(context).recentSearchers,
//                            model.recentSearch,
//                            true,
//                            model,
//                          ),
//                        ),
//                        Visibility(
//                          visible: model.topSearch.length != 0 ? true : false,
//                          child: showRecentAndTopSearchList(
//                            S.of(context).topSearchers,
//                            model.topSearch,
//                            false,
//                            model,
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  //showSearchedList(model),
//                ],
//              );
//            }),
//      ),
//    );
//  }
//
//  Visibility showSearchedList(SearchViewModel model) => Visibility(
//        visible: isSearching,
//        child: Align(
//          alignment: Alignment.topCenter,
//          child: Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 10.0),
//            child: Column(
//              children: <Widget>[
//                Visibility(
//                  visible: model.searchList.length != 0,
//                  child: Container(
//                    // color: Colors.grey[200],
//                    height: MediaQuery.of(context).size.height * 0.70,
//                    child: Column(
//                      children: <Widget>[
//                        Expanded(
//                          child: model.state == BaseViewState.Busy
//                              ? ListView.builder(
//                                  itemCount: 5,
//                                  itemBuilder: (context, index) {
//                                    return showShimmer(context);
//                                  })
//                              : ListView.builder(
//                                  itemCount: model.searchList.length ?? 0,
//                                  itemBuilder: (context, index) {
//                                    return GestureDetector(
//                                      onTap: () {
//                                        model.saveClickedThroughSearch(
//                                            searchEditController.text,
//                                            model.searchList[index].id
//                                                .toString(),
//                                            model.searchList[index].id
//                                                .toString());
//                                      },
//                                      child: Container(
//                                        child: Row(
//                                          children: <Widget>[
//                                            ClipRRect(
//                                              borderRadius:
//                                                  BorderRadius.circular(10.0),
//                                              child: Hero(
//                                                tag: "search$index",
//                                                child: model.searchList[index]
//                                                            .src ==
//                                                        " "
//                                                    ? Image.asset(
//                                                        'assets/images/no_image.png',
//                                                        height: 50.0,
//                                                        width: 50.0,
//                                                      )
//                                                    : CachedNetworkImage(
//                                                        imageUrl: model
//                                                            .searchList[index]
//                                                            .src,
//                                                        placeholder:
//                                                            (context, url) =>
//                                                                imageShimmer(),
//                                                        errorWidget: (context,
//                                                                url, error) =>
//                                                            Icon(Icons.error),
//                                                        fit: BoxFit.fill,
//                                                        height: 50.0,
//                                                        width: 50.0,
//                                                      ),
//                                              ),
//                                            ),
//                                            horizontalSizedBox(),
//                                            Row(
//                                              children: <Widget>[
//                                                Icon(model.type == "Dish"
//                                                    ? Icons.fastfood
//                                                    : Icons.restaurant),
//                                                Text(
//                                                  model.searchList[index].name,
//                                                  overflow:
//                                                      TextOverflow.ellipsis,
//                                                  style: Theme.of(context)
//                                                      .textTheme
//                                                      .display1,
//                                                ),
//                                              ],
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                    );
//                                  },
//                                ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//                Container(
//                  width: MediaQuery.of(context).size.width,
//                  child: Padding(
//                    padding: const EdgeInsets.all(8.0),
//                    child: Column(
//                      children: <Widget>[
//                        Text(
//                          model.message ?? "",
//                          style: Theme.of(context).textTheme.subhead,
//                        ),
//                        verticalSizedBoxTwenty(),
//                        GestureDetector(
//                          onTap: () {
//                          },
//                          child: Text(
//                            'See All',
//                            style: Theme.of(context)
//                                .textTheme
//                                .subhead
//                                .copyWith(decoration: TextDecoration.underline),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
//      );
//
//  Column showRecentAndTopSearchList(String title, List<Search> searchedValues,
//          bool hideVisible, SearchViewModel model) =>
//      Column(
//        children: <Widget>[
//          Padding(
//            padding: const EdgeInsets.all(
//              10.0,
//            ),
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Text(title, style: Theme.of(context).textTheme.display1),
//                Visibility(
//                  visible: hideVisible,
//                  child: GestureDetector(
//                    onTap: () {
//                      model.seeAllDishByKeyWord();
//                    },
//                    child: Text(
//                      'Clear All',
//                      style: Theme.of(context).textTheme.display2.copyWith(
//                            color: darkRed,
//                          ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Container(
//            height: 50,
//            child: ListView.builder(
//              itemCount: searchedValues.length,
//              shrinkWrap: true,
//              scrollDirection: Axis.horizontal,
//              itemBuilder: (context, index) {
//                return Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      border: Border.all(
//                        color: Colors.grey,
//                      ),
//                      borderRadius: BorderRadius.circular(
//                        7.0,
//                      ),
//                    ),
//                    child: Wrap(
//                      children: <Widget>[
//                        Center(
//                          child: Padding(
//                            padding: const EdgeInsets.symmetric(
//                              vertical: 5.0,
//                              horizontal: 5.0,
//                            ),
//                            child: Row(
//                              children: <Widget>[
//                                Icon(
//                                  Icons.access_time,
//                                  size: 14,
//                                ),
//                                SizedBox(
//                                  width: 5,
//                                ),
//                                Text(
//                                  searchedValues[index].keyword,
//                                  style: Theme.of(context)
//                                      .textTheme
//                                      .display2
//                                      .copyWith(fontSize: 13),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                );
//              },
//            ),
//          ),
//        ],
//      );
//
//  Visibility filterSearchResults() => Visibility(
//        visible: showSearchList ? true : false,
//        child: Expanded(
//          child: ListView.builder(
//            itemCount: homeInfo.length,
//            itemBuilder: (context, index) {
////              return _showShimmerView
////                  ? FoodItems(
////                      index: index,
////                    )
////                  : showShimmer(context);
//              return FoodItems(
//                index: index,
//              );
//            },
//          ),
//        ),
//      );
//}
