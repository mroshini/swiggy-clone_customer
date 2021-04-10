import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/api_models/delivery_address_model.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/saved_address_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/address_list_shimmer.dart';
import 'package:provider/provider.dart';

class ManageAddressScreen extends StatefulWidget {
  final Map<String, String> fromHomeOrCartDetailsScreen;

  ManageAddressScreen({this.fromHomeOrCartDetailsScreen});

  @override
  _ManageAddressScreenState createState() => _ManageAddressScreenState();
}

class _ManageAddressScreenState extends State<ManageAddressScreen> {
  String popMenuSelected;
  CartBillDetailViewModel cartBillDetailViewModel;
  TextEditingController _searchController;
  DeliveryAddressSharedPrefModel valueFromScreen;

  @override
  void initState() {
    cartBillDetailViewModel =
        Provider.of<CartBillDetailViewModel>(context, listen: false);
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 1.0,
        title: Text(
          'My Address',
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: BaseWidget<SavedAddressViewModel>(
        model: SavedAddressViewModel(context: context),
        onModelReady: (model) => model.checkUserLoggedInOrNot(
          context: context,
          argumentsData: widget.fromHomeOrCartDetailsScreen,
        ),
        builder: (BuildContext context, SavedAddressViewModel addressState,
            Widget child) {
          return LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: viewportConstraints.maxHeight,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  verticalSizedBox(),
                                  GestureDetector(
                                      child: Card(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                onChanged: (value) {
//                                                    addressState
//                                                        .getSearchResults(
//                                                            value);

                                                  addressState.handleSearchButton(
                                                      context,
                                                      widget.fromHomeOrCartDetailsScreen[
                                                          fromWhichScreen]);
                                                },
                                                onTap: () {
                                                  addressState.handleSearchButton(
                                                      context,
                                                      widget.fromHomeOrCartDetailsScreen[
                                                          fromWhichScreen]);
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
                                      onTap: () {
                                        addressState.handleSearchButton(
                                            context,
                                            widget.fromHomeOrCartDetailsScreen[
                                                fromWhichScreen]);
                                      }),
                                  verticalSizedBox(),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await Navigator.pushNamed(context,
                                                changeUserAddressScreen,
                                                arguments: {
                                                  fromWhichScreen:
                                                      widget.fromHomeOrCartDetailsScreen[
                                                                  fromWhichScreen] ==
                                                              "3"
                                                          ? "6"
                                                          : "5",
                                                  // addAddress directly opens in address editing popup
                                                }).then((value) => {
                                                  if (value != null)
                                                    {
                                                      addressState
                                                          .updateAddressAfterBackPress(),
                                                      showLog(
                                                          "changeUserAddressScreen-- ${widget.fromHomeOrCartDetailsScreen[fromWhichScreen]}--${value}"),
//                                                  if (widget.fromHomeOrCartDetailsScreen[
//                                                              fromWhichScreen] ==
//                                                          "3" &&
//                                                      value == "null")
//                                                    {
//                                                      Navigator.pushNamed(
//                                                        context,
//                                                        searchLocation,
//                                                      ),
//                                                    }
//                                                  else
//                                                    {
//                                                      Navigator.pop(
//                                                          context, value),
//                                                    },

                                                      Navigator.pop(
                                                          context, value),
                                                    }
                                                  else
                                                    {
                                                      addressState
                                                          .updateAddressAfterBackPress(),
                                                      showLog(
                                                          "changeUserAddressScreen-- ${widget.fromHomeOrCartDetailsScreen[fromWhichScreen]}"),
//                                                  if (widget.fromHomeOrCartDetailsScreen[
//                                                          fromWhichScreen] ==
//                                                      "3")
//                                                    {
//                                                      Navigator.pushNamed(
//                                                        context,
//                                                        searchLocation,
//                                                      ),
//                                                    },
//                                                  model.updateAddress(
//                                                      value ?? "")
                                                    }
                                                  // model.updateAddress(value ?? ""),
                                                });
//                                navigateToUserLocation(context: context, args: {
//                                  fromWhichScreen: "2",
//                                  cartFromWhichScreen:
//                                      widget.fromHomeOrRestDetailsScreen,
//                                }); //2 -- Manage address while user choose delivery location
                                          },
                                          child: Visibility(
                                            visible:
                                                (widget.fromHomeOrCartDetailsScreen[
                                                        fromWhichScreen] ==
                                                    "3"),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.add,
                                                  color: darkRed,
                                                ),
                                                horizontalSizedBox(),
                                                Text(
                                                  'Add Address',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2
                                                      .copyWith(
                                                        color: darkRed,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              widget.fromHomeOrCartDetailsScreen[
                                                      fromWhichScreen] ==
                                                  "3",
                                          child: divider(),
                                        ),
                                        verticalSizedBoxFive(),
                                        Visibility(
                                          visible:
                                              widget.fromHomeOrCartDetailsScreen[
                                                      fromWhichScreen] !=
                                                  "3",
                                          child: InkWell(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                child: Center(
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
                                                            S
                                                                .of(context)
                                                                .useCurrentLocation,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display2
                                                                .copyWith(
                                                                  color: Colors
                                                                      .red,
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
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, //mapScreen,
                                                  changeUserAddressScreen,
                                                  arguments: {
                                                    fromWhichScreen: widget
                                                                    .fromHomeOrCartDetailsScreen[
                                                                fromWhichScreen] ==
                                                            "5"
                                                        ? "2"
                                                        : widget.fromHomeOrCartDetailsScreen[
                                                            fromWhichScreen],
                                                  }).then((value) => {
                                                    showLog(
                                                        "ValueFromConfrim --${value}"),
                                                    if (value != null)
                                                      {
                                                        Navigator.pop(
                                                            context, value),
                                                      }
                                                    else
                                                      {
                                                        addressState
                                                            .updateAddressAfterBackPress()
                                                      }
                                                  });
                                              //   Navigator.pop(context);
//                    final result = await Navigator.pushNamed(
//                        context, deliveryLocationMapView);
                                              setState(() {
                                                //  selectedLocation = result;
                                              });
                                            },
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              widget.fromHomeOrCartDetailsScreen[
                                                      fromWhichScreen] !=
                                                  "3",
                                          child: divider(),
                                        ),
                                        Visibility(
                                          visible: (addressState
                                                  .accessToken.isNotEmpty ||
                                              addressState
                                                      .listOfAddress.length !=
                                                  0),
                                          child: Text('Saved Addresses',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display1),
                                        ),
                                        verticalSizedBox(),
                                        addressState.state == BaseViewState.Busy
                                            ? AddressListShimmer()
                                            : ListView.builder(
                                                itemCount: addressState
                                                    .listOfAddress.length,
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemBuilder:
                                                    (listContext, index) =>
                                                        Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (widget.fromHomeOrCartDetailsScreen[
                                                                fromWhichScreen] ==
                                                            "1") {
                                                          // from foodstar main home
                                                          addressState
                                                              .saveUserCurrentLocationFromFoodStarMenu(
                                                            lat: addressState
                                                                .listOfAddress[
                                                                    index]
                                                                .lat
                                                                .toString(),
                                                            long: addressState
                                                                .listOfAddress[
                                                                    index]
                                                                .lang
                                                                .toString(),
                                                            address: addressState
                                                                .listOfAddress[
                                                                    index]
                                                                .address,
                                                            addressType: addressState
                                                                .listOfAddress[
                                                                    index]
                                                                .addressTypeText,
                                                          );
                                                          Navigator.pop(
                                                              context,
                                                              addressState
                                                                  .listOfAddress[
                                                                      index]
                                                                  .address);
//                                                  navigateToHome(
//                                                      context: context);
                                                        } else if (widget
                                                                    .fromHomeOrCartDetailsScreen[
                                                                fromWhichScreen] ==
                                                            "2") {
                                                          //from cart
                                                          addressState
                                                              .updateLoader(
                                                                  true);
                                                          cartBillDetailViewModel
                                                              .initCartBillDetailRequest(
                                                                  addressData: {
                                                                addressIdKey: addressState
                                                                    .listOfAddress[
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                latKey: addressState
                                                                    .listOfAddress[
                                                                        index]
                                                                    .lat
                                                                    .toString(),
                                                                longitudeKey: addressState
                                                                    .listOfAddress[
                                                                        index]
                                                                    .lang
                                                                    .toString(),
                                                                addressKey: addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .address ??
                                                                    "",
                                                                stateKey: addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .state ??
                                                                    "",
                                                                addressChangeKey:
                                                                    "1",
                                                                buildingKey: addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .building ??
                                                                    "",
                                                                landmarkKey: addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .landmark ??
                                                                    "",
                                                                addressTypeKey: addressState
                                                                            .listOfAddress[
                                                                                index]
                                                                            .addressType !=
                                                                        null
                                                                    ? addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .addressType
                                                                        .toString()
                                                                    : "0",
                                                                cityKey: addressState
                                                                        .listOfAddress[
                                                                            index]
                                                                        .city ??
                                                                    "",
                                                                distanceKey: addressState
                                                                    .listOfAddress[
                                                                        index]
                                                                    .distance
                                                                    .toString()
                                                              },
                                                                  mContext:
                                                                      context).then(
                                                                  (value) => {
                                                                        addressState
                                                                            .updateLoader(false),
                                                                        showLog(
                                                                            "valueeeeee--${value}"),
                                                                        showLog(
                                                                            "ManageAddress--${addressState.listOfAddress[index].distance} -"),
                                                                        if (value !=
                                                                            null)
                                                                          {
                                                                            //  showLog("valueeeeee--${value}"),
                                                                            Navigator.pop(
                                                                              context,
                                                                              DeliveryAddressSharedPrefModel(
                                                                                addressId: addressState.listOfAddress[index].id.toString(),
                                                                                latitude: addressState.listOfAddress[index].lat.toString(),
                                                                                longitude: addressState.listOfAddress[index].lang.toString(),
                                                                                state: addressState.listOfAddress[index].state ?? "",
                                                                                city: addressState.listOfAddress[index].city ?? "",
                                                                                landmark: addressState.listOfAddress[index].landmark ?? "",
                                                                                building: addressState.listOfAddress[index].building ?? "",
                                                                                address: addressState.listOfAddress[index].address ?? "",
                                                                                addressType: addressState.listOfAddress[index].addressType != null ? addressState.listOfAddress[index].addressType.toString() : "0",
                                                                                distance: addressState.listOfAddress[index].distance.toString(),
                                                                                // durationText: value.durationText.toString(),
                                                                              ),
                                                                            )
                                                                          }
                                                                        else
                                                                          {}
                                                                      });
                                                          showLog(
                                                              "ListofAddresses1 -- ${addressState.listOfAddress[index].id}");

//                                                      model.updateAddress(
//                                                          addressState
//                                                              .listOfAddress[
//                                                                  index]
//                                                              .address);
//                                                      Navigator.pop(context,
//                                                          "${addressState.listOfAddress[index].address}");
                                                        } else if (widget
                                                                    .fromHomeOrCartDetailsScreen[
                                                                fromWhichScreen] ==
                                                            "3") {
                                                          // from profile

                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Flexible(
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Icon(
                                                                  addressState.listOfAddress[index].addressType !=
                                                                          null
                                                                      ? (addressState.listOfAddress[index].addressType == 1
                                                                          ? Icons
                                                                              .home
                                                                          : addressState.listOfAddress[index].addressType == 2
                                                                              ? Icons.work
                                                                              : Icons.location_on)
                                                                      : Icons.location_on,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                horizontalSizedBox(),
                                                                Flexible(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        addressState
                                                                            .listOfAddress[index]
                                                                            .addressTypeText,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .display1
                                                                            .copyWith(
                                                                              fontSize: 14.0,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                      ),
                                                                      verticalSizedBoxFive(),
                                                                      Text(
                                                                        addressState
                                                                            .listOfAddress[index]
                                                                            .address,
//                                                                    overflow:
//                                                                        TextOverflow
//                                                                            .ellipsis,
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .display2
                                                                            .copyWith(
                                                                                color: Colors.grey,
                                                                                fontSize: 13),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          // horizontalSizedBox(),
//                                                      InkWell(
//                                                        onTap: () {
//
//                                                        },
//                                                        child: Icon(
//                                                          Icons.more_vert,
//                                                          color: Colors.grey,
//                                                          size: 20,
//                                                        ),
//                                                      ),
                                                          Visibility(
                                                            visible: (widget
                                                                        .fromHomeOrCartDetailsScreen[
                                                                    fromWhichScreen] !=
                                                                "1"),
                                                            child:
                                                                popUpMenuButton(
                                                              model:
                                                                  addressState,
                                                              index: index,
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: addressState.isLoading,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        color: Colors.transparent,
                        child: showProgress(context),
                        height: MediaQuery.of(context).size.height,
                      ),
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }

//  showPopupMenu({SavedAddressViewModel model, int index}) async {
//    await showMenu(
//      context: context,
//      position: RelativeRect.fromLTRB(180, 150, 0, 150),
//      items: [
//        PopupMenuItem<String>(
//            child: GestureDetector(
//              onTap: () {
//                Navigator.pushNamed(context, changeUserAddressScreen,
//                    arguments: {
//                      fromWhichScreen: "4",
//                      addressKey: model.listOfAddress[index].address.toString(),
//                      buildingKey:
//                          model.listOfAddress[index].building.toString(),
//                      landmarkKey:
//                          model.listOfAddress[index].landmark.toString(),
//                      addressIdKey: model.listOfAddress[index].id.toString(),
//                      latKey: model.listOfAddress[index].lat.toString(),
//                      longKey: model.listOfAddress[index].lang.toString(),
//                    });
//              },
//              child: Container(
//                child: Text(
//                  "Edit",
//                  style: Theme.of(context).textTheme.display2,
//                ),
//              ),
//            ),
//            value: '1'),
//        PopupMenuItem<String>(
//            child: GestureDetector(
//              onTap: () {
//                model.editOrDeleteAddress(dynamicMapValue: {
//                  addressIdKey: model.listOfAddress[index].id.toString(),
//                  actionKey: deleteAddress,
////                  addressKey: model.listOfAddress[index].address,
////                  addressTypeKey:
////                      model.listOfAddress[index].addressType.toString(),
////                  buildingKey: model.listOfAddress[index].building.toString(),
////                  landmarkKey: model.listOfAddress[index].landmark.toString(),
////                  latKey: model.listOfAddress[index].lat.toString(),
////                  longKey: model.listOfAddress[index].lang.toString(),
////                  cityKey: model.listOfAddress[index].city.toString(),
////                  stateKey: model.listOfAddress[index].state.toString(),
//                }).then((value) => {
//                      if (value != null)
//                        {
//                         // model.updateAddressList(index),
//                        }
//                    });
//              },
//              child: Text(
//                "Delete",
//                style: Theme.of(context).textTheme.display2,
//              ),
//            ),
//            value: '2'),
//      ],
//      elevation: 8.0,
//    );
//  }

  PopupMenuButton popUpMenuButton({SavedAddressViewModel model, int index}) =>
      PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.grey,
          size: 20,
        ),
        onSelected: (String value) {
          if (value == "1") {
            // edit
            Navigator.pushNamed(context, changeUserAddressScreen, arguments: {
              fromWhichScreen: "4",
              addressKey: model.listOfAddress[index].address,
              buildingKey: model.listOfAddress[index].building.toString(),
              landmarkKey: model.listOfAddress[index].landmark.toString(),
              addressIdKey: model.listOfAddress[index].id.toString(),
              latKey: model.listOfAddress[index].lat.toString(),
              longKey: model.listOfAddress[index].lang.toString(),
            }).then((value) async => {
//                  if (value != null)
//                    {
//                      model.editAddressExistsInDeliveryAddressDataFromPref(
//                          value),
//                    },
                  valueFromScreen = value as DeliveryAddressSharedPrefModel,

                  showLog("popUpMenuButton-"),

                  await model.updateAddressInSpecificIndex(
                      address: AAddress(
                        id: valueFromScreen.addressId,
                        addressType: valueFromScreen.addressType,
                        building: valueFromScreen.building,
                        landmark: valueFromScreen.landmark,
                        lang: double.parse(valueFromScreen.longitude),
                        lat: double.parse(valueFromScreen.latitude),
                        address: valueFromScreen.address,
                        city: valueFromScreen.city,
                        distance: valueFromScreen.distance,
                        state: valueFromScreen.state,
                        addressTypeText: valueFromScreen.addressType == "1"
                            ? "Home"
                            : valueFromScreen.addressType == "2"
                                ? "Work"
                                : "Others",
                      ),
                      index: index),

                  model.updateAddressAfterBackPress(),
                });
          } else {
            // delete
            model.updateLoader(true);
            model.editOrDeleteAddress(dynamicMapValue: {
              addressIdKey: model.listOfAddress[index].id.toString(),
              actionKey: deleteAddress,
              userTypeKey: user,
            }, mContext: context).then((value) => {
                  model.updateLoader(false),
                  if (value != null)
                    {
                      model.updateAddressList(index),
                    }
                });
          }
          setState(() {
            popMenuSelected = value;
          });
        },
//      child: ListTile(
//        leading: IconButton(
//          icon: Icon(Icons.add_alarm),
//          onPressed: () {
//            print('Hello world');
//          },
//        ),
//        title: Text('Title'),
//        subtitle: Column(
//          children: <Widget>[
//            Text('Sub title'),
//            Text(_selection == null ? 'Nothing selected yet' : _selection
//                .toString()),
//          ],
//        ),
//        trailing: Icon(Icons.account_circle),
//      ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              child: Container(
                child: Text(
                  "Edit",
                  style: Theme.of(context).textTheme.display2,
                ),
              ),
              value: '1'),
          PopupMenuItem<String>(
              child: Text(
                "Delete",
                style: Theme.of(context).textTheme.display2,
              ),
              value: '2'),
        ],
      );
}
