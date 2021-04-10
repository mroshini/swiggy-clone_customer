import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/models/sample_models/restaurant_item_data.dart';
import 'package:foodstar/src/core/models/sample_models/restaurant_item_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/favorites_view_model.dart';
import 'package:foodstar/src/ui/shared/colored_sized_box.dart';
import 'package:foodstar/src/ui/shared/favorites_shimmer.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<RestaurantItemModel> mFavouriteItem =
      RestaurantItemData().favouriteItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          S.of(context).myFavourites,
          style: Theme.of(context).textTheme.subhead,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: BaseWidget<FavoritesViewModel>(
          model: FavoritesViewModel(context: context),
          onModelReady: (model) => model.initApiFavoritesApiCall(context),
          builder:
              (BuildContext context, FavoritesViewModel model, Widget child) {
            return model.state == BaseViewState.Busy
                ? FavoritesShimmer()
                : model.aRestaurant.length == 0 || model.aRestaurant == null
                    ? Scaffold(
                        body: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Image.asset(
                                "assets/images/empty_cart.png",
                                height: 300,
                                width: 300,
                              ),
                            ),
                            verticalSizedBox(),
                            Center(
                              child: Text(
                                'No Favourites restaurant available',
                                style: Theme.of(context).textTheme.subhead,
                              ),
                            )
                          ],
                        ),
                      )
                    : Scaffold(
                        body: ListView.builder(
                            itemCount: model.aRestaurant.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(
                                          restaurantDetails,
                                          arguments: RestaurantsArgModel(
                                            imageTag: "favorites${index}",
                                            restaurantID:
                                                model.aRestaurant[index].id,
                                            image: model.aRestaurant[index].src,
                                            fromWhere: 1,
                                            city: model.aRestaurant[index].city,
                                            availabilityStatus: model
                                                .aRestaurant[index]
                                                .availability
                                                .status,
                                          ),
                                        )
                                        .then((value) => {
                                              model.updateAfterBackPress(),
                                            });
                                  },
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            model.aRestaurant[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display3
                                                .copyWith(
                                                  fontSize: 15,
                                                ),
                                          ),
                                        ),
                                        verticalSizedBox(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                          ),
                                          child: Text(
                                            model.aRestaurant[index].location,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2
                                                .copyWith(
                                                  fontSize: 15,
                                                ),
                                          ),
                                        ),
                                        verticalSizedBoxTwenty(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Row(
                                            children: <Widget>[
//                                    Container(
//                                      height: 30,
//                                      width: 80,
//                                      decoration: BoxDecoration(
//                                        borderRadius:
//                                            BorderRadius.circular(5.0),
//                                        border: Border.all(
//                                            color: Colors.green[700]),
//                                      ),
//                                      child: Center(
//                                        child: Text(
//                                          S.of(context).open,
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display3
//                                              .copyWith(
//                                                color: Colors.green[700],
//                                                fontWeight: FontWeight.w600,
//                                              ),
//                                        ),
//                                      ),
//                                    ),
                                              model
                                                          .aRestaurant[index]
                                                          .availability
                                                          .status ==
                                                      1
                                                  ? shopOpenedWidget(
                                                      context: context)
                                                  : ShopClosedWidget(
                                                      status: model
                                                          .aRestaurant[index]
                                                          .availability
                                                          .status,
                                                      nextAvailableText: model
                                                          .aRestaurant[index]
                                                          .availability
                                                          .text
                                                          .toString(),
                                                    ),
//                                    horizontalSizedBox(),
//                                    Text(
//                                      model.aRestaurant[index].availability.text,
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display2
//                                          .copyWith(
//                                            fontSize: 15,
//                                          ),
//                                    ),
                                            ],
                                          ),
                                        ),
                                        verticalSizedBoxTwenty(),
                                        Stack(
                                          children: <Widget>[
                                            Container(
                                              height: 180,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: model
                                                          .aRestaurant[index]
                                                          .availability
                                                          .status ==
                                                      1
                                                  ? networkImage(
                                                      image: model
                                                          .aRestaurant[index]
                                                          .src,
                                                      loaderImage:
                                                          loaderBeforeResturantDetailBannerImage())
                                                  : networkClosedRestImage(
                                                      image: model
                                                          .aRestaurant[index]
                                                          .src,
                                                      loaderImage:
                                                          loaderBeforeResturantDetailBannerImage()),
//                                    child: Image.asset(
//                                      model.aRestaurant[index].src,
//                                      fit: BoxFit.cover,
//                                    ),
                                            ),
//                                    Visibility(
//                                      visible: false,
//                                      child: Positioned(
//                                        top: 140.0,
//                                        left:
//                                            MediaQuery.of(context).size.width /
//                                                2.2,
//                                        child: Container(
//                                          height: 25,
//                                          decoration: BoxDecoration(
//                                            borderRadius:
//                                                BorderRadius.circular(5.0),
//                                            color: Colors.blue[500],
//                                          ),
//                                          child: Center(
//                                            child: RichText(
//                                              text: TextSpan(
//                                                children: [
//                                                  TextSpan(
//                                                    text: ' ',
//                                                  ),
//                                                  WidgetSpan(
//                                                    child: Icon(
//                                                      Icons
//                                                          .account_balance_wallet,
//                                                      size: 18,
//                                                      color: white,
//                                                    ),
//                                                  ),
//                                                  TextSpan(
//                                                    text: ' gopay',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display3
//                                                        .copyWith(
//                                                            color: white,
//                                                            fontSize: 14,
//                                                            fontWeight:
//                                                                FontWeight
//                                                                    .bold),
//                                                  ),
//                                                  TextSpan(
//                                                    text: ' DELIVERY PROMO ',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display2
//                                                        .copyWith(
//                                                            color: white,
//                                                            fontSize: 12,
//                                                            fontStyle: FontStyle
//                                                                .normal),
//                                                  ),
//                                                ],
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
                                          ],
                                        ),
                                        verticalSizedBoxTwenty(),
//                              verticalSizedBox(),
//                              Padding(
//                                padding: const EdgeInsets.all(10.0),
//                                child: ListView.separated(
//                                  separatorBuilder: (context, index) => Divider(
//                                    color: Colors.grey[200],
//                                  ),
//                                  shrinkWrap: true,
//                                  itemCount: mFavouriteItem.length,
//                                  physics: NeverScrollableScrollPhysics(),
//                                  itemBuilder: (context, index) {
//                                    return Padding(
//                                      padding: const EdgeInsets.symmetric(
//                                          vertical: 8.0),
////                                  child: RestaurantItem(
////                                    itemInfo: [],
////                                    childIndex: index,
////                                  ),
//                                    );
//                                  },
//                                ),
//                              ),
                                        VerticalColoredSizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
          },
        ),
      ),
    );
  }
}
