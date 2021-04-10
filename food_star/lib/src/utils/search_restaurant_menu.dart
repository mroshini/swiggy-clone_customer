import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';

class SearchRestaurantMenu extends SearchDelegate<String> {
  List<ACateory> restaurantCategory = [];
  final RestaurantDetailsViewModel model;

  SearchRestaurantMenu({this.model});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          if (query.isNotEmpty) {
            showLog("Search -- ${query}");
            model.initRestaurantDetailsApiRequest(
              dish: query,
              restaurantID: model.restaurantData.id,
            );
            Navigator.of(context).pop();
          }
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {}

  @override
  Widget buildResults(BuildContext context) {
    return Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggesionList;
    if (model.searchCategory != null) {
      suggesionList = model.searchCategory ??
          []
              .where((p) => p.mainCatName.startsWith(query))
              .toList(); //p.startsWith(query)).toList();
    }

    return model.searchCategory != null
        ? ListView.separated(
            itemCount: suggesionList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  model.initRestaurantDetailsApiRequest(
                      categoryID: suggesionList[index].mainCat.toString(),
                      cityValue: model.city,
                      buildContext: context);
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      10.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          suggesionList[index].mainCatName,
                          style: Theme.of(context).textTheme.display3,
                        ),
                        Text(
                          suggesionList[index].foodCount.toString(),
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
        : Container();
  }
}
