import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/saved_address_view_model.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';

class SearchLocationScreen extends StatefulWidget {
  final bool isBottomSheet;
  final Map<String, String> fromWhichScreen;

  const SearchLocationScreen(
      {Key key, this.isBottomSheet = false, this.fromWhichScreen})
      : super(key: key);

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  String selectedLocation = '';
  TextEditingController _searchController;
  SavedAddressViewModel savedAddressViewModel;

  @override
  void initState() {
    _searchController = TextEditingController();
    savedAddressViewModel =
        Provider.of<SavedAddressViewModel>(context, listen: false);

    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0,
        ),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              S.of(context).location,
              style: Theme.of(context).textTheme.subhead,
            ),
            elevation: 1.0,
          ),
          body: SafeArea(
            child: LayoutBuilder(builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Column(children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: viewportConstraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widget.isBottomSheet
                                  ? buildHeaderView()
                                  : SizedBox(),
                              verticalSizedBox(),
                              GestureDetector(
                                onTap: () {
                                  savedAddressViewModel.handleSearchButton(
                                    context,
                                    "6",
                                  );
                                },
                                child: Card(
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.search,
                                          size: 21.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _searchController,
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                          onTap: () {
                                            savedAddressViewModel
                                                .handleSearchButton(
                                              context,
                                              "6",
                                            );
                                          },
                                          onChanged: (value) {
                                            savedAddressViewModel
                                                .handleSearchButton(
                                              context,
                                              "6",
                                            );
                                          },
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: S
                                                .of(context)
                                                .searchForYourLocation,
                                            hintStyle: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 15.0,
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.my_location,
                                            color: Colors.red,
                                            size: 18.0,
                                          ),
                                          horizontalSizedBox(),
                                          Text(
                                            S.of(context).useCurrentLocation,
                                            style: Theme.of(context)
                                                .textTheme
                                                .display2
                                                .copyWith(
                                                  color: Colors.red,
                                                ),
                                          ),
                                        ],
                                      ),
                                      verticalSizedBox(),
                                      SizedBox(
                                        height: 1.0,
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.popAndPushNamed(
                                      context, changeUserAddressScreen,
                                      arguments: {
                                        fromWhichScreen: "6",
                                      });
                                },
                              ),
//                              SavedAndRecentLocationScreen(),
//                Container(
//                  height: 150.0,
//                  child: Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[
//                      Text(
//                        S.of(context).savedAddress,
//                        style: TextStyle(
//                          fontSize: 16.0,
//                          fontWeight: FontWeight.w600,
//                        ),
//                      ),
//                      verticalSizedBox(),
//                      Expanded(
//                        child: ListView.builder(
//                          itemCount: 2,
//                          itemBuilder: (context, index) => Container(
//                            height: 50.0,
//                            margin: const EdgeInsets.symmetric(vertical: 5.0),
//                            child: Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(Icons.home, color: Colors.grey),
//                                SizedBox(
//                                  width: 16.0,
//                                  height: 8.0,
//                                ),
//                                Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.center,
//                                  children: <Widget>[
//                                    Text(
//                                      S.of(context).home,
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display1
//                                          .copyWith(
//                                            fontSize: 15,
//                                          ),
//                                    ),
//                                    verticalSizedBox(),
//                                    Text(
//                                      '12th Ambal Nagar, Keelkattalai, Chennai',
//                                      style: Theme.of(context)
//                                          .textTheme
//                                          .display2
//                                          .copyWith(
//                                            fontSize: 13,
//                                          ),
//                                    ),
//                                  ],
//                                ),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
//                verticalSizedBox(),
//                Expanded(
//                  child: Container(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(S.of(context).recentLocations,
//                            style: Theme.of(context).textTheme.display1),
//                        verticalSizedBox(),
//                        Expanded(
//                          child: ListView.builder(
//                            itemCount: 2,
//                            itemBuilder: (context, index) => Container(
//                              height: 35.0,
//                              margin: const EdgeInsets.symmetric(vertical: 5.0),
//                              child: Row(
//                                crossAxisAlignment: CrossAxisAlignment.center,
//                                children: <Widget>[
//                                  Icon(
//                                    Icons.home,
//                                    color: Colors.grey,
//                                  ),
//                                  SizedBox(
//                                    width: 16.0,
//                                    height: 8.0,
//                                  ),
//                                  Flexible(
//                                    child: Text(
//                                      'Backiyammal Nagar, Keelkattalai, Chennai',
//                                      style:
//                                          Theme.of(context).textTheme.display2,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]);

//                  return Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  widget.isBottomSheet ? buildHeaderView() : SizedBox(),
//                  verticalSizedBox(),
//                  Card(
//                    child: Row(
//                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.all(10.0),
//                          child: Icon(Icons.search,
//                              size: 21.0, color: Colors.grey),
//                        ),
//                        Expanded(
//                          child: TextField(
//                            controller: _searchController,
//                            style: Theme.of(context).textTheme.display2,
//                            decoration: InputDecoration(
//                              border: InputBorder.none,
//                              hintText: S.of(context).searchForYourLocation,
//                              hintStyle: TextStyle(
//                                fontSize: 15.0,
//                                color: Colors.grey,
//                              ),
//                            ),
//                          ),
//                        ),
//                      ],
//                    ),
//                  ),
//                  InkWell(
//                    child: Container(
//                      margin: const EdgeInsets.symmetric(
//                          horizontal: 15.0, vertical: 15.0),
//                      child: Column(
//                        children: <Widget>[
//                          Row(
//                            children: <Widget>[
//                              Icon(
//                                Icons.my_location,
//                                color: Colors.red,
//                                size: 18.0,
//                              ),
//                              horizontalSizedBox(),
//                              Text(
//                                S.of(context).useCurrentLocation,
//                                style: Theme.of(context)
//                                    .textTheme
//                                    .display2
//                                    .copyWith(
//                                      color: Colors.red,
//                                    ),
//                              ),
//                            ],
//                          ),
//                          verticalSizedBox(),
//                          SizedBox(
//                            height: 1.0,
//                          ),
//                        ],
//                      ),
//                    ),
//                    onTap: () {
//                      Navigator.pushNamed(
//                        context,
//                        changeUserAddressScreen,
//                        arguments: widget.fromWhichScreen,
//                      );
//                      //   Navigator.pop(context);
////                    final result = await Navigator.pushNamed(
////                        context, deliveryLocationMapView);
//                      setState(() {
//                        //  selectedLocation = result;
//                      });
//                    },
//                  ),
//                  SavedAndRecentLocationScreen(),
////                Container(
////                  height: 150.0,
////                  child: Column(
////                    crossAxisAlignment: CrossAxisAlignment.start,
////                    children: <Widget>[
////                      Text(
////                        S.of(context).savedAddress,
////                        style: TextStyle(
////                          fontSize: 16.0,
////                          fontWeight: FontWeight.w600,
////                        ),
////                      ),
////                      verticalSizedBox(),
////                      Expanded(
////                        child: ListView.builder(
////                          itemCount: 2,
////                          itemBuilder: (context, index) => Container(
////                            height: 50.0,
////                            margin: const EdgeInsets.symmetric(vertical: 5.0),
////                            child: Row(
////                              crossAxisAlignment: CrossAxisAlignment.center,
////                              children: <Widget>[
////                                Icon(Icons.home, color: Colors.grey),
////                                SizedBox(
////                                  width: 16.0,
////                                  height: 8.0,
////                                ),
////                                Column(
////                                  crossAxisAlignment: CrossAxisAlignment.start,
////                                  mainAxisAlignment: MainAxisAlignment.center,
////                                  children: <Widget>[
////                                    Text(
////                                      S.of(context).home,
////                                      style: Theme.of(context)
////                                          .textTheme
////                                          .display1
////                                          .copyWith(
////                                            fontSize: 15,
////                                          ),
////                                    ),
////                                    verticalSizedBox(),
////                                    Text(
////                                      '12th Ambal Nagar, Keelkattalai, Chennai',
////                                      style: Theme.of(context)
////                                          .textTheme
////                                          .display2
////                                          .copyWith(
////                                            fontSize: 13,
////                                          ),
////                                    ),
////                                  ],
////                                ),
////                              ],
////                            ),
////                          ),
////                        ),
////                      ),
////                    ],
////                  ),
////                ),
////                verticalSizedBox(),
////                Expanded(
////                  child: Container(
////                    child: Column(
////                      crossAxisAlignment: CrossAxisAlignment.start,
////                      children: <Widget>[
////                        Text(S.of(context).recentLocations,
////                            style: Theme.of(context).textTheme.display1),
////                        verticalSizedBox(),
////                        Expanded(
////                          child: ListView.builder(
////                            itemCount: 2,
////                            itemBuilder: (context, index) => Container(
////                              height: 35.0,
////                              margin: const EdgeInsets.symmetric(vertical: 5.0),
////                              child: Row(
////                                crossAxisAlignment: CrossAxisAlignment.center,
////                                children: <Widget>[
////                                  Icon(
////                                    Icons.home,
////                                    color: Colors.grey,
////                                  ),
////                                  SizedBox(
////                                    width: 16.0,
////                                    height: 8.0,
////                                  ),
////                                  Flexible(
////                                    child: Text(
////                                      'Backiyammal Nagar, Keelkattalai, Chennai',
////                                      style:
////                                          Theme.of(context).textTheme.display2,
////                                    ),
////                                  ),
////                                ],
////                              ),
////                            ),
////                          ),
////                        ),
////                      ],
////                    ),
////                  ),
////                ),
//                ],
//              );
            }),
          ),
        ));
  }

  Column buildHeaderView() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dragIcon(),
          Text('Location', style: Theme.of(context).textTheme.subhead),
        ],
      );
}
