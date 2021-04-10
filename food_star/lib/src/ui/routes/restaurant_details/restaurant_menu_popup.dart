import 'package:flutter/material.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/ui/shared/no_search_item_restaurants.dart';

class RestaurantMenuPopUpScreen extends StatefulWidget {
  final RestaurantDetailsViewModel model;

  RestaurantMenuPopUpScreen({this.model});

  @override
  _RestaurantMenuPopUpScreenState createState() =>
      _RestaurantMenuPopUpScreenState();
}

class _RestaurantMenuPopUpScreenState extends State<RestaurantMenuPopUpScreen> {
  List<ACateory> lengthOfSearchCategory;

  @override
  void initState() {
    lengthOfSearchCategory = widget.model.searchCategory ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: lengthOfSearchCategory.length != 0
          ? ListView.separated(
              shrinkWrap: true,
              itemCount: lengthOfSearchCategory.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
//                      widget.model.initRestaurantDetailsApi(
//                        //restaurantId: widget.model.restaurantId,
//                        city: "Madurai",
//                        categoryID:
//                            lengthOfSearchCategory[index].mainCat.toString(),
//                      );
                    Navigator.pop(context, index);
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(
                        15.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              lengthOfSearchCategory[index].mainCatName,
                              style: Theme.of(context).textTheme.display3,
                            ),
                          ),
                          Text(
                            '${lengthOfSearchCategory[index].foodCount}',
                            style: Theme.of(context).textTheme.display2,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey[200],
                );
              },
            )
          : Container(
              child: NoSearchItemsAvailableScreen(
                title: 'No Menu Available',
              ),
            ),
//      child: Scaffold(
//        backgroundColor: white,
//        body: lengthOfSearchCategory.length != 0
//            ? ListView.separated(
//                itemCount: lengthOfSearchCategory.length,
//                itemBuilder: (context, index) {
//                  return InkWell(
//                    onTap: () {
////                      widget.model.initRestaurantDetailsApi(
////                        //restaurantId: widget.model.restaurantId,
////                        city: "Madurai",
////                        categoryID:
////                            lengthOfSearchCategory[index].mainCat.toString(),
////                      );
//                      Navigator.pop(context, index);
//                    },
//                    child: Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(
//                          15.0,
//                        ),
//                        child: Row(
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            Flexible(
//                              child: Text(
//                                lengthOfSearchCategory[index].mainCatName,
//                                style: Theme.of(context).textTheme.display3,
//                              ),
//                            ),
//                            Text(
//                              '${lengthOfSearchCategory[index].foodCount}',
//                              style: Theme.of(context).textTheme.display2,
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
//                },
//                separatorBuilder: (BuildContext context, int index) {
//                  return Divider(
//                    color: Colors.grey[200],
//                  );
//                },
//              )
//            : Container(
//                child: NoSearchItemsAvailableScreen(
//                  title: 'No Menu Available',
//                ),
//              ),
//      ),

      //      child: ChangeNotifierProvider.value(
//        value: RestaurantDetailsViewModel(context: context),
//        child: Consumer<RestaurantDetailsViewModel>(
//          builder: (BuildContext context, RestaurantDetailsViewModel model,
//              Widget child) {
//
//          },
//        ),
//      ),
    );
  }
}
