import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_map_view_arg_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/circle_profile_image.dart';
import 'package:foodstar/src/ui/shared/shop_closed_widget.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';

class RestaurantInfoScreen extends StatefulWidget {
  final RestaurantsMapViewArgModel restaurantData;

  RestaurantInfoScreen({this.restaurantData});

  @override
  _RestaurantInfoScreenState createState() =>
      _RestaurantInfoScreenState(restaurantData: restaurantData);
}

class _RestaurantInfoScreenState extends State<RestaurantInfoScreen> {
  final RestaurantsMapViewArgModel restaurantData;

  _RestaurantInfoScreenState({this.restaurantData});

  int _selectedDate = 0;
  List<String> openingHoursList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
      ),
      body: Consumer<ThemeManager>(
        builder: (BuildContext context, ThemeManager theme, Widget child) {
          return Container(
            // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: theme.darkMode
                  ? Border.all()
                  : Border.all(color: Colors.grey[200], width: .5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              //controller: scrollController,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      // dragIcon(),
                      verticalSizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              restaurantData.restaurantName,
                              // restaurantData[restaurantName],
                              style: Theme.of(context).textTheme.subhead,
                            ),
                          ),
                          horizontalSizedBox(),
//                                      Container(
//                                        height: 30,
//                                        width: 30,
//                                        child: CircleAvatar(
//                                          backgroundColor: darkGreen,
//                                          child: Icon(
//                                            Icons.call,
//                                            color: white,
//                                          ),
//                                        ),
//                                      ),
                        ],
                      ),
                      verticalSizedBox(),
                      Text(
                        restaurantData.description,
                        style: Theme.of(context).textTheme.display2,
                      ),
                      verticalSizedBox(),
                      divider(),
                      //verticalSizedBox(),
//                                  Text(
//                                    'Rating',
//                                    style: Theme.of(context).textTheme.display1,
//                                  ),
//                                  verticalSizedBoxTwenty(),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.star, color: Colors.amber),
                                horizontalSizedBox(),
                                Text(
                                  restaurantData.rating,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                                horizontalSizedBox(),
//                                            Text(
//                                              '1000+ rating',
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2,
//                                            ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      verticalSizedBoxTwenty(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              horizontalSizedBox(),
                              Flexible(
                                child: Text(
                                  restaurantData.location,
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              )
                            ],
                          ),
                          verticalSizedBox(),
                          Row(
                            children: <Widget>[
                              Text(
                                "${restaurantData.distance} ${CommonStrings.kms}",
                                style: Theme.of(context).textTheme.display2,
                              ),
                              horizontalSizedBoxFive(),
                              Text(
                                "- (${restaurantData.timing} mins)",
                                style: Theme.of(context).textTheme.display2,
                              )
                            ],
                          ),
                        ],
                      ),
                      verticalSizedBoxTwenty(),

                      restaurantData.availabilityStatus == "1"
                          ? shopOpenedWidget(context: context)
                          : ShopClosedWidget(
                              nextAvailableText:
                                  restaurantData.nextAvailabilityText),

//                                  Padding(
//                                    padding: const EdgeInsets.all(
//                                      10.0,
//                                    ),
//                                    child: Row(
//                                      crossAxisAlignment:
//                                          CrossAxisAlignment.start,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        Flexible(
//                                          child: buildRatingRow(
//                                            image: 'assets/images/shop1.jpg',
//                                            lineOne: 'Great taste',
//                                            lineTwo: '1000+ rating',
//                                            context: context,
//                                          ),
//                                        ),
//                                        Flexible(
//                                          child: buildRatingRow(
//                                            image: 'assets/images/shop1.jpg',
//                                            lineOne: 'Freshly made',
//                                            lineTwo: '100+ rating',
//                                            context: context,
//                                          ),
//                                        ),
//                                        Flexible(
//                                          child: buildRatingRow(
//                                            image: 'assets/images/shop2.jpg',
//                                            lineOne: 'Proper packaging',
//                                            lineTwo: '100+ rating',
//                                            context: context,
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                  ),
                      verticalSizedBoxTwenty(),
                      Text(
                        S.of(context).openingHours,
                        style: Theme.of(context).textTheme.display1,
                      ),
                      verticalSizedBox(),
//                                  Row(
//                                    children: <Widget>[
//                                      Icon(
//                                        Icons.access_time,
//                                        color: restaurantData[
//                                                    availabilityStatus] ==
//                                                "0"
//                                            ? darkRed
//                                            : darkGreen,
//                                      ),
//                                      horizontalSizedBox(),
//                                      ShopClosedWidget(
//                                          status: int.parse(restaurantData[
//                                              availabilityStatus]),
//                                          nextAvailableText: restaurantData[
//                                              nextAvailabilityText],
//                                          showIcon: false),
//                                    ],
//                                  ),
                      ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                          color: Colors.grey[200],
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: restaurantData.restaurantTiming.length,
                        itemBuilder: (context, index) {
                          return Material(
                            color: transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedDate = index;
                                });
                              },
                              child: Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.date_range,
                                      color: theme.darkMode
                                          ? _selectedDate == index
                                              ? Colors.white
                                              : Colors.grey
                                          : _selectedDate == index
                                              ? Colors.black
                                              : Colors.black54,
                                    ),
                                    onPressed: () {},
                                  ),
                                  horizontalSizedBoxTwenty(),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            restaurantData
                                                .restaurantTiming[index].day,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display1
                                                .copyWith(
                                                  color: theme.darkMode
                                                      ? _selectedDate == index
                                                          ? Colors.white
                                                          : Colors.grey
                                                      : _selectedDate == index
                                                          ? Colors.black
                                                          : Colors.black54,
                                                  fontSize: 16,
                                                ),
                                          ),
                                          verticalSizedBox(),
                                          restaurantData.restaurantTiming[index]
                                                      .dayStatus ==
                                                  "1"
                                              ? Text(
                                                  '${restaurantData.restaurantTiming[index].startTime1} - ${restaurantData.restaurantTiming[index].endTime1}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2
                                                      .copyWith(
                                                        color: theme.darkMode
                                                            ? _selectedDate ==
                                                                    index
                                                                ? Colors.white
                                                                : Colors.grey
                                                            : _selectedDate ==
                                                                    index
                                                                ? Colors.black
                                                                : Colors
                                                                    .black54,
                                                      ),
                                                )
                                              : Text(
                                                  CommonStrings.unServicable,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display1
                                                      .copyWith(
                                                        color: darkRed,
                                                      ),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Column buildRatingRow({
    String image,
    String lineOne,
    String lineTwo,
    BuildContext context,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          circleProfileImage(
            heightValue: 60,
            widthValue: 60,
            image: 'assets/images/shop1.jpg',
            mContext: context,
          ),
          verticalSizedBox(),
          Text(
            lineOne,
            style: Theme.of(context).textTheme.display1,
          ),
          verticalSizedBox(),
          Text(
            lineTwo,
            style: Theme.of(context).textTheme.display2,
          ),
        ],
      );
}
