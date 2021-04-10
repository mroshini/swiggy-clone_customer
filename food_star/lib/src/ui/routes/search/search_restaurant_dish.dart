import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/already_searched_keyword_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/search/restaurant_item_search_view.dart';
import 'package:foodstar/src/ui/routes/search/restaurants_list_search_view.dart';
import 'package:foodstar/src/ui/shared/no_search_item_restaurants.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var currentIndex = 0;
  TextEditingController searchEditController;
  FocusNode searchTextFocus;

  List<String> searchBy = ['Dishes', 'Restaurant'];

  @override
  void initState() {
    searchEditController = TextEditingController();
    searchTextFocus = FocusNode();

    Provider.of<SearchViewModel>(context, listen: false)
        .getAlreadySearchedData(context);
    super.initState();
  }

  @override
  void dispose() {
    searchEditController.dispose();
    searchTextFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
      builder: (BuildContext context, SearchViewModel model, Widget child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(
                                    5.0,
                                  ),
                                ),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: TextFormField(
                                    textAlign: TextAlign.left,
                                    controller: searchEditController,
                                    focusNode: searchTextFocus,
                                    onChanged: (value) {
                                      print(" showSearchList ${value.length}");
                                      if (value.length >= 3) {
                                        model.updateSearchDoneOrNot(true);
                                        model.searchByDishKeyWord(
                                            keyword: value,
                                            buildContext: context);
                                      } else {
                                        //no need to call api
                                        model.updateSearchDoneOrNot(false);
                                      }
                                    },
                                    textInputAction: TextInputAction.search,
                                    onFieldSubmitted: (term) {
                                      if (term.length >= 3) {
                                        model.updateSearchDoneOrNot(true);
                                        model.searchByDishKeyWord(
                                          keyword: term,
                                        );
                                      } else {
                                        //no need to call api
                                        model.updateSearchDoneOrNot(false);
                                      }
                                      searchTextFocus.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                    },
                                    style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: searchTextFocus.hasFocus
                                            ? S.of(context).searchRestaurants
                                            : S.of(context).searchRestaurants,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                        ),
//                                      suffixIcon: searchTextFocus.hasFocus
//                                          ? IconButton(
//                                              icon: Icon(
//                                                Icons.close,
//                                                color: Colors.black,
//                                              ),
//                                              onPressed: () {
//                                                model.updateSearchDoneOrNot(
//                                                    false);
//                                                searchEditController.text = "";
//                                              },
//                                            )
//                                          : Container(),
                                        prefixIcon: searchTextFocus.hasFocus &&
                                                (searchEditController.text !=
                                                    "")
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  model.updateSearchDoneOrNot(
                                                      false);
                                                  setState(() {
                                                    //   showSearchList = false;
                                                    searchEditController.text =
                                                        "";
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.search,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  searchEditController.text =
                                                      "";
                                                },
                                              )
//                                    IconButton(
//                                            icon: Icon(
//                                              Icons.search,
//                                              color: Colors.black,
//                                            ),
//                                            onPressed: () {
//                                              searchEditController.text = "";
//                                            },
//                                          ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
//                                Container(
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(15.0),
//                                    child: Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.start,
//                                      children: <Widget>[
//                                        Flexible(
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                              color: Colors.grey[100],
//                                              borderRadius:
//                                                  BorderRadius.circular(
//                                                5.0,
//                                              ),
//                                            ),
//                                            height: 50,
//                                            width: MediaQuery.of(context)
//                                                .size
//                                                .width,
//                                            child: TextFormField(
//                                              controller: searchEditController,
//                                              focusNode: searchTextFocus,
//                                              onChanged: (value) {
//                                                print(
//                                                    " showSearchList ${value.length}");
//                                                if (value.length >= 3) {
//                                                  model.updateSearchDoneOrNot(
//                                                      true);
//                                                  model.searchByDishKeyWord(
//                                                    keyword: value,
//                                                  );
//                                                } else {
//                                                  //no need to call api
//                                                  model.updateSearchDoneOrNot(
//                                                      false);
//                                                }
//                                              },
//                                              textInputAction:
//                                                  TextInputAction.search,
//                                              onFieldSubmitted: (term) {
//                                                searchTextFocus.unfocus();
//                                                FocusScope.of(context)
//                                                    .requestFocus(FocusNode());
//                                              },
//                                              style: TextStyle(
//                                                fontStyle: FontStyle.normal,
//                                                color: Colors.black,
//                                                fontSize: 16,
//                                              ),
//                                              decoration: InputDecoration(
//                                                hintText: S
//                                                    .of(context)
//                                                    .searchRestaurants,
//                                                border: InputBorder.none,
//                                                hintStyle: TextStyle(
//                                                  fontSize: 16,
//                                                  color: Colors.grey,
//                                                ),
//                                                prefixIcon: searchTextFocus
//                                                        .hasFocus
//                                                    ? (searchEditController
//                                                                .text ==
//                                                            "")
//                                                        ? IconButton(
//                                                            icon: Icon(
//                                                              Icons.search,
//                                                              color:
//                                                                  Colors.black,
//                                                            ),
//                                                            onPressed: () {
//                                                              searchEditController
//                                                                  .text = "";
//                                                            },
//                                                          )
//                                                        : IconButton(
//                                                            icon: Icon(
//                                                              Icons.arrow_back,
//                                                              color:
//                                                                  Colors.black,
//                                                            ),
//                                                            onPressed: () {
//                                                              model
//                                                                  .updateSearchDoneOrNot(
//                                                                      false);
//                                                              setState(() {
//                                                                //   showSearchList = false;
//                                                                searchEditController
//                                                                    .text = "";
//                                                              });
//                                                            },
//                                                          )
//                                                    : IconButton(
//                                                        icon: Icon(
//                                                          Icons.search,
//                                                          color: Colors.black,
//                                                        ),
//                                                        onPressed: () {
//                                                          searchEditController
//                                                              .text = "";
//                                                        },
//                                                      ),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                        SizedBox(
//                                          width: 5,
//                                        ),
//                                        Material(
//                                          color: transparent,
//                                          child: InkWell(
//                                            child: Container(
//                                              height: 50,
//                                              width: 40,
//                                              decoration: BoxDecoration(
//                                                color: Colors.grey[100],
//                                                borderRadius:
//                                                    BorderRadius.circular(5.0),
//                                              ),
//                                              child: IconButton(
//                                                icon: Icon(
//                                                  Icons.restore,
//                                                  color: Colors.black,
//                                                ),
//                                                onPressed: () {
//                                                  model.updateSearchDoneOrNot(
//                                                      false);
//                                                  searchEditController.text =
//                                                      "";
//                                                },
//                                              ),
//                                            ),
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                ),
                            Visibility(
                              visible: model.isSearching ? false : true,
                              child: model.state == BaseViewState.Busy
                                  ? showProgress(context)
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        (model.recentSearch.length == 0 &&
                                                model.topSearch.length == 0)
                                            ? NoSearchItemsAvailableScreen(
                                                title:
                                                    'No Recent Searchers available for now',
                                              )
                                            : Column(
                                                children: <Widget>[
//                                                  Wrap(children: <Widget>[
//                                                    model.recentSearch.
//                                                  ],)
                                                  showRecentAndTopSearchList(
                                                    S
                                                        .of(context)
                                                        .recentSearchers,
                                                    model.recentSearch,
                                                    true,
                                                    model,
                                                  ),
                                                  verticalSizedBox(),
                                                  showRecentAndTopSearchList(
                                                    S.of(context).topSearchers,
                                                    model.topSearch,
                                                    false,
                                                    model,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: showRestaurantAndDishesList(model),
                              ),
                            ),
                            Visibility(
//                              visible: model.cartData == null ||
//                                      model.cartData.totalQuantity == null
//                                  ? false
//                                  : true,
                              visible: false,
                              child: GestureDetector(
                                onTap: () async {
                                  await model.updateSearchDoneOrNot(false);
                                  Navigator.pushNamed(context, cart,
                                      arguments: true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: appColor,
                                      borderRadius: BorderRadius.circular(
                                        10.0,
                                      ),
                                    ),
                                    child: model.isCartItemChange
                                        ? Center(
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: white,
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              horizontalSizedBox(),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  verticalSizedBoxFive(),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              '${model.cartData?.totalQuantity ?? ""} items | ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .display1
                                                              .copyWith(
                                                                  color: white,
                                                                  fontSize: 11),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '${model.cartData?.totalPrice ?? ""}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .display1
                                                              .copyWith(
                                                                  color: white,
                                                                  fontSize: 11),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              ' ${model.cartData?.totalPrice ?? ""} ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .display1
                                                              .copyWith(
                                                                  color: white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationColor:
                                                                      white,
                                                                  fontSize: 11),
                                                        ),
//                                        TextSpan(
//                                          text: '(est)',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1
//                                              .copyWith(
//                                                color: white,
//                                                fontSize: 10,
//                                              ),
//                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  verticalSizedBoxFive(),
                                                  Text(
                                                    'Cart Items',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display1
                                                        .copyWith(
                                                          color: white,
                                                          fontSize: 11,
                                                        ),
                                                  ),
                                                  verticalSizedBoxFive(),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Icon(
                                                    Icons.shopping_basket,
                                                    color: Colors.white,
                                                    size: 17,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
//                      GestureDetector(
//                        onTap: () async {
//                          navigateToHome(context: context, menuType: 2);
////                          await Navigator.pushNamed(context, cart,
////                                  arguments: true)
////                              .then((value) => {model.updateCartExists()});
//                        },
//                        child: CartQuantityPriceCardView(),
//                      ),
                    ],
                  ),
//                  Visibility(
//                    visible: model.cartData == null ||
//                            model.cartData.totalQuantity == null
//                        ? false
//                        : true,
//                    child: Positioned(
//                      bottom: 10.0,
//                      left: 10.0,
//                      right: 10.0,
//                      child: GestureDetector(
//                        onTap: () {
//                          Navigator.pushNamed(context, cart, arguments: true);
//                        },
//                        child: Container(
//                          decoration: BoxDecoration(
//                            color: appColor,
//                            borderRadius: BorderRadius.circular(
//                              10.0,
//                            ),
//                          ),
//                          child: Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              horizontalSizedBox(),
//                              Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                mainAxisAlignment: MainAxisAlignment.start,
//                                children: <Widget>[
//                                  verticalSizedBoxFive(),
//                                  RichText(
//                                    text: TextSpan(
//                                      children: [
//                                        TextSpan(
//                                          text:
//                                              '${model.cartData?.totalQuantity ?? ""} items | ',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1
//                                              .copyWith(
//                                                  color: white, fontSize: 11),
//                                        ),
//                                        TextSpan(
//                                          text:
//                                              '${model.cartData?.totalPrice ?? ""}',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1
//                                              .copyWith(
//                                                  color: white, fontSize: 11),
//                                        ),
//                                        TextSpan(
//                                          text:
//                                              ' ${model.cartData?.totalPrice ?? ""} ',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display1
//                                              .copyWith(
//                                                  color: white,
//                                                  fontWeight: FontWeight.w400,
//                                                  decoration: TextDecoration
//                                                      .lineThrough,
//                                                  decorationColor: white,
//                                                  fontSize: 11),
//                                        ),
////                                        TextSpan(
////                                          text: '(est)',
////                                          style: Theme.of(context)
////                                              .textTheme
////                                              .display1
////                                              .copyWith(
////                                                color: white,
////                                                fontSize: 10,
////                                              ),
////                                        ),
//                                      ],
//                                    ),
//                                  ),
//                                  verticalSizedBoxFive(),
//                                  Text(
//                                    'Cart Items',
//                                    style: Theme.of(context)
//                                        .textTheme
//                                        .display1
//                                        .copyWith(
//                                          color: white,
//                                          fontSize: 11,
//                                        ),
//                                  ),
//                                  verticalSizedBoxFive(),
//                                ],
//                              ),
//                              Expanded(
//                                child: Padding(
//                                  padding: const EdgeInsets.all(10.0),
//                                  child: Icon(
//                                    Icons.shopping_basket,
//                                    color: Colors.white,
//                                    size: 17,
//                                  ),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

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
//              return LayoutBuilder(builder:
//                  (BuildContext context, BoxConstraints viewportConstraints) {
//                return Stack(
//                  children: <Widget>[
//                    Column(
//                      children: <Widget>[
//                        Expanded(
//                          child: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Container(
//                                child: Padding(
//                                  padding: const EdgeInsets.all(15.0),
//                                  child: Row(
//                                    crossAxisAlignment:
//                                        CrossAxisAlignment.start,
//                                    mainAxisAlignment: MainAxisAlignment.start,
//                                    children: <Widget>[
//                                      Flexible(
//                                        child: Container(
//                                          decoration: BoxDecoration(
//                                            color: Colors.grey[100],
//                                            borderRadius: BorderRadius.circular(
//                                              5.0,
//                                            ),
//                                          ),
//                                          height: 50,
//                                          width:
//                                              MediaQuery.of(context).size.width,
//                                          child: TextFormField(
//                                            controller: searchEditController,
//                                            focusNode: searchTextFocus,
//                                            onChanged: (value) {
//                                              print(
//                                                  " showSearchList ${value.length}");
//                                              if (value.length >= 3) {
//                                                model.updateSearchDoneOrNot(
//                                                    true);
//                                                model.searchByDishKeyWord(
//                                                  keyword: value,
//                                                );
//                                              } else {
//                                                //no need to call api
//                                                model.updateSearchDoneOrNot(
//                                                    false);
//                                              }
//                                            },
//                                            textInputAction:
//                                                TextInputAction.search,
//                                            onFieldSubmitted: (term) {
//                                              searchTextFocus.unfocus();
//                                            },
//                                            style: TextStyle(
//                                              fontStyle: FontStyle.normal,
//                                              color: Colors.black,
//                                              fontSize: 16,
//                                            ),
//                                            decoration: InputDecoration(
//                                              hintText: S
//                                                  .of(context)
//                                                  .searchRestaurants,
//                                              border: InputBorder.none,
//                                              hintStyle: TextStyle(
//                                                fontSize: 16,
//                                                color: Colors.grey,
//                                              ),
//                                              prefixIcon: searchTextFocus
//                                                      .hasFocus
//                                                  ? (searchEditController
//                                                              .text ==
//                                                          "")
//                                                      ? IconButton(
//                                                          icon: Icon(
//                                                            Icons.search,
//                                                            color: Colors.black,
//                                                          ),
//                                                          onPressed: () {
//                                                            searchEditController
//                                                                .text = "";
//                                                          },
//                                                        )
//                                                      : IconButton(
//                                                          icon: Icon(
//                                                            Icons.arrow_back,
//                                                            color: Colors.black,
//                                                          ),
//                                                          onPressed: () {
//                                                            model
//                                                                .updateSearchDoneOrNot(
//                                                                    false);
//                                                            setState(() {
//                                                              //   showSearchList = false;
//                                                              searchEditController
//                                                                  .text = "";
//                                                            });
//                                                          },
//                                                        )
//                                                  : IconButton(
//                                                      icon: Icon(
//                                                        Icons.search,
//                                                        color: Colors.black,
//                                                      ),
//                                                      onPressed: () {
//                                                        searchEditController
//                                                            .text = "";
//                                                      },
//                                                    ),
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      SizedBox(
//                                        width: 5,
//                                      ),
//                                      Material(
//                                        color: transparent,
//                                        child: InkWell(
//                                          child: Container(
//                                            height: 50,
//                                            width: 40,
//                                            decoration: BoxDecoration(
//                                              color: Colors.grey[100],
//                                              borderRadius:
//                                                  BorderRadius.circular(5.0),
//                                            ),
//                                            child: IconButton(
//                                              icon: Icon(
//                                                Icons.restore,
//                                                color: Colors.black,
//                                              ),
//                                              onPressed: () {
//                                                model.updateSearchDoneOrNot(
//                                                    false);
//                                                searchEditController.text = "";
//                                              },
//                                            ),
//                                          ),
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                ),
//                              ),
//                              Visibility(
//                                visible: model.isSearching ? false : true,
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  children: <Widget>[
//                                    (model.recentSearch.length == 0) &&
//                                            (model.topSearch.length == 0)
//                                        ? NoSearchItemsAvailableScreen(
//                                            title:
//                                                'No Recent Searchers available for now',
//                                          )
//                                        : Column(
//                                            children: <Widget>[
//                                              showRecentAndTopSearchList(
//                                                S.of(context).recentSearchers,
//                                                model.recentSearch,
//                                                true,
//                                                model,
//                                              ),
//                                              verticalSizedBox(),
//                                              showRecentAndTopSearchList(
//                                                S.of(context).topSearchers,
//                                                model.topSearch,
//                                                false,
//                                                model,
//                                              ),
//                                            ],
//                                          ),
//                                  ],
//                                ),
//                              ),
//                              Expanded(
//                                child: SingleChildScrollView(
//                                  child: showRestaurantAndDishesList(model),
//                                ),
//                              ),
//                            ],
//                          ),
//                        ),
//                      ],
//                    ),
//                    Visibility(
//                      visible: model.cartData == null ||
//                              model.cartData.totalQuantity == null
//                          ? false
//                          : true,
//                      child: Positioned(
//                        bottom: 10.0,
//                        left: 10.0,
//                        right: 10.0,
//                        child: GestureDetector(
//                          onTap: () {
//                            Navigator.pushNamed(context, cart, arguments: true);
//                          },
//                          child: Container(
//                            decoration: BoxDecoration(
//                              color: appColor,
//                              borderRadius: BorderRadius.circular(
//                                10.0,
//                              ),
//                            ),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              children: <Widget>[
//                                horizontalSizedBox(),
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  children: <Widget>[
//                                    verticalSizedBoxFive(),
//                                    RichText(
//                                      text: TextSpan(
//                                        children: [
//                                          TextSpan(
//                                            text:
//                                                '${model.cartData?.totalQuantity ?? ""} items | ',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                    color: white, fontSize: 11),
//                                          ),
//                                          TextSpan(
//                                            text:
//                                                '${model.cartData?.totalPrice ?? ""}',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                    color: white, fontSize: 11),
//                                          ),
//                                          TextSpan(
//                                            text:
//                                                ' ${model.cartData?.totalPrice ?? ""} ',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                    color: white,
//                                                    fontWeight: FontWeight.w400,
//                                                    decoration: TextDecoration
//                                                        .lineThrough,
//                                                    decorationColor: white,
//                                                    fontSize: 11),
//                                          ),
//                                          TextSpan(
//                                            text: '(est)',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                  color: white,
//                                                  fontSize: 10,
//                                                ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                    verticalSizedBoxFive(),
//                                    Text(
//                                      'Cart Items',
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display1
//                                          .copyWith(
//                                            color: white,
//                                            fontSize: 11,
//                                          ),
//                                    ),
//                                    verticalSizedBoxFive(),
//                                  ],
//                                ),
//                                Expanded(
//                                  child: Padding(
//                                    padding: const EdgeInsets.all(10.0),
//                                    child: Icon(
//                                      Icons.shopping_basket,
//                                      color: Colors.white,
//                                      size: 17,
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ],
//                );
//              });
//            }),
//      ),
//    );
//  }

  Visibility showRestaurantAndDishesList(SearchViewModel model) => Visibility(
        visible: model.isSearching,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 40,
              child: ListView.builder(
                  itemCount: searchBy.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: currentIndex == index ? appColor : white,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: appColor),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                searchBy[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .display3
                                    .copyWith(
                                      color: currentIndex == index
                                          ? white
                                          : Colors.black,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            verticalSizedBox(),
            model.message != ""
                ? Center(
                    child: Text(
                      "${model.message}",
                      style: Theme.of(context).textTheme.display1,
                    ),
                  )
                : currentIndex == 0
                    ? RestaurantItemSearchScreen(
                        // dishes list
                        searchedKeyWord: searchEditController,
                        model: model,
                      )
                    : RestaurantListSearchScreen(
                        // restaurant list
                        searchedKeyWord: searchEditController,
                      ),
          ],
        ),
      );

//  Container restaurantListView(SearchViewModel model) =>
//      model.state == BaseViewState.Busy
//          ? Container(
//              child: ListView.builder(
//                  shrinkWrap: true,
//                  itemCount: 5,
//                  itemBuilder: (context, index) {
//                    return showShimmer(context);
//                  }),
//            )
//          : model.listOfRestaurantData.length == 0
//              ? Container(
//                  child: Center(
//                    child: Text(
//                      "No Restaurant Found",
//                      style: Theme.of(context).textTheme.display1,
//                    ),
//                  ),
//                )
//              : Container(
//                  child: ListView.builder(
//                    shrinkWrap: true,
//                    physics: NeverScrollableScrollPhysics(),
//                    itemCount: model.listOfRestaurantData.length ?? 0,
//                    itemBuilder: (context, index) {
//                      return GestureDetector(
//                        onTap: () {
//                          model.saveClickedThroughSearch(
//                            searchEditController.text,
//                            model.listOfRestaurantData[index].id.toString(),
//                            "",
//                          );
//                        },
//                        child: FoodItems(
//                          restaurantInfo: RestaurantsArgModel(
//                            index: index,
//                            imageTag: "search",
//                            restaurantData: model.listOfRestaurantData[index],
//                            city: "Madurai",
//                          ),
//                        ),
//                      );
//                    },
//                  ),
//                );

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
//              ],
//            ),
//          ),
//        ),
//      );

  Column showRecentAndTopSearchList(String title, List<Search> searchedValues,
          bool hideVisible, SearchViewModel model) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(
              10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.display1),
                Visibility(
                  visible: hideVisible,
                  child: GestureDetector(
                    onTap: () {
                      model.clearRecentAndTopSearch(context);
                    },
                    child: Text(
                      'Clear All',
                      style: Theme.of(context).textTheme.display2.copyWith(
                            color: darkRed,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),

//          Row(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            mainAxisAlignment: MainAxisAlignment.start,
//            children: <Widget>[
//              Wrap(
//                verticalDirection: VerticalDirection.e,
//                //  spacing: 3.0,
//                children: searchedValues
//                    .map(
//                      (e) => Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.all(10.0),
//                            child: GestureDetector(
//                              onTap: () {
//                                model.searchByDishKeyWord(
//                                  keyword: e.keyword,
//                                );
//                                model.updateSearchDoneOrNot(true);
//                              },
//                              child: Container(
//                                decoration: BoxDecoration(
//                                  border: Border.all(
//                                    color: Colors.grey,
//                                  ),
//                                  borderRadius: BorderRadius.circular(
//                                    7.0,
//                                  ),
//                                ),
//                                child: Wrap(
//                                  children: <Widget>[
//                                    Center(
//                                      child: Padding(
//                                        padding: const EdgeInsets.symmetric(
//                                          vertical: 5.0,
//                                          horizontal: 5.0,
//                                        ),
//                                        child: Row(
//                                          children: <Widget>[
//                                            Icon(
//                                              Icons.access_time,
//                                              size: 14,
//                                            ),
//                                            SizedBox(
//                                              width: 5,
//                                            ),
//                                            Text(
//                                              e.keyword,
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2
//                                                  .copyWith(fontSize: 13),
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    )
//                    .toList(),
//              ),
//            ],
//          ),

          Container(
            height: 50,
            child: ListView.builder(
              itemCount: searchedValues.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      searchEditController.text = searchedValues[index].keyword;
                      searchEditController.selection =
                          TextSelection.fromPosition(TextPosition(
                              offset: searchEditController.text.length));
                      model.searchByDishKeyWord(
                        keyword: searchedValues[index].keyword,
                      );
                      model.updateSearchDoneOrNot(true);
                      // model.showCloseIcon(true);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(
                          7.0,
                        ),
                      ),
                      child: Wrap(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 5.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    searchedValues[index].keyword,
                                    style: Theme.of(context)
                                        .textTheme
                                        .display2
                                        .copyWith(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
}
