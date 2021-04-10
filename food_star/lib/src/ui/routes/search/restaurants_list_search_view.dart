import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/ui/shared/no_search_item_restaurants.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';
import 'package:foodstar/src/utils/restaurant_info_list_shimmer.dart';
import 'package:provider/provider.dart';

class RestaurantListSearchScreen extends StatefulWidget {
  final TextEditingController searchedKeyWord;

  RestaurantListSearchScreen({this.searchedKeyWord});

  @override
  _RestaurantListScreenState createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SearchViewModel>(
        builder: (BuildContext context, SearchViewModel model, Widget child) {
      return model.state == BaseViewState.Busy
          ? Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return showShimmer(context);
                  }),
            )
          : model.listOfRestaurantData.length == 0
              ? Container(
                  child: NoSearchItemsAvailableScreen(
                    title: 'No Restaurant Found',
                  ),
                )
              : Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: model.listOfRestaurantData.length ?? 0,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          model.updateSearchDoneOrNot(false);
                          model.saveClickedThroughSearch(
                              widget.searchedKeyWord.text,
                              model.listOfRestaurantData[index].id.toString(),
                              "",
                              context);
                          widget.searchedKeyWord.text = "";
                          Navigator.of(context)
                              .pushNamed(
                                restaurantDetails,
                                arguments: RestaurantsArgModel(
                                    index: index,
                                    imageTag: "search",
                                    restaurantID:
                                        model.listOfRestaurantData[index].id,
                                    fromWhere: 2,
                                    availabilityStatus: model
                                        .listOfRestaurantData[index]
                                        .availability
                                        .status,
                                    image:
                                        model.listOfRestaurantData[index].src),
                              )
                              .then((value) => {
                                    model.getAlreadySearchedData(context),
                                  });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Hero(
                                    tag: "search$index",
                                    child: model.listOfRestaurantData[index]
                                                .src ==
                                            " "
                                        ? Image.asset(
                                            'assets/images/no_image.png',
                                            height: 80.0,
                                            width: 80.0,
                                          )
                                        : model.listOfRestaurantData[index]
                                                    .availability.status ==
                                                1
                                            ? networkImage(
                                                image: model
                                                    .listOfRestaurantData[index]
                                                    .src,
                                                loaderImage:
                                                    loaderBeforeImage(),
                                                height: 80.0,
                                                width: 80.0,
                                              )
//                                            ? CachedNetworkImage(
//                                                imageUrl: model
//                                                    .listOfRestaurantData[index]
//                                                    .src,
//                                                placeholder: (context, url) =>
//                                                    imageShimmer(),
//                                                errorWidget:
//                                                    (context, url, error) =>
//                                                        Icon(Icons.error),
//                                                fit: BoxFit.fill,
//                                                height: 80.0,
//                                                width: 80.0,
//                                              )
                                            : networkClosedRestImage(
                                                image: model
                                                    .listOfRestaurantData[index]
                                                    .src,
                                                loaderImage:
                                                    loaderBeforeImage(),
                                                height: 80.0,
                                                width: 80.0,
                                              ),
//                                                child: CachedNetworkImage(
//                                                  imageUrl: model
//                                                      .listOfRestaurantData[
//                                                          index]
//                                                      .src,
//                                                  placeholder: (context, url) =>
//                                                      imageShimmer(),
//                                                  errorWidget:
//                                                      (context, url, error) =>
//                                                          Icon(Icons.error),
//                                                  fit: BoxFit.fill,
//                                                  height: 80.0,
//                                                  width: 80.0,
//                                                ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                  height: 10,
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
//                                      Row(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.spaceBetween,
//                                        children: <Widget>[
//                                          Text(
//                                            model.listOfRestaurantData[index]
//                                                .name,
//                                            overflow: TextOverflow.ellipsis,
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                    fontSize: 14,
//                                                    fontWeight:
//                                                        FontWeight.w600),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(
//                                                right: 10.0),
//                                            child: GestureDetector(
//                                              onTap: () {
//                                                if (model
//                                                    .accessToken.isNotEmpty) {
//                                                  model.updateWishListIndex(
//                                                      index);
//                                                  model.wishListRequestFromSearch(
//                                                      restaurantId: model
//                                                          .listOfRestaurantData[
//                                                              index]
//                                                          .id);
//                                                } else {
//                                                  Navigator.pushNamed(
//                                                      context, login);
//                                                }
//                                              },
//                                              child: Icon(
//                                                Icons.favorite,
//                                                color: model
//                                                            .listOfRestaurantData[
//                                                                index]
//                                                            .favouriteStatus ==
//                                                        true
//                                                    ? Colors.red
//                                                    : Colors.grey[300],
//                                              ),
//                                            ),
//                                          ),
//                                        ],
//                                      ),
                                      Text(
                                        model.listOfRestaurantData[index].name,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1
                                            .copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      verticalSizedBoxFive(),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Text(
                                              model.listOfRestaurantData[index]
                                                  .resDesc,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display2
                                                  .copyWith(
                                                    fontSize: 13,
                                                  ),
                                            ),
                                          ),
//                                          Text(
//                                            ' - ',
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display3
//                                                .copyWith(
//                                                  fontWeight: FontWeight.w600,
//                                                ),
//                                          ),
                                          Container(
                                            height: 15,
                                            child: ListView.builder(
                                                itemCount: 4,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder:
                                                    (context, budgetIndex) {
                                                  return Text(
                                                    r"$",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display3
                                                        .copyWith(
                                                          fontSize: 11,
                                                          color: budgetIndex <=
                                                                  model
                                                                      .listOfRestaurantData[
                                                                          index]
                                                                      .budget
                                                              ? Colors.black
                                                              : Colors.grey,
                                                        ),
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                      verticalSizedBoxFive(),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.star,
                                            color: (model
                                                        .listOfRestaurantData[
                                                            index]
                                                        .rating ==
                                                    0)
                                                ? Colors.grey[600]
                                                : Colors.amber,
                                            size: 15.0,
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            model.listOfRestaurantData[index]
                                                .rating
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(fontSize: 12),
                                          ),
                                          Text(
                                            " - ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Text(
                                            '${model.listOfRestaurantData[index].distance} ${CommonStrings.kms}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "- (${model.listOfRestaurantData[index].deliveryTime.toString()} mins) " ??
                                                " ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2
                                                .copyWith(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      verticalSizedBox(),
                                      divider(),
                                      model.listOfRestaurantData[index]
                                                  .availability.status ==
                                              1
                                          ? model.listOfRestaurantData[index]
                                                      .promoStatus ==
                                                  1
                                              ? shopOpenedWidget()
                                              : Container()
                                          : ShopClosedWidget(
                                              nextAvailableText: model
                                                  .listOfRestaurantData[index]
                                                  .availability
                                                  .text,
                                            )
//                                      Visibility(
//                                        visible: model
//                                                    .listOfRestaurantData[index]
//                                                    .availability
//                                                    .status ==
//                                                1
//                                            ? false
//                                            : true,
//                                        child: Column(
//                                          children: <Widget>[
//                                            Divider(
//                                              color: Colors.black45,
//                                            ),
//                                            SizedBox(
//                                              height: 3,
//                                            ),
//                                            ShopClosedWidget(
//                                              nextAvailableText: model
//                                                  .listOfRestaurantData[index]
//                                                  .availability
//                                                  .text
//                                                  .toString(),
//                                            )
//                                          ],
//                                        ),
//                                      ),
//                                      Visibility(
//                                        visible: model
//                                                    .listOfRestaurantData[index]
//                                                    .mode ==
//                                                "open"
//                                            ? false
//                                            : true,
//                                        child: Divider(
//                                          color: Colors.black45,
//                                        ),
//                                      ),
//                                      Visibility(
//                                        visible: model
//                                                    .listOfRestaurantData[index]
//                                                    .mode ==
//                                                "open"
//                                            ? false
//                                            : true,
//                                        child: SizedBox(
//                                          height: 3,
//                                        ),
//                                      ),
//                                      Visibility(
//                                        visible: model
//                                                    .listOfRestaurantData[index]
//                                                    .mode ==
//                                                "open"
//                                            ? false
//                                            : true,
//                                        child: ShopClosedWidget(),
//                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
    });
  }

  Row shopOpenedWidget() => Row(
        children: <Widget>[
          Image.asset(
            "assets/images/percentage.jpg",
            width: 20,
            height: 20,
            color: Colors.blue,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Promo',
            style: Theme.of(context).textTheme.display2.copyWith(fontSize: 13),
          ),
        ],
      );
}
