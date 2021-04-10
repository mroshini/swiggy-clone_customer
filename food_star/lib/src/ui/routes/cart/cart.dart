import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/models/arguments_model/restaurant_arg_model.dart';
import 'package:foodstar/src/core/models/sample_models/restaurant_item_data.dart';
import 'package:foodstar/src/core/models/sample_models/restaurant_item_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/cart/cart_items_view.dart';
import 'package:foodstar/src/ui/routes/cart/cart_shimmer.dart';
import 'package:foodstar/src/ui/routes/cart/payment_details_bottom_sheet.dart';
import 'package:foodstar/src/ui/routes/cart/save_phone_number_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/colored_sized_box.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/rest_delete_food_items_delete_bottom_sheet.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool showArrow;

  CartScreen({this.showArrow});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin {
  final List<RestaurantItemModel> restaurantItemInfo =
      RestaurantItemData().cartItem;
  var favoriteClicked = false;
  var favoriteIndex = 0;
  TextEditingController deliveryNotesController;
  TextEditingController mobileNumberController;
  final _formKey = GlobalKey<FormState>();
  CartBillDetailViewModel model;

  FocusNode numberFocus;

  @override
  void initState() {
    deliveryNotesController = TextEditingController();
    mobileNumberController = TextEditingController();
    numberFocus = FocusNode();

    model = Provider.of<CartBillDetailViewModel>(context, listen: false);
    model.initRazorPay(context);
    model.callAvailablePromosRequest(context: context);
    model.checkUserLoggedInOrNot(context: context);

    model.givenAddressForDelivery = "";
    super.initState();
  }

  @override
  void dispose() {
    deliveryNotesController.dispose();
    mobileNumberController.dispose();
    numberFocus.dispose();
    model.removeOrderId();
    model.razorPay.clear();
    super.dispose();
  }

  goToSelectAddressScreen(
      {BuildContext context, String latitude, String longitude}) async {
    if (model.accessToken.isNotEmpty) {
      await Navigator.pushNamed(
        // from cart while user change delivery location
        context,
        manageAddress,
        arguments: {
          fromWhichScreen: "2",
          latitudeKey: latitude,
          longitudeKey: longitude,
        },
      ).then((value) => {
            showLog("PopWillResult11 -- ${value}"),
            model.updateAddress(value),
          });
    } else {
      Navigator.pushNamed(context, login);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<CartBillDetailViewModel>(
      builder:
          (BuildContext context, CartBillDetailViewModel model, Widget child) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          // backgroundColor: Colors.grey[200],
          appBar: AppBar(
            automaticallyImplyLeading: widget.showArrow ? true : false,
            // if true meaning items picked from restaurant details or from direct home screen
            elevation: 1.0,
            title: Text(
              "Cart",
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return model.state == BaseViewState.Busy
                  ? showCartShimmer(context)
                  : (model.cartOrderedItems.length != 0)
                      ? Stack(
                          children: [
                            Column(
                              children: <Widget>[
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight:
                                            viewportConstraints.maxHeight,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            height: model.accessToken.isNotEmpty
                                                ? model.deliveryBoxHeight
                                                : 170,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  verticalSizedBox(),
                                                  InkWell(
                                                    onTap: () async {
                                                      if (!model
                                                          .removeOrAddItemLoader) {
                                                        goToSelectAddressScreen(
                                                          context: context,
                                                          longitude: model
                                                              .cartBillData
                                                              .restaurant
                                                              .longitude
                                                              .toString(),
                                                          latitude: model
                                                              .cartBillData
                                                              .restaurant
                                                              .latitude
                                                              .toString(),
                                                        );
                                                      } else {
                                                        showSnackbar(
                                                          message: CommonStrings
                                                              .pleaseWait,
                                                          context: context,
                                                        );
                                                      }
//                                                  if (model
//                                                      .accessToken.isNotEmpty) {
//                                                    await Navigator.pushNamed(
//                                                      // from cart while user change delivery location
//                                                      context,
//                                                      manageAddress,
//                                                      arguments: {
//                                                        fromWhichScreen: "2"
//                                                      },
//                                                    ).then((value) => {
//                                                          showLog(
//                                                              "PopWillResult11 -- ${value}"),
//                                                          model.updateAddress(
//                                                              value),
//                                                        });
//                                                  } else {
//                                                    Navigator.pushNamed(
//                                                        context, login);
//                                                  }

//                                                      await Navigator.pushNamed(
//                                                          context,
//                                                          manageAddress,
//                                                          arguments: {
//                                                            fromWhichScreen:
//                                                                mainHome,
//                                                          }).then((value) => {
//                                                            model.updateAddress(
//                                                                value ?? ""),
//                                                          });
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
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              height: 20,
                                                              width: 20,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .orange),
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .fiber_manual_record,
                                                                  color: Colors
                                                                      .orange,
                                                                  size: 15,
                                                                ),
                                                              ),
                                                            ),
                                                            horizontalSizedBox(),
                                                            Flexible(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    'Deliver At',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .display2
                                                                        .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                  ),
                                                                  verticalSizedBox(),
                                                                  Visibility(
                                                                    visible:
                                                                        model.givenAddressForDelivery ==
                                                                            "",
                                                                    child: Text(
                                                                      'Choose Delivery Location',
//                                                                  '${model.currentAddress}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .display1,
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible:
                                                                        model.givenAddressForDelivery !=
                                                                            "",
                                                                    child: Text(
                                                                      "${model.givenAddressForDelivery}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .display1,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
//                                                          model.accessToken
//                                                                  .isNotEmpty
//                                                              ? Row(
//                                                                  mainAxisAlignment:
//                                                                      MainAxisAlignment
//                                                                          .start,
//                                                                  crossAxisAlignment:
//                                                                      CrossAxisAlignment
//                                                                          .start,
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Container(
//                                                                      height:
//                                                                          20,
//                                                                      width: 20,
//                                                                      decoration:
//                                                                          BoxDecoration(
//                                                                        shape: BoxShape
//                                                                            .circle,
//                                                                        border: Border.all(
//                                                                            color:
//                                                                                Colors.orange),
//                                                                      ),
//                                                                      child:
//                                                                          Center(
//                                                                        child:
//                                                                            Icon(
//                                                                          Icons
//                                                                              .fiber_manual_record,
//                                                                          color:
//                                                                              Colors.orange,
//                                                                          size:
//                                                                              15,
//                                                                        ),
//                                                                      ),
//                                                                    ),
//                                                                    horizontalSizedBox(),
//                                                                    Flexible(
//                                                                      child:
//                                                                          Column(
//                                                                        crossAxisAlignment:
//                                                                            CrossAxisAlignment.start,
//                                                                        mainAxisAlignment:
//                                                                            MainAxisAlignment.start,
//                                                                        children: <
//                                                                            Widget>[
//                                                                          Text(
//                                                                            'Deliver At',
//                                                                            style: Theme.of(context).textTheme.display2.copyWith(
//                                                                                  fontSize: 12,
//                                                                                ),
//                                                                          ),
//                                                                          verticalSizedBox(),
//                                                                          Visibility(
//                                                                            visible:
//                                                                                model.givenAddressForDelivery == "",
//                                                                            child:
//                                                                                Text(
//                                                                              'Choose Delivery Location',
//                                                                              style: Theme.of(context).textTheme.display1,
//                                                                            ),
//                                                                          ),
//                                                                          Visibility(
//                                                                            visible:
//                                                                                model.givenAddressForDelivery != "",
//                                                                            child:
//                                                                                Text(
//                                                                              "${model.givenAddressForDelivery}",
//                                                                              style: Theme.of(context).textTheme.display1,
//                                                                            ),
//                                                                          ),
//                                                                        ],
//                                                                      ),
//                                                                    ),
//                                                                  ],
//                                                                )
//                                                              : Row(
//                                                                  mainAxisAlignment:
//                                                                      MainAxisAlignment
//                                                                          .start,
//                                                                  crossAxisAlignment:
//                                                                      CrossAxisAlignment
//                                                                          .start,
//                                                                  children: <
//                                                                      Widget>[
//                                                                    Container(
//                                                                      height:
//                                                                          20,
//                                                                      width: 20,
//                                                                      decoration:
//                                                                          BoxDecoration(
//                                                                        shape: BoxShape
//                                                                            .circle,
//                                                                        border: Border.all(
//                                                                            color:
//                                                                                Colors.orange),
//                                                                      ),
//                                                                      child:
//                                                                          Center(
//                                                                        child:
//                                                                            Icon(
//                                                                          Icons
//                                                                              .fiber_manual_record,
//                                                                          color:
//                                                                              Colors.orange,
//                                                                          size:
//                                                                              15,
//                                                                        ),
//                                                                      ),
//                                                                    ),
//                                                                    horizontalSizedBox(),
//                                                                    Flexible(
//                                                                      child:
//                                                                          Column(
//                                                                        crossAxisAlignment:
//                                                                            CrossAxisAlignment.start,
//                                                                        mainAxisAlignment:
//                                                                            MainAxisAlignment.start,
//                                                                        children: <
//                                                                            Widget>[
//                                                                          Text(
//                                                                            'Deliver At',
//                                                                            style: Theme.of(context).textTheme.display2.copyWith(
//                                                                                  fontSize: 12,
//                                                                                ),
//                                                                          ),
//                                                                          verticalSizedBox(),
//                                                                          Text(
//                                                                            "${model.currentAddress}",
//                                                                            style:
//                                                                                Theme.of(context).textTheme.display1,
//                                                                          ),
//                                                                        ],
//                                                                      ),
//                                                                    ),
//                                                                  ],
//                                                                ),
                                                            ),
                                                        Icon(Icons.more_vert),
                                                      ],
                                                    ),
                                                  ),
                                                  model.accessToken.isNotEmpty
                                                      ? verticalSizedBoxTwenty()
                                                      : verticalSizedBox(),
//                                              model.changeMobileNumber
//                                                  ? GestureDetector(
//                                                      onTap: () {
//                                                        openFoodItemEditBottomSheet(
//                                                          context,
//                                                          SavePhoneNumberBottomSheet(
//                                                            phoneNumber: model
//                                                                .mobileNumber,
//                                                          ),
//                                                        );
//                                                        model.editMobileNumber(
//                                                            false);
//                                                        model
//                                                            .saveMobileNumberStatus(
//                                                                true);
//                                                        model.updateHeight(150);
//                                                      },
//                                                      child: Visibility(
//                                                        visible: model
//                                                            .accessToken
//                                                            .isNotEmpty,
//                                                        child: Form(
//                                                          key: _formKey,
//                                                          child: TextFormField(
//                                                            controller:
//                                                                mobileNumberController,
//                                                            textInputAction:
//                                                                TextInputAction
//                                                                    .done,
//                                                            keyboardType:
//                                                                TextInputType
//                                                                    .number,
//                                                            autofocus: true,
//                                                            focusNode:
//                                                                numberFocus,
//                                                            validator: (value) {
//                                                              return mobileNumberValidation(
//                                                                  value);
//                                                            },
//                                                            onChanged: (value) {
//                                                              // filterSearchResults(value);
//                                                              model
//                                                                  .isMobileNumberEdited();
//                                                              model
//                                                                  .updateNumber(
//                                                                      value);
//                                                            },
//                                                            onSaved: (value) =>
//                                                                {
//                                                              mobileNumberController
//                                                                  .text = value,
//                                                              model
//                                                                  .updateNumber(
//                                                                      value),
//                                                            },
//                                                            style: TextStyle(
//                                                              fontStyle:
//                                                                  FontStyle
//                                                                      .normal,
//                                                              color:
//                                                                  Colors.black,
//                                                              fontSize: 16,
//                                                            ),
//                                                            decoration:
//                                                                InputDecoration(
//                                                              hintText:
//                                                                  "Phone number",
//                                                              border:
//                                                                  InputBorder
//                                                                      .none,
//                                                              hintStyle: TextStyle(
//                                                                  fontSize: 16,
//                                                                  color: Colors
//                                                                      .grey),
//                                                              suffixIcon:
//                                                                  IconButton(
//                                                                icon: Icon(
//                                                                  Icons.save,
//                                                                  color: Colors
//                                                                      .black,
//                                                                ),
//                                                                onPressed: () {
//                                                                  FocusScope.of(
//                                                                          context)
//                                                                      .requestFocus(
//                                                                          FocusNode());
//
//                                                                  if (_formKey
//                                                                      .currentState
//                                                                      .validate()) {
//                                                                    FocusScope.of(
//                                                                            context)
//                                                                        .requestFocus(
//                                                                            FocusNode());
//                                                                    _formKey
//                                                                        .currentState
//                                                                        .save();
//                                                                    model.editMobileNumber(
//                                                                        false);
//                                                                    model.saveMobileNumberStatus(
//                                                                        true);
//                                                                    model.updateHeight(
//                                                                        190);
//                                                                  }
//                                                                },
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    )
//                                                  :
                                                  GestureDetector(
                                                    onTap: () {
                                                      openFoodItemEditBottomSheet(
                                                        context,
                                                        SavePhoneNumberBottomSheet(
                                                          phoneNumber: model
                                                              .mobileNumber,
                                                        ),
                                                      ).then((value) => {
                                                            if (value != null)
                                                              {
                                                                model.saveDeliveryMobileNumber(
                                                                    number:
                                                                        value,
                                                                    status: 1),
                                                                model.mobileNumber =
                                                                    value,
                                                              }
                                                          });
                                                      // model.editMobileNumber(true);
                                                      //  model.updateHeight(220);
                                                    },
                                                    child: Visibility(
                                                      visible: model.accessToken
                                                          .isNotEmpty,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              darkGreen),
                                                                ),
                                                                child: Center(
                                                                  child: Icon(
                                                                    Icons.call,
                                                                    size: 15,
                                                                    color:
                                                                        darkGreen,
                                                                  ),
                                                                ),
                                                              ),
                                                              horizontalSizedBox(),
                                                              Text(
                                                                '${model.mobileNumber}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .display1,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            'Change',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display1
                                                                .copyWith(
                                                                    color:
                                                                        darkRed),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  verticalSizedBoxTwenty(),
                                                  Visibility(
                                                    visible: !model
                                                        .changeMobileNumber,
                                                    child: Flexible(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Colors.grey[100],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          border: Border.all(
                                                            color: Colors
                                                                .grey[200],
                                                          ),
                                                        ),
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Center(
                                                          child: TextField(
                                                            controller:
                                                                deliveryNotesController,
                                                            onChanged: (value) {
                                                              // filterSearchResults(value);
                                                            },
                                                            style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              hintText:
                                                                  "Add notes to delivery location",
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              hintStyle: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .grey),
                                                              prefixIcon:
                                                                  IconButton(
                                                                icon: Icon(
                                                                  Icons
                                                                      .note_add,
                                                                  color: Colors
                                                                      .black45,
                                                                ),
                                                                onPressed:
                                                                    () {},
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: model.cartBillData
                                                    .restaurant.freeDelivery ==
                                                "1",
                                            child: VerticalColoredSizedBox(),
                                          ),
                                          Visibility(
                                            visible: model.cartBillData
                                                    .restaurant.freeDelivery ==
                                                "1",
                                            child: Container(
                                              height: 70,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        '${model.cartBillData.restaurant.name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display1
                                                            .copyWith(
                                                                fontSize: 14),
                                                      ),
                                                    ),
                                                    horizontalSizedBoxFive(),
                                                    freeDeliveryWidget(context),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          VerticalColoredSizedBox(),
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: <Widget>[
                                                  verticalSizedBox(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        "Order item(s)",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display1,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          if (!widget
                                                              .showArrow) {
                                                            await Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                  restaurantDetails,
                                                                  arguments: RestaurantsArgModel(
                                                                      imageTag:
                                                                          "home",
                                                                      restaurantID: model
                                                                          .cartBillData
                                                                          .restaurant
                                                                          .id,
                                                                      image: model
                                                                          .cartBillData
                                                                          .restaurant
                                                                          .src,
                                                                      city: model
                                                                          .cartBillData
                                                                          .restaurant
                                                                          .city,
                                                                      fromWhere:
                                                                          3,
                                                                      availabilityStatus: model
                                                                          .cartBillData
                                                                          .restaurant
                                                                          .availability
                                                                          .status),
                                                                )
                                                                .then(
                                                                    (value) => {
                                                                          model.checkUserLoggedInOrNot(
                                                                              context: context),
                                                                        });
                                                          } else {
                                                            Navigator.pop(
                                                                context,
                                                                "${model.cartBillData.restaurant.id}");
                                                          }
//                                                          navigateToHome(
//                                                              context: context);
                                                        },
                                                        child: Text(
                                                          S.of(context).addMore,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display3
                                                                  .copyWith(
                                                                    color:
                                                                        appColor,
                                                                  ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  verticalSizedBox(),
                                                  divider(),
                                                  verticalSizedBoxFive(),
                                                  ListView.separated(
                                                    separatorBuilder:
                                                        (context, index) =>
                                                            Divider(
                                                      color: Colors.grey[200],
                                                    ),
                                                    shrinkWrap: true,
                                                    itemCount: model
                                                        .cartOrderedItems
                                                        .length,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          vertical: 8.0,
                                                        ),
//                                                        child:
//                                                            RestSearchCartFoodItemScreen(
//                                                          childIndex: index,
//                                                          fromWhichScreen: 3,
//                                                          shopAvailabilityStatus:
//                                                              model
//                                                                  .cartOrderedItems[
//                                                                      index]
//                                                                  .availability
//                                                                  .status,
//                                                          cartBillDetailViewModel:
//                                                              model,
//                                                        )
//                                                          : model
//                                                              .removeAllCartData(),
                                                        child: CartItemsScreen(
                                                          childIndex: index,
                                                          cartOrderedItems: model
                                                              .cartOrderedItems,
                                                          model: model,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          VerticalColoredSizedBox(),
                                          Visibility(
                                            visible:
                                                model.accessToken.isNotEmpty &&
                                                    model
                                                            .cartBillData
                                                            .restaurant
                                                            .promoStatus !=
                                                        0,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(
                                                        context, applyCoupons)
                                                    .then((value) => {
                                                          if (value != null)
                                                            {
                                                              model
                                                                  .updateCouponValue(
                                                                      value)
                                                            }
                                                        });
                                              },
                                              child: Container(
                                                height: 50,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: <Widget>[
                                                          Image.asset(
                                                            "assets/images/percentage.jpg",
                                                            width: 30,
                                                            height: 30,
                                                            color: Colors.grey,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            model.couponCode
                                                                    .isEmpty
                                                                ? CommonStrings
                                                                    .applyCoupons
                                                                : model
                                                                    .couponCode,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .display1
                                                                .copyWith(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ],
                                                      ),
                                                      horizontalSizedBoxFive(),
                                                      model.couponCode.isEmpty
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: 18,
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                model
                                                                    .initCartBillDetailRequest(
                                                                  removeCoupon:
                                                                      true,
                                                                );
                                                              },
                                                              child: Container(
                                                                height: 20,
                                                                width: 20,
                                                                child: Icon(
                                                                  Icons.close,
                                                                  size: 22,
                                                                ),
                                                              ),
                                                            ),
                                                      //horizontalSizedBoxFive(),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                model.accessToken.isNotEmpty &&
                                                    model
                                                            .cartBillData
                                                            .restaurant
                                                            .promoStatus !=
                                                        0,
                                            child: VerticalColoredSizedBox(),
                                          ),
//                                          cashOrWalletRow(model),
                                          //   VerticalColoredSizedBox(),
                                          paymentDetailsColumn(model),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      verticalSizedBox(),
                                      Consumer<CartQuantityViewModel>(
                                        builder: (BuildContext context,
                                            CartQuantityViewModel value,
                                            Widget child) {
                                          return Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              horizontalSizedBox(),
                                              Visibility(
                                                visible: model.cartBillData
                                                            .savedPrice !=
                                                        null ||
                                                    model.cartBillData
                                                            .savedPrice !=
                                                        0,
                                                child: Text(
                                                  'You Saved ${model.currencySymbol} ${model.cartBillData.savedPrice} on the bill',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display2
                                                      .copyWith(
                                                          fontSize: 14,
                                                          color: blue),
                                                ),
                                              ),
//                                              horizontalSizedBox(),
//                                              value.cartItemChanged
//                                                  ? Padding(
//                                                      padding:
//                                                          const EdgeInsets.all(
//                                                              8.0),
//                                                      child: Center(
//                                                        child: SizedBox(
//                                                          height: 20,
//                                                          width: 20,
//                                                          child:
//                                                              CircularProgressIndicator(
//                                                            backgroundColor:
//                                                                white,
//                                                            strokeWidth: 3,
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    )
//                                                  : SizedBox()
//                                                  : Text(
//                                                '${model.currencySymbol} ${model.cartBillData.grandTotal}',
//                                                //${value.cartQuantityData?.totalPrice != null ? model.addToDeliveryFee(value.cartQuantityData?.totalPrice) : model.cartBillData.grandTotal}',
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display3,
//                                              ),
//                                          Visibility(
//                                            visible:
//                                                model.paymentMethod.isNotEmpty,
//                                            child: GestureDetector(
//                                              onTap: () {
//                                                openCashOrOnlinePaymentBottomSheet();
//                                              },
//                                              child: Container(
//                                                decoration: BoxDecoration(
//                                                  borderRadius:
//                                                      BorderRadius.circular(
//                                                    7.0,
//                                                  ),
//                                                  color: appColor,
//                                                ),
//                                                child: Wrap(
//                                                  children: <Widget>[
//                                                    Center(
//                                                      child: Padding(
//                                                        padding:
//                                                            const EdgeInsets
//                                                                .symmetric(
//                                                          vertical: 5.0,
//                                                          horizontal: 5.0,
//                                                        ),
//                                                        child: Row(
//                                                          children: <Widget>[
////                                                            Icon(
////                                                              Icons.access_time,
////                                                              size: 14,
////                                                            ),
////                                                            SizedBox(
////                                                              width: 5,
////                                                            ),
//                                                            Text(
//                                                              model.paymentMethod ==
//                                                                      CommonStrings
//                                                                          .cash
//                                                                  ? S
//                                                                      .of(
//                                                                          context)
//                                                                      .cash
//                                                                  : CommonStrings
//                                                                      .onlinePayment,
//                                                              style: Theme.of(
//                                                                      context)
//                                                                  .textTheme
//                                                                  .display1
//                                                                  .copyWith(
//                                                                      fontSize:
//                                                                          14)
//                                                                  .copyWith(
//                                                                    color:
//                                                                        white,
//                                                                  ),
//                                                            ),
//                                                          ],
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                              ),
////                                              child: Container(
////                                                height: 30,
////                                                width: 50,
////                                                decoration: BoxDecoration(
////                                                  borderRadius:
////                                                      BorderRadius.circular(
////                                                          20.0),
////                                                  color: appColor,
////                                                ),
////                                                child: Center(
////                                                  child: Text(
////                                                    model.paymentMethod ==
////                                                            CommonStrings.cash
////                                                        ? S.of(context).cash
////                                                        : CommonStrings
////                                                            .onlinePayment,
////                                                    style: Theme.of(context)
////                                                        .textTheme
////                                                        .display2
////                                                        .copyWith(
////                                                          color: white,
////                                                        ),
////                                                  ),
////                                                ),
////                                              ),
//                                            ),
//                                          ),
                                            ],
                                          );
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: model.cartBillData
                                                  .unavailableFoodIds.isNotEmpty
                                              ? Container(
                                                  child: Column(
                                                    children: [
                                                      FlatButton(
                                                        color: appColor,
                                                        child: Text(
                                                          CommonStrings
                                                              .wantToRemoveFoodItems,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .display1
                                                                  .copyWith(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                        ),
                                                        onPressed: () {
                                                          showLog(
                                                              "unavailableFoodIds--${model.cartBillData.unavailableFoodIds}");
                                                          openFoodItemEditBottomSheet(
                                                            context,
                                                            RestDeleteFoodItemsDeleteBottomSheet(
                                                              dynamicMapValue: {
                                                                deviceIDKey: model
                                                                    .deviceId,
                                                                userIdKey: model
                                                                    .userId
                                                                    .toString(),
                                                                foodIdKey: model
                                                                    .cartBillData
                                                                    .unavailableFoodIds
                                                                    .toString(),
                                                                restaurantIdKey: model
                                                                    .cartBillData
                                                                    .restaurant
                                                                    .id
                                                                    .toString(),
                                                                actionKey:
                                                                    deleteItem,
                                                                imageKey: "",
                                                                fromWhichScreen:
                                                                    "3"
                                                              },
                                                              context: context,
                                                            ),
                                                            scrollControlled:
                                                                true,
                                                          ).then((value) => {
//                                                                showLog(
//                                                                    "refreshAfterDeleteUnItemsIF--${value}"),
                                                                if (value !=
                                                                    null)
                                                                  {
                                                                    showLog(
                                                                        "refreshAfterDeleteUnAvailableItemsIF--${value}"),
                                                                    model
                                                                        .refreshAfterDeleteUnAvailableItems(
                                                                      ids: model
                                                                          .cartBillData
                                                                          .unavailableFoodIds,
                                                                    )
                                                                  }
                                                                else
                                                                  {
                                                                    showLog(
                                                                        "refreshAfterDeleteUnAvailableItemsElse--${value}")
                                                                  }
                                                              });
                                                        },
                                                      ),
                                                      Text(
                                                        CommonStrings
                                                            .someOfFoodItemsNotAvailable,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .display2,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : FlatButton(
                                                  color: appColor,
                                                  child: Text(
                                                    model.givenAddressForDelivery
                                                            .isEmpty
                                                        ? CommonStrings
                                                            .chooseAddress
                                                        : 'Pay ${model.currencySymbol} ${model.cartBillData.grandTotal}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .display1
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                  onPressed: () async {
                                                    if (!model
                                                        .removeOrAddItemLoader) {
                                                      if (model.accessToken
                                                          .isNotEmpty) {
                                                        //Navigator.pop(context);
                                                        if (model
                                                                .cartBillData
                                                                .restaurant
                                                                .availability
                                                                .status ==
                                                            1) {
                                                          if (model.cartBillData
                                                                  .itemPrice >=
                                                              model
                                                                  .cartBillData
                                                                  .restaurant
                                                                  .minimumOrder) {
                                                            if (model
                                                                    .givenAddressForDelivery !=
                                                                "") {
//                                                        Navigator.pushNamed(
//                                                            context,
//                                                            addPaymentScreen);
                                                              openCashOrOnlinePaymentScreen();
//                                                        if (model
//                                                                .changeMobileNumber &&
//                                                            !(model
//                                                                .saveMobileNumber)) {
//                                                          showSnackbar(
//                                                              message:
//                                                                  'Please Save Phone number',
//                                                              context: context);
//                                                        }
                                                              //////

//                                                        if (model.paymentMethod
//                                                            .isEmpty) {
//                                                          showSnackbar(
//                                                              message: CommonStrings
//                                                                  .choosePaymentType,
//                                                              context: context);
//                                                        } else {
//                                                          model.updateLoader(
//                                                              true);
//
//                                                          if (model
//                                                                  .paymentMethod ==
//                                                              CommonStrings
//                                                                  .onlinePayment) {
//                                                            try {
//                                                              await model
//                                                                  .proceedOrderRequest({
//                                                                orderNoteKey:
//                                                                    deliveryNotesController
//                                                                        .text,
//                                                                deviceKey:
//                                                                    fetchTargetPlatform(),
//                                                                paymentTypeKey:
//                                                                    razorPayPaymentType,
//                                                                mobileNumKey: model
//                                                                    .mobileNumber,
//                                                                actionKey:
//                                                                    insertOrder
//                                                              }, context).then((value) => {
//                                                                        if (value !=
//                                                                            null)
//                                                                          {
//                                                                            model.checkoutOptions(data: {
//                                                                              orderIDfromRazorPay: value.aOrder.orderid,
//                                                                              mobileNumKey: value.aOrder.mobileNum,
//                                                                              orderIDKey: value.aOrder.id,
//                                                                            }),
//                                                                          },
//                                                                        model.updateLoader(
//                                                                            false),
//                                                                      });
//                                                            } on BadRequestException catch (e) {
//                                                              handleErrorResponse(
//                                                                  model,
//                                                                  context,
//                                                                  e.toString());
//                                                            }
//                                                          } else {
//                                                            try {
//                                                              await model
//                                                                  .proceedOrderRequest({
//                                                                orderNoteKey:
//                                                                    deliveryNotesController
//                                                                        .text,
//                                                                deviceKey:
//                                                                    fetchTargetPlatform(),
//                                                                paymentTypeKey:
//                                                                    cashOnDeliveryPaymentType,
//                                                                mobileNumKey: model
//                                                                    .mobileNumber,
//                                                                actionKey:
//                                                                    insertOrder
//                                                              }, context).then((value) => {
//                                                                        if (value !=
//                                                                            null)
//                                                                          {
//                                                                            showLog("TrackorderSuccess--${value}"),
//                                                                            model.updateCartData(),
//                                                                            Navigator.of(context).pushNamed(successOrder,
//                                                                                arguments: "${value.aOrder.id}")
//                                                                          },
//                                                                        model.updateLoader(
//                                                                            false),
//                                                                      });
//                                                            } on BadRequestException catch (e) {
//                                                              handleErrorResponse(
//                                                                  model,
//                                                                  context,
//                                                                  e.toString());
//                                                            }
//                                                          }
//                                                        }
                                                            } else {
//                                                        showSnackbar(
//                                                            message:
//                                                                'Please choose Delivery Details',
//                                                            context: context);
                                                              goToSelectAddressScreen(
                                                                context:
                                                                    context,
                                                                longitude: model
                                                                    .cartBillData
                                                                    .restaurant
                                                                    .longitude
                                                                    .toString(),
                                                                latitude: model
                                                                    .cartBillData
                                                                    .restaurant
                                                                    .latitude
                                                                    .toString(),
                                                              );
                                                            }
                                                          } else {
                                                            showSnackbar(
                                                                message:
                                                                    '${CommonStrings.minimumOrderAmount} ${model.cartBillData.restaurant.minimumOrder}',
                                                                context:
                                                                    context);
                                                          }
                                                        } else {
                                                          showSnackbar(
                                                              message: CommonStrings
                                                                  .restaurantNotAvailable,
                                                              context: context);
                                                        }
//                                                Navigator.of(context).pushNamed(
//                                                  successOrder,
//                                                );
                                                      } else {
                                                        Navigator.pushNamed(
                                                            context, login);
                                                      }
                                                    } else {
                                                      showSnackbar(
                                                          message: CommonStrings
                                                              .pleaseWait,
                                                          context: context);
                                                    }
                                                  },
                                                ),
                                        ),
                                      ),
//                                      Visibility(
//                                        visible: model
//                                                    .cartBillData.savedPrice !=
//                                                null ||
//                                            model.cartBillData.savedPrice != 0,
//                                        child: Text(
//                                          'You Saved ${model.currencySymbol} ${model.cartBillData.savedPrice} on the bill',
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display2
//                                              .copyWith(
//                                                fontSize: 14,
//                                              ),
//                                        ),
//                                      ),
//                                    Container(
//                                      width: MediaQuery.of(context).size.width,
//                                      height: 30,
//                                      child: Center(
//                                        child: Image.asset(
//                                          'assets/images/foodstar_logo.png',
//                                          height: 100,
//                                          width: 100,
//                                        ),
//                                      ),
//                                    )

//                                      Visibility(
//                                        visible:
//                                            model.cartBillData.savedPrice != 0
//                                                ? true
//                                                : false,
//                                        child: RichText(
//                                          text: TextSpan(
//                                            children: [
//                                              TextSpan(
//                                                text: S.of(context).yayYouSaved,
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display2,
//                                              ),
//                                              TextSpan(
//                                                text: " ",
//                                              ),
//                                              TextSpan(
//                                                text: convertToDouble(
//                                                    " ${model.cartBillData.savedPrice} "),
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display2
//                                                    .copyWith(
//                                                      color: blue,
//                                                    ),
//                                              ),
//                                              TextSpan(
//                                                text: " ",
//                                              ),
//                                              TextSpan(
//                                                text: S.of(context).onThisOrder,
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display2,
//                                              ),
//                                            ],
//                                          ),
//                                        ),
//                                      ),
//                                      verticalSizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: model.removeCouponLoader,
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  color: Colors.transparent,
                                  child: showProgress(context),
                                  height: MediaQuery.of(context).size.height,
                                ),
                              ),
                            ),
//                            Consumer<CartQuantityViewModel>(builder:
//                                (BuildContext context,
//                                    CartQuantityViewModel value, Widget child) {
//                              return Visibility(
//                                visible: model.removeCouponLoader ||
//                                    value.cartItemChanged,
//                                child: Align(
//                                  alignment: Alignment.center,
//                                  child: Container(
//                                    color: Colors.transparent,
//                                    child: showProgress(context),
//                                    height: MediaQuery.of(context).size.height,
//                                  ),
//                                ),
//                              );
//                            }),
                          ],
                        )
                      : Column(
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
                            Text(
                              'No Cart Items Added',
                              style: Theme.of(context).textTheme.subhead,
                            )
                          ],
                        );
            },
          ),
        );
      },
    );
  }

  handleErrorResponse(CartBillDetailViewModel model, BuildContext context,
      String errorMsg) async {
    model.removeData();
    showLog('OrderError--${errorMsg}');
    model.updateLoader(false);
    model.updatePaymentLoader(false);
    if (errorMsg == CommonStrings.foodItemNotAvailable ||
        errorMsg == CommonStrings.restaurantNotAvailable) {
      await model.checkUserLoggedInOrNot(context: context);
      showInfoAlertDialog(
          context: context,
          response: errorMsg,
          onClicked: () {
            Navigator.pop(context);
          });
    } else {
      showInfoAlertDialog(
          context: context,
          response: errorMsg,
          onClicked: () {
            Navigator.pop(context);
          });
    }
  }

//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider.value(
//      value: CartBillDetailViewModel(context: context),
//      child: Consumer<CartBillDetailViewModel>(
//        builder: (BuildContext context, CartBillDetailViewModel model,
//            Widget child) {
//          return Scaffold(
//            resizeToAvoidBottomInset: true,
//            // backgroundColor: Colors.grey[200],
//            appBar: AppBar(
//              automaticallyImplyLeading: widget.showArrow ? true : false,
//              // if true meaning items picked from restaurant details or from direct home screen
//              elevation: 1.0,
//              title: Text(
//                "Cart",
//                style: Theme.of(context).textTheme.subhead,
//              ),
//            ),
//            body: LayoutBuilder(
//              builder:
//                  (BuildContext context, BoxConstraints viewportConstraints) {
//                return model.state == BaseViewState.Busy
//                    ? showCartShimmer(context)
//                    : (model.cartOrderedItems.length != 0)
//                        ? Column(
//                            children: <Widget>[
//                              Expanded(
//                                child: SingleChildScrollView(
//                                  child: ConstrainedBox(
//                                    constraints: BoxConstraints(
//                                      minHeight: viewportConstraints.maxHeight,
//                                    ),
//                                    child: Column(
//                                      mainAxisSize: MainAxisSize.min,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        Container(
//                                          height: model.accessToken.isNotEmpty
//                                              ? model.deliveryBoxHeight
//                                              : 160,
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(
//                                              8.0,
//                                            ),
//                                            child: Column(
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              children: <Widget>[
//                                                verticalSizedBox(),
//                                                GestureDetector(
//                                                  onTap: () async {
//                                                    if (model.accessToken
//                                                        .isNotEmpty) {
//                                                      await Navigator.pushNamed(
//                                                        // from cart while user change delivery location
//                                                        context,
//                                                        manageAddress,
//                                                        arguments: {
//                                                          fromWhichScreen: "2"
//                                                        },
//                                                      ).then((value) => {
//                                                            showLog(
//                                                                "PopWillResult11 -- ${value}"),
//                                                            model.updateAddress(
//                                                                value),
//                                                          });
//                                                    } else {
//                                                      Navigator.pushNamed(
//                                                          context, login);
//                                                    }
////                                                      await Navigator.pushNamed(
////                                                          context,
////                                                          manageAddress,
////                                                          arguments: {
////                                                            fromWhichScreen:
////                                                                mainHome,
////                                                          }).then((value) => {
////                                                            model.updateAddress(
////                                                                value ?? ""),
////                                                          });
//                                                  },
//                                                  child: Row(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .spaceBetween,
//                                                    crossAxisAlignment:
//                                                        CrossAxisAlignment
//                                                            .start,
//                                                    children: <Widget>[
//                                                      Flexible(
//                                                        child:
//                                                            model.accessToken
//                                                                    .isNotEmpty
//                                                                ? Row(
//                                                                    mainAxisAlignment:
//                                                                        MainAxisAlignment
//                                                                            .start,
//                                                                    crossAxisAlignment:
//                                                                        CrossAxisAlignment
//                                                                            .start,
//                                                                    children: <
//                                                                        Widget>[
//                                                                      Container(
//                                                                        height:
//                                                                            20,
//                                                                        width:
//                                                                            20,
//                                                                        decoration:
//                                                                            BoxDecoration(
//                                                                          shape:
//                                                                              BoxShape.circle,
//                                                                          border:
//                                                                              Border.all(color: Colors.orange),
//                                                                        ),
//                                                                        child:
//                                                                            Center(
//                                                                          child:
//                                                                              Icon(
//                                                                            Icons.fiber_manual_record,
//                                                                            color:
//                                                                                Colors.orange,
//                                                                            size:
//                                                                                15,
//                                                                          ),
//                                                                        ),
//                                                                      ),
//                                                                      horizontalSizedBox(),
//                                                                      Flexible(
//                                                                        child:
//                                                                            Column(
//                                                                          crossAxisAlignment:
//                                                                              CrossAxisAlignment.start,
//                                                                          mainAxisAlignment:
//                                                                              MainAxisAlignment.start,
//                                                                          children: <
//                                                                              Widget>[
//                                                                            Text(
//                                                                              'Deliver At',
//                                                                              style: Theme.of(context).textTheme.display2.copyWith(
//                                                                                    fontSize: 12,
//                                                                                  ),
//                                                                            ),
//                                                                            verticalSizedBox(),
//                                                                            Visibility(
//                                                                              visible: model.givenAddressForDelivery == "",
//                                                                              child: Text(
//                                                                                'Choose Delivery Location',
//                                                                                style: Theme.of(context).textTheme.display1,
//                                                                              ),
//                                                                            ),
//                                                                            Visibility(
//                                                                              visible: model.givenAddressForDelivery != "",
//                                                                              child: Text(
//                                                                                "${model.givenAddressForDelivery}",
//                                                                                style: Theme.of(context).textTheme.display1,
//                                                                              ),
//                                                                            ),
//                                                                          ],
//                                                                        ),
//                                                                      ),
//                                                                    ],
//                                                                  )
//                                                                : Row(
//                                                                    mainAxisAlignment:
//                                                                        MainAxisAlignment
//                                                                            .start,
//                                                                    crossAxisAlignment:
//                                                                        CrossAxisAlignment
//                                                                            .start,
//                                                                    children: <
//                                                                        Widget>[
//                                                                      Container(
//                                                                        height:
//                                                                            20,
//                                                                        width:
//                                                                            20,
//                                                                        decoration:
//                                                                            BoxDecoration(
//                                                                          shape:
//                                                                              BoxShape.circle,
//                                                                          border:
//                                                                              Border.all(color: Colors.orange),
//                                                                        ),
//                                                                        child:
//                                                                            Center(
//                                                                          child:
//                                                                              Icon(
//                                                                            Icons.fiber_manual_record,
//                                                                            color:
//                                                                                Colors.orange,
//                                                                            size:
//                                                                                15,
//                                                                          ),
//                                                                        ),
//                                                                      ),
//                                                                      horizontalSizedBox(),
//                                                                      Flexible(
//                                                                        child:
//                                                                            Column(
//                                                                          crossAxisAlignment:
//                                                                              CrossAxisAlignment.start,
//                                                                          mainAxisAlignment:
//                                                                              MainAxisAlignment.start,
//                                                                          children: <
//                                                                              Widget>[
//                                                                            Text(
//                                                                              'Deliver At',
//                                                                              style: Theme.of(context).textTheme.display2.copyWith(
//                                                                                    fontSize: 12,
//                                                                                  ),
//                                                                            ),
//                                                                            verticalSizedBox(),
//                                                                            Text(
//                                                                              "${model.currentAddress}",
//                                                                              style: Theme.of(context).textTheme.display1,
//                                                                            ),
//                                                                          ],
//                                                                        ),
//                                                                      ),
//                                                                    ],
//                                                                  ),
//                                                      ),
//                                                      Icon(Icons.more_vert),
//                                                    ],
//                                                  ),
//                                                ),
//                                                model.accessToken.isNotEmpty
//                                                    ? verticalSizedBoxTwenty()
//                                                    : verticalSizedBox(),
//                                                model.changeMobileNumber
//                                                    ? GestureDetector(
//                                                        onTap: () {
//                                                          model
//                                                              .editMobileNumber(
//                                                                  false);
//                                                          model
//                                                              .saveMobileNumberStatus(
//                                                                  true);
//                                                        },
//                                                        child: Visibility(
//                                                          visible: model
//                                                              .accessToken
//                                                              .isNotEmpty,
//                                                          child: Form(
//                                                            key: _formKey,
//                                                            child:
//                                                                TextFormField(
//                                                              controller:
//                                                                  mobileNumberController,
//                                                              textInputAction:
//                                                                  TextInputAction
//                                                                      .done,
//                                                              keyboardType:
//                                                                  TextInputType
//                                                                      .number,
//                                                              autofocus: true,
//                                                              focusNode:
//                                                                  numberFocus,
//                                                              validator:
//                                                                  (value) {
//                                                                return mobileNumberValidation(
//                                                                    value);
//                                                              },
//                                                              onChanged:
//                                                                  (value) {
//                                                                // filterSearchResults(value);
//                                                                model
//                                                                    .isMobileNumberEdited();
//                                                                model
//                                                                    .updateNumber(
//                                                                        value);
//                                                              },
//                                                              onSaved:
//                                                                  (value) => {
//                                                                mobileNumberController
//                                                                        .text =
//                                                                    value,
//                                                                model
//                                                                    .updateNumber(
//                                                                        value),
//                                                              },
//                                                              style: TextStyle(
//                                                                fontStyle:
//                                                                    FontStyle
//                                                                        .normal,
//                                                                color: Colors
//                                                                    .black,
//                                                                fontSize: 16,
//                                                              ),
//                                                              decoration:
//                                                                  InputDecoration(
//                                                                hintText:
//                                                                    "Phone number",
//                                                                border:
//                                                                    InputBorder
//                                                                        .none,
//                                                                hintStyle: TextStyle(
//                                                                    fontSize:
//                                                                        16,
//                                                                    color: Colors
//                                                                        .grey),
//                                                                suffixIcon:
//                                                                    IconButton(
//                                                                  icon: Icon(
//                                                                    Icons.save,
//                                                                    color: Colors
//                                                                        .black,
//                                                                  ),
//                                                                  onPressed:
//                                                                      () {
//                                                                    FocusScope.of(
//                                                                            context)
//                                                                        .requestFocus(
//                                                                            FocusNode());
//
//                                                                    if (_formKey
//                                                                        .currentState
//                                                                        .validate()) {
//                                                                      FocusScope.of(
//                                                                              context)
//                                                                          .requestFocus(
//                                                                              FocusNode());
//                                                                      _formKey
//                                                                          .currentState
//                                                                          .save();
//                                                                      model.editMobileNumber(
//                                                                          false);
//                                                                      model.saveMobileNumberStatus(
//                                                                          true);
//                                                                      model.updateHeight(
//                                                                          190);
//                                                                    }
//                                                                  },
//                                                                ),
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ),
//                                                      )
//                                                    : GestureDetector(
//                                                        onTap: () {
//                                                          model
//                                                              .editMobileNumber(
//                                                                  true);
//                                                          model.updateHeight(
//                                                              220);
//                                                        },
//                                                        child: Visibility(
//                                                          visible: model
//                                                              .accessToken
//                                                              .isNotEmpty,
//                                                          child: Row(
//                                                            crossAxisAlignment:
//                                                                CrossAxisAlignment
//                                                                    .start,
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment
//                                                                    .spaceBetween,
//                                                            children: <Widget>[
//                                                              Row(
//                                                                children: <
//                                                                    Widget>[
//                                                                  Container(
//                                                                    height: 20,
//                                                                    width: 20,
//                                                                    decoration:
//                                                                        BoxDecoration(
//                                                                      shape: BoxShape
//                                                                          .circle,
//                                                                      border: Border.all(
//                                                                          color:
//                                                                              darkGreen),
//                                                                    ),
//                                                                    child:
//                                                                        Center(
//                                                                      child:
//                                                                          Icon(
//                                                                        Icons
//                                                                            .call,
//                                                                        size:
//                                                                            15,
//                                                                        color:
//                                                                            darkGreen,
//                                                                      ),
//                                                                    ),
//                                                                  ),
//                                                                  horizontalSizedBox(),
//                                                                  Text(
//                                                                    '${model.mobileNumber}',
//                                                                    style: Theme.of(
//                                                                            context)
//                                                                        .textTheme
//                                                                        .display1,
//                                                                  ),
//                                                                ],
//                                                              ),
//                                                              Text(
//                                                                'Change',
//                                                                style: Theme.of(
//                                                                        context)
//                                                                    .textTheme
//                                                                    .display1
//                                                                    .copyWith(
//                                                                        color:
//                                                                            darkRed),
//                                                              ),
//                                                            ],
//                                                          ),
//                                                        ),
//                                                      ),
//                                                verticalSizedBoxTwenty(),
//                                                Flexible(
//                                                  child: Container(
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.grey[100],
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              5.0),
//                                                      border: Border.all(
//                                                        color: Colors.grey[200],
//                                                      ),
//                                                    ),
//                                                    height: 40,
//                                                    width:
//                                                        MediaQuery.of(context)
//                                                            .size
//                                                            .width,
//                                                    child: Center(
//                                                      child: TextField(
//                                                        controller:
//                                                            deliveryNotesController,
//                                                        onChanged: (value) {
//                                                          // filterSearchResults(value);
//                                                        },
//                                                        style: TextStyle(
//                                                          fontStyle:
//                                                              FontStyle.normal,
//                                                          color: Colors.black,
//                                                          fontSize: 16,
//                                                        ),
//                                                        decoration:
//                                                            InputDecoration(
//                                                          hintText:
//                                                              "Add notes to delivery location",
//                                                          border:
//                                                              InputBorder.none,
//                                                          hintStyle: TextStyle(
//                                                              fontSize: 16,
//                                                              color:
//                                                                  Colors.grey),
//                                                          prefixIcon:
//                                                              IconButton(
//                                                            icon: Icon(
//                                                              Icons.note_add,
//                                                              color: Colors
//                                                                  .black45,
//                                                            ),
//                                                            onPressed: () {},
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        VerticalColoredSizedBox(),
//                                        Container(
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(10.0),
//                                            child: Column(
//                                              children: <Widget>[
//                                                verticalSizedBox(),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceBetween,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "Order item(s)",
//                                                      style: Theme.of(context)
//                                                          .textTheme
//                                                          .display1,
//                                                    ),
//                                                    GestureDetector(
//                                                      onTap: () async {
//                                                        await Navigator.of(
//                                                                context)
//                                                            .pushNamed(
//                                                              restaurantDetails,
//                                                              arguments: RestaurantsArgModel(
//                                                                  imageTag:
//                                                                      "home",
//                                                                  restaurantID: model
//                                                                      .cartBillData
//                                                                      .restaurant
//                                                                      .id,
//                                                                  image: model
//                                                                      .cartBillData
//                                                                      .restaurant
//                                                                      .src,
//                                                                  city: "",
//                                                                  fromWhere: 3),
//                                                            )
//                                                            .then(
//                                                                (value) => {});
////                                                          navigateToHome(
////                                                              context: context);
//                                                      },
//                                                      child: Text(
//                                                        S.of(context).addMore,
//                                                        style: Theme.of(context)
//                                                            .textTheme
//                                                            .display3
//                                                            .copyWith(
//                                                              color: appColor,
//                                                            ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                                verticalSizedBox(),
//                                                divider(),
//                                                verticalSizedBoxFive(),
//                                                ListView.separated(
//                                                  separatorBuilder:
//                                                      (context, index) =>
//                                                          Divider(
//                                                    color: Colors.grey[200],
//                                                  ),
//                                                  shrinkWrap: true,
//                                                  itemCount: model
//                                                      .cartOrderedItems.length,
//                                                  physics:
//                                                      NeverScrollableScrollPhysics(),
//                                                  itemBuilder:
//                                                      (context, index) {
//                                                    return Padding(
//                                                      padding: const EdgeInsets
//                                                          .symmetric(
//                                                        vertical: 8.0,
//                                                      ),
////                                                        child:
////                                                            RestSearchCartFoodItemScreen(
////                                                          childIndex: index,
////                                                          fromWhichScreen: 3,
////                                                          shopAvailabilityStatus:
////                                                              model
////                                                                  .cartOrderedItems[
////                                                                      index]
////                                                                  .availability
////                                                                  .status,
////                                                          cartBillDetailViewModel:
////                                                              model,
////                                                        )
////                                                          : model
////                                                              .removeAllCartData(),
//                                                      child: CartItemsScreen(
//                                                          childIndex: index),
//                                                    );
//                                                  },
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        VerticalColoredSizedBox(),
//                                        cashOrWalletRow(model),
//                                        VerticalColoredSizedBox(),
//                                        paymentDetailsColumn(model),
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                child: Column(
//                                  children: <Widget>[
//                                    verticalSizedBox(),
//                                    Consumer<CartQuantityViewModel>(
//                                      builder: (BuildContext context,
//                                          CartQuantityViewModel value,
//                                          Widget child) {
//                                        return Row(
//                                          children: <Widget>[
//                                            horizontalSizedBox(),
//                                            value.cartItemChanged
//                                                ? Padding(
//                                                    padding:
//                                                        const EdgeInsets.all(
//                                                            20.0),
//                                                    child:
//                                                        showProgress(context),
//                                                  )
//                                                : Text(
//                                                    '${model.currencySymbol} ${value.cartQuantityData?.totalPrice != null ? model.addToDeliveryFee(value.cartQuantityData?.totalPrice) : model.addToDeliveryFee(model.cartBillData.grandTotal)}',
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display3),
//                                            horizontalSizedBox(),
//                                            GestureDetector(
//                                              onTap: () {
//                                                openCashOrOnlinePaymentBottomSheet();
//                                              },
//                                              child: Container(
//                                                height: 30,
//                                                width: 50,
//                                                decoration: BoxDecoration(
//                                                  borderRadius:
//                                                      BorderRadius.circular(
//                                                          20.0),
//                                                  color: appColor,
//                                                ),
//                                                child: Center(
//                                                  child: Text(
//                                                    S.of(context).cash,
//                                                    style: Theme.of(context)
//                                                        .textTheme
//                                                        .display2
//                                                        .copyWith(
//                                                          color: white,
//                                                        ),
//                                                  ),
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        );
//                                      },
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(10.0),
//                                      child: Container(
//                                        width:
//                                            MediaQuery.of(context).size.width,
//                                        child: model.isLoading
//                                            ? showProgress(context)
//                                            : FlatButton(
//                                                color: appColor,
//                                                child: Text(
//                                                  S.of(context).order,
//                                                  style: Theme.of(context)
//                                                      .textTheme
//                                                      .display1
//                                                      .copyWith(
//                                                        color: Colors.white,
//                                                      ),
//                                                ),
//                                                onPressed: () {
//                                                  if (model
//                                                      .accessToken.isNotEmpty) {
//                                                    //Navigator.pop(context);
//                                                    if (model
//                                                            .givenAddressForDelivery !=
//                                                        "") {
//                                                      if (model
//                                                              .changeMobileNumber &&
//                                                          !(model
//                                                              .saveMobileNumber)) {
//                                                        showSnackbar(
//                                                            message:
//                                                                'Please Save Phone number',
//                                                            context: context);
//                                                      } else {
//                                                        model
//                                                            .proceedOrderRequest({
//                                                          orderNoteKey:
//                                                              deliveryNotesController
//                                                                  .text,
//                                                          deviceKey:
//                                                              fetchTargetPlatform(),
//                                                          paymentTypeKey:
//                                                              paymentType,
//                                                          mobileNumKey: model
//                                                              .mobileNumber,
//                                                        }).then((value) => {
//                                                                  if (value !=
//                                                                      null)
//                                                                    {
//                                                                      model
//                                                                          .updateCartData(),
//                                                                      Navigator.of(
//                                                                              context)
//                                                                          .pushNamed(
//                                                                        successOrder,
//                                                                      )
//                                                                    }
//                                                                });
//                                                      }
//                                                    } else {
//                                                      showSnackbar(
//                                                          message:
//                                                              'Please choose Delivery Details',
//                                                          context: context);
//                                                    }
////                                                Navigator.of(context).pushNamed(
////                                                  successOrder,
////                                                );
//                                                  } else {
//                                                    Navigator.pushNamed(
//                                                        context, login);
//                                                  }
//                                                },
//                                              ),
//                                      ),
//                                    ),
////                                    Container(
////                                      width: MediaQuery.of(context).size.width,
////                                      height: 30,
////                                      child: Center(
////                                        child: Image.asset(
////                                          'assets/images/foodstar_logo.png',
////                                          height: 100,
////                                          width: 100,
////                                        ),
////                                      ),
////                                    )
//
////                                      Visibility(
////                                        visible:
////                                            model.cartBillData.savedPrice != 0
////                                                ? true
////                                                : false,
////                                        child: RichText(
////                                          text: TextSpan(
////                                            children: [
////                                              TextSpan(
////                                                text: S.of(context).yayYouSaved,
////                                                style: Theme.of(context)
////                                                    .textTheme
////                                                    .display2,
////                                              ),
////                                              TextSpan(
////                                                text: " ",
////                                              ),
////                                              TextSpan(
////                                                text: convertToDouble(
////                                                    " ${model.cartBillData.savedPrice} "),
////                                                style: Theme.of(context)
////                                                    .textTheme
////                                                    .display2
////                                                    .copyWith(
////                                                      color: blue,
////                                                    ),
////                                              ),
////                                              TextSpan(
////                                                text: " ",
////                                              ),
////                                              TextSpan(
////                                                text: S.of(context).onThisOrder,
////                                                style: Theme.of(context)
////                                                    .textTheme
////                                                    .display2,
////                                              ),
////                                            ],
////                                          ),
////                                        ),
////                                      ),
////                                      verticalSizedBox(),
//                                  ],
//                                ),
//                              ),
//                            ],
//                          )
//                        : Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Center(
//                                child: Image.asset(
//                                  "assets/images/empty_cart.png",
//                                  height: 300,
//                                  width: 300,
//                                ),
//                              ),
//                              verticalSizedBox(),
//                              Text(
//                                'No Cart Items Added',
//                                style: Theme.of(context).textTheme.subhead,
//                              )
//                            ],
//                          );
//              },
//            ),
//          );
//        },
//      ),
//    );
//  }

//  @override
//  Widget build(BuildContext context) {
//    return BaseWidget<CartBillDetailViewModel>(
//        model: CartBillDetailViewModel(context: context),
//        onModelReady: (model) => model.initCartBillDetailRequest(),
//        builder: (BuildContext context, CartBillDetailViewModel model,
//            Widget child) {
//          return Scaffold(
//            resizeToAvoidBottomInset: true,
//            // backgroundColor: Colors.grey[200],
//            appBar: AppBar(
//              automaticallyImplyLeading: widget.showArrow ? true : false,
//              elevation: 1.0,
//              title: Text(
//                "Cart",
//                style: Theme.of(context).textTheme.subhead,
//              ),
//            ),
//            body: LayoutBuilder(
//              builder:
//                  (BuildContext context, BoxConstraints viewportConstraints) {
//                return model.state == BaseViewState.Busy
//                    ? showCartShimmer(context)
//                    : (model.cartOrderedItems.length != 0)
//                        ? Column(
//                            children: <Widget>[
//                              Expanded(
//                                child: SingleChildScrollView(
//                                  child: ConstrainedBox(
//                                    constraints: BoxConstraints(
//                                      minHeight: viewportConstraints.maxHeight,
//                                    ),
//                                    child: Column(
//                                      mainAxisSize: MainAxisSize.min,
//                                      mainAxisAlignment:
//                                          MainAxisAlignment.spaceBetween,
//                                      children: <Widget>[
//                                        Visibility(
//                                          visible: model.accessToken != "",
//                                          child: Container(
//                                            height: 165,
//                                            child: Padding(
//                                              padding: const EdgeInsets.all(
//                                                8.0,
//                                              ),
//                                              child: Column(
//                                                crossAxisAlignment:
//                                                    CrossAxisAlignment.start,
//                                                children: <Widget>[
//                                                  verticalSizedBox(),
//                                                  GestureDetector(
//                                                    onTap: () {
//                                                      navigateToUserLocation(
//                                                          context);
//                                                    },
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .spaceBetween,
//                                                      crossAxisAlignment:
//                                                          CrossAxisAlignment
//                                                              .start,
//                                                      children: <Widget>[
//                                                        Container(
//                                                          height: 20,
//                                                          width: 20,
//                                                          decoration:
//                                                              BoxDecoration(
//                                                            shape:
//                                                                BoxShape.circle,
//                                                            border: Border.all(
//                                                                color: Colors
//                                                                    .orange),
//                                                          ),
//                                                          child: Center(
//                                                            child: Icon(
//                                                              Icons
//                                                                  .fiber_manual_record,
//                                                              color:
//                                                                  Colors.orange,
//                                                              size: 10,
//                                                            ),
//                                                          ),
//                                                        ),
//                                                        horizontalSizedBox(),
//                                                        Flexible(
//                                                          child: Column(
//                                                            crossAxisAlignment:
//                                                                CrossAxisAlignment
//                                                                    .start,
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment
//                                                                    .start,
//                                                            children: <Widget>[
//                                                              Text(
//                                                                'Deliver Location',
//                                                                style: Theme.of(
//                                                                        context)
//                                                                    .textTheme
//                                                                    .display2
//                                                                    .copyWith(
//                                                                      fontSize:
//                                                                          12,
//                                                                    ),
//                                                              ),
//                                                              verticalSizedBox(),
//                                                              Text(
//                                                                'Indeonesia International Institute for Life Science',
//                                                                style: Theme.of(
//                                                                        context)
//                                                                    .textTheme
//                                                                    .display1,
//                                                              ),
//                                                            ],
//                                                          ),
//                                                        ),
//                                                        horizontalSizedBox(),
//                                                        Icon(Icons.more_vert),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                  verticalSizedBoxTwenty(),
//                                                  Container(
//                                                    decoration: BoxDecoration(
//                                                      color: Colors.grey[100],
//                                                      borderRadius:
//                                                          BorderRadius.circular(
//                                                              5.0),
//                                                      border: Border.all(
//                                                        color: Colors.grey[200],
//                                                      ),
//                                                    ),
//                                                    height: 40,
//                                                    width:
//                                                        MediaQuery.of(context)
//                                                            .size
//                                                            .width,
//                                                    child: Center(
//                                                      child: TextField(
//                                                        onChanged: (value) {
//                                                          // filterSearchResults(value);
//                                                        },
//                                                        style: TextStyle(
//                                                          fontStyle:
//                                                              FontStyle.normal,
//                                                          color: Colors.black,
//                                                          fontSize: 16,
//                                                        ),
//                                                        decoration:
//                                                            InputDecoration(
//                                                          hintText:
//                                                              "Add notes to delivery location",
//                                                          border:
//                                                              InputBorder.none,
//                                                          hintStyle: TextStyle(
//                                                              fontSize: 16,
//                                                              color:
//                                                                  Colors.grey),
//                                                          prefixIcon:
//                                                              IconButton(
//                                                            icon: Icon(
//                                                              Icons.note_add,
//                                                              color: Colors
//                                                                  .black45,
//                                                            ),
//                                                            onPressed: () {},
//                                                          ),
//                                                        ),
//                                                      ),
//                                                    ),
//                                                  ),
////                                Card(
////                                  child: Row(
////                                    children: <Widget>[
////                                      Padding(
////                                        padding: const EdgeInsets.all(10.0),
////                                        child: Icon(Icons.search,
////                                            size: 21.0, color: Colors.grey),
////                                      ),
////                                      Expanded(
////                                        child: TextField(
////                                          style: TextStyle(
////                                              fontSize: 14.0,
////                                              color: Colors.black),
////                                          decoration: InputDecoration(
////                                            border: InputBorder.none,
////                                            hintText: S
////                                                .of(context)
////                                                .searchForYourLocation,
////                                            hintStyle: TextStyle(
////                                              fontSize: 15.0,
////                                              color: Colors.grey,
////                                            ),
////                                            prefixIcon: IconButton(
////                                              icon: Icon(
////                                                Icons.note_add,
////                                                color: Colors.black45,
////                                              ),
////                                              onPressed: () {},
////                                            ),
////                                          ),
////                                        ),
////                                      ),
////                                    ],
////                                  ),
////                                ),
//                                                ],
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                        VerticalColoredSizedBox(),
//                                        Container(
//                                          child: Padding(
//                                            padding: const EdgeInsets.all(10.0),
//                                            child: Column(
//                                              children: <Widget>[
//                                                verticalSizedBox(),
//                                                Row(
//                                                  mainAxisAlignment:
//                                                      MainAxisAlignment
//                                                          .spaceBetween,
//                                                  crossAxisAlignment:
//                                                      CrossAxisAlignment.start,
//                                                  children: <Widget>[
//                                                    Text(
//                                                      "Order item(s)",
//                                                      style: Theme.of(context)
//                                                          .textTheme
//                                                          .display1,
//                                                    ),
//                                                    GestureDetector(
//                                                      onTap: () {
//                                                        navigateToHome(
//                                                            context: context);
//                                                      },
//                                                      child: Text(
//                                                        S.of(context).addMore,
//                                                        style: Theme.of(context)
//                                                            .textTheme
//                                                            .display3
//                                                            .copyWith(
//                                                              color: appColor,
//                                                            ),
//                                                      ),
//                                                    ),
//                                                  ],
//                                                ),
//                                                verticalSizedBox(),
//                                                divider(),
//                                                verticalSizedBoxFive(),
//                                                ListView.separated(
//                                                  separatorBuilder:
//                                                      (context, index) =>
//                                                          Divider(
//                                                    color: Colors.grey[200],
//                                                  ),
//                                                  shrinkWrap: true,
//                                                  itemCount: model
//                                                      .cartOrderedItems.length,
//                                                  physics:
//                                                      NeverScrollableScrollPhysics(),
//                                                  itemBuilder:
//                                                      (context, index) {
//                                                    return Padding(
//                                                      padding: const EdgeInsets
//                                                          .symmetric(
//                                                        vertical: 8.0,
//                                                      ),
//                                                      child: CartItemsScreen(
//                                                          childIndex: index),
//                                                    );
//                                                  },
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                        VerticalColoredSizedBox(),
//                                        cashOrWalletRow(model),
//                                        VerticalColoredSizedBox(),
//                                        paymentDetailsColumn(model),
//                                      ],
//                                    ),
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                child: Column(
//                                  children: <Widget>[
//                                    verticalSizedBox(),
//                                    Row(
//                                      children: <Widget>[
//                                        horizontalSizedBox(),
//                                        Text(
//                                            convertToDouble(
//                                                '${model.cartBillData.grandTotal}'),
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display3),
//                                        horizontalSizedBox(),
//                                        GestureDetector(
//                                          onTap: () {
//                                            openCashOrOnlinePaymentBottomSheet();
//                                          },
//                                          child: Container(
//                                            height: 30,
//                                            width: 50,
//                                            decoration: BoxDecoration(
//                                              borderRadius:
//                                                  BorderRadius.circular(20.0),
//                                              color: appColor,
//                                            ),
//                                            child: Center(
//                                              child: Text(
//                                                S.of(context).cash,
//                                                style: Theme.of(context)
//                                                    .textTheme
//                                                    .display2
//                                                    .copyWith(
//                                                      color: white,
//                                                    ),
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ],
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(10.0),
//                                      child: Container(
//                                        width:
//                                            MediaQuery.of(context).size.width,
//                                        child: FlatButton(
//                                          color: appColor,
//                                          child: Text(
//                                            S.of(context).order,
//                                            style: Theme.of(context)
//                                                .textTheme
//                                                .display1
//                                                .copyWith(
//                                                  color: Colors.white,
//                                                ),
//                                          ),
//                                          onPressed: () {
//                                            if (model.accessToken.isNotEmpty) {
//                                              //Navigator.pop(context);
//                                              Navigator.of(context).pushNamed(
//                                                successOrder,
//                                              );
//                                            } else {
//                                              Navigator.pushNamed(
//                                                  context, login);
//                                            }
//                                          },
//                                        ),
//                                      ),
//                                    ),
//                                    Visibility(
//                                      visible:
//                                          model.cartBillData.savedPrice != 0
//                                              ? true
//                                              : false,
//                                      child: RichText(
//                                        text: TextSpan(
//                                          children: [
//                                            TextSpan(
//                                              text: S.of(context).yayYouSaved,
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2,
//                                            ),
//                                            TextSpan(
//                                              text: " ",
//                                            ),
//                                            TextSpan(
//                                              text: convertToDouble(
//                                                  " ${model.cartBillData.savedPrice} "),
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2
//                                                  .copyWith(
//                                                    color: blue,
//                                                  ),
//                                            ),
//                                            TextSpan(
//                                              text: " ",
//                                            ),
//                                            TextSpan(
//                                              text: S.of(context).onThisOrder,
//                                              style: Theme.of(context)
//                                                  .textTheme
//                                                  .display2,
//                                            ),
//                                          ],
//                                        ),
//                                      ),
//                                    ),
//                                    verticalSizedBox(),
//                                  ],
//                                ),
//                              ),
//                            ],
//                          )
//                        : Column(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//                              Center(
//                                child: Image.asset(
//                                  "assets/images/empty_cart.png",
//                                  height: 150,
//                                  width: 150,
//                                ),
//                              ),
//                              verticalSizedBox(),
//                              Text(
//                                'No Cart Items Added',
//                                style: Theme.of(context).textTheme.display1,
//                              )
//                            ],
//                          );
//              },
//            ),
//          );
//        });
//  }

  openCashOrOnlinePaymentScreen() {
//    openFoodItemEditBottomSheet(
//      context,
//      SelectPaymentScreen(
//        paymentInfo: {'grandTotal': model.cartBillData.grandTotal.toString()},
//      ),
//      scrollControlled: false,
//    ).then((value) => {
//          model.setPaymentType(),
//        });
    Navigator.pushNamed(
      context,
      addPaymentScreen,
      arguments: {
        grandTotalKey: model.cartBillData.grandTotal.toString(),
        orderNoteKey: deliveryNotesController.text,
      },
    ).then((value) => {
          model.setPaymentType(),
          model.checkUserLoggedInOrNot(context: context),
        });
  }

  String convertToDouble(String value) {
    return double.parse(value).toStringAsFixed(3).toString();
  }

  InkWell cashOrWalletRow(CartBillDetailViewModel model) => InkWell(
        onTap: () {
          openCashOrOnlinePaymentScreen();
        },
        child: Container(
          height: 50,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  model.paymentMethod.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            horizontalSizedBox(),
                            Icon(
                              model.paymentMethod == CommonStrings.cash
                                  ? Icons.attach_money
                                  : Icons.account_balance_wallet,
                              color: appColor,
                              size: 25.0,
                            ),
                            horizontalSizedBox(),
                            Text(
                              '${model.paymentMethod}',
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ],
                        )
                      : Text(
                          CommonStrings.choosePaymentType,
                          style: Theme.of(context).textTheme.display1,
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                    Text(
//                      S.of(context).delivery,
//                      style: Theme.of(context).textTheme.display1,
//                    ),
//                    horizontalSizedBox(),
                      Text(
                        '${model.currencySymbol} ${model.cartBillData.grandTotal}',
                        //'${model.cartBillData.deliveryCharge}',
//                      convertToDouble(
//                          model.cartBillData.deliveryCharge.toString()),
                        style: Theme.of(context).textTheme.display1,
                      ),
                      horizontalSizedBox(),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 17.0,
                      ),
                      horizontalSizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Container paymentDetailsColumn(CartBillDetailViewModel model) => Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              verticalSizedBox(),
              paymentDetailRow(
                textValueOne: S.of(context).paymentDetails,
                styleOne: Theme.of(context).textTheme.display3,
                textValueTwo: S.of(context).moreInfo,
                styleTwo: Theme.of(context).textTheme.display3.copyWith(
                      color: appColor,
                    ),
                onPressedTextTwo: () {
                  showLog(
                      "model.cartBillData--${model.cartBillData.stax1}-${model.cartBillData.itemPrice}-${model.cartBillData.savedPrice}-${model.cartBillData.grandTotal}-${model.cartBillData.itemOfferPrice}-${model.cartBillData.deliveryChargeDiscount}-${model.cartBillData.stax1}-${model.cartBillData.delChargeTaxPrice}");
                  openBottomSheet(
                    context,
                    PaymentDetailScreen(paymentInfo: {
                      estimatedPrice: model.cartBillData.itemPrice != 0
                          ? '${model.currencySymbol} ${model.cartBillData.itemPrice}'
                          : "",
                      savedPrice: model.cartBillData.savedPrice != 0
                          ? '${model.currencySymbol} ${model.cartBillData.savedPrice}'
                          : "",
                      deliveryPrice: model.cartBillData.deliveryCharge != 0
                          ? '${model.currencySymbol} ${model.cartBillData.deliveryCharge}'
                          : "",
                      totalPrice: model.cartBillData.grandTotal != 0
                          ? '${model.currencySymbol} ${model.cartBillData.grandTotal}'
                          : "",
                      offerDiscount: model.cartBillData.itemOfferPrice != 0
                          ? '- ${model.currencySymbol} ${model.cartBillData.itemOfferPrice}'
                          : "",
                      deliveryChargeDiscount: model
                                  .cartBillData.deliveryChargeDiscount !=
                              0
                          ? '${model.currencySymbol} ${model.cartBillData.deliveryChargeDiscount}'
                          : "",
                      tax: model.cartBillData.stax1 != 0
                          ? '${model.currencySymbol} ${model.cartBillData.stax1}'
                          : "",
                      delChargeTaxPrice: model.cartBillData.delChargeTaxPrice !=
                              0
                          ? '${model.currencySymbol} ${model.cartBillData.delChargeTaxPrice}'
                          : "",
                      promoamount: model.cartBillData.promoamount != 0
                          ? '- ${model.currencySymbol} ${model.cartBillData.promoamount}'
                          : "",
                      itemOriginalPrice:
                          //'(${model.currencySymbol} ${model.cartBillData.itemOriginalPrice} - ${model.currencySymbol} ${model.cartBillData.itemOfferPrice} = ${model.currencySymbol} ${model.cartBillData.itemOriginalPrice - model.cartBillData.itemOfferPrice})'
                          model.cartBillData.itemOriginalPrice >
                                  model.cartBillData.itemPrice
                              ? '${model.currencySymbol} ${model.cartBillData.itemOriginalPrice}'
                              : ""
                    }),
                    scrollControlled: true,
                  );
                },
              ),
              verticalSizedBox(),
              divider(),
              verticalSizedBox(),
              Visibility(
                visible: model.cartBillData.itemOriginalPrice >
                    model.cartBillData.itemPrice,
                child: paymentDetailRow(
                  showSubTextOne: true,
                  // subTextValueOne:
                  textValueOne: CommonStrings.originalPrice,
                  styleOne: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                  textValueTwo:
                      '${model.currencySymbol} ${model.cartBillData.itemOriginalPrice}',
                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
              ),
//              Align(
//                alignment: Alignment.centerRight,
//                child: Text(
//                  '(${model.currencySymbol} ${model.cartBillData.itemOriginalPrice} - ${model.currencySymbol} ${model.cartBillData.itemOfferPrice} = ${model.currencySymbol} ${model.cartBillData.itemOriginalPrice - model.cartBillData.itemOfferPrice})',
//                  style: Theme.of(context).textTheme.display2.copyWith(
//                        fontSize: 14,
//                      ),
//                ),
//              ),
              verticalSizedBox(),
//              paymentDetailRow(
//                showSubTextOne: false,
//                textValueOne: CommonStrings.offerDiscount,
//                styleOne: Theme.of(context).textTheme.display2.copyWith(
//                      fontSize: 14,
//                    ),
//                textValueTwo:
//                    '- ${model.currencySymbol} ${model.cartBillData.itemOfferPrice}',
//                styleTwo: Theme.of(context).textTheme.display2.copyWith(
//                      fontSize: 14,
//                    ),
//              ),
              paymentDetailRow(
                showSubTextOne: true,
                // subTextValueOne:
                textValueOne: S.of(context).priceEstimated,
                styleOne: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 14,
                    ),
                textValueTwo:
                    '${model.currencySymbol} ${model.cartBillData.itemPrice}',
                styleTwo: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 14,
                    ),
              ),
              Visibility(
                visible: model.cartBillData.stax1 != 0,
                child: paymentDetailRow(
                  showSubTextOne: false,
                  textValueOne: CommonStrings.tax,
                  styleOne: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                  textValueTwo:
                      '${model.currencySymbol} ${model.cartBillData.stax1}',
                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
              paymentDetailRow(
                showSubTextOne: false,
                textValueOne: CommonStrings.deliveryCharges,
                styleOne: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 14,
                    ),
                textValueTwo:
                    '${model.currencySymbol} ${model.cartBillData.deliveryCharge}',
                styleTwo: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 14,
                    ),
              ),
              Visibility(
                visible: model.cartBillData.delChargeTaxPrice != 0,
                child: paymentDetailRow(
                  showSubTextOne: false,
                  textValueOne: CommonStrings.deliveryChargeTax,
                  styleOne: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                  textValueTwo:
                      '${model.currencySymbol} ${model.cartBillData.delChargeTaxPrice}',
                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
//              Visibility(
//                visible: model.cartBillData.deliveryChargeDiscount != 0,
//                child: paymentDetailRow(
//                  showSubTextOne: false,
//                  textValueOne: CommonStrings.deliveryChargeDiscount,
//                  styleOne: Theme.of(context).textTheme.display2.copyWith(
//                        fontSize: 14,
//                      ),
//                  textValueTwo:
//                      '${model.currencySymbol} ${model.cartBillData.deliveryChargeDiscount}',
//                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
//                        fontSize: 14,
//                      ),
//                ),
//              ),
              Visibility(
                visible: model.cartBillData.promoamount != 0,
                child: paymentDetailRow(
                  showSubTextOne: false,
                  textValueOne: CommonStrings.couponDiscount,
                  styleOne: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                  textValueTwo:
                      '- ${model.currencySymbol} ${model.cartBillData.promoamount}',
                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
//              Visibility(
//                visible: model.cartBillData.savedPrice != null ||
//                    model.cartBillData.savedPrice != 0,
//                child: paymentDetailRow(
//                  textValueOne: 'You Saved',
//                  styleOne: Theme.of(context).textTheme.display2.copyWith(
//                        fontSize: 14,
//                      ),
//                  textValueTwo:
//                      '${model.currencySymbol} ${model.cartBillData.savedPrice}',
//                  styleTwo: Theme.of(context).textTheme.display2.copyWith(
//                        fontSize: 14,
//                      ),
//                ),
//              ),
//              Visibility(
//                visible: model.cartBillData.savedPrice != null ||
//                    model.cartBillData.savedPrice != 0,
//                child: verticalSizedBox(),
//              ),
//              Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Text(
//                    S.of(context).deliveryFee,
//                    style: Theme.of(context).textTheme.display2.copyWith(
//                          fontSize: 14,
//                        ),
//                  ),
//                  Text(
//                    '${model.currencySymbol} ${model.cartBillData.deliveryCharge}',
//                    style: Theme.of(context).textTheme.display2.copyWith(
//                          fontSize: 14,
//                        ),
//                  ),
////                  RichText(
////                    text: TextSpan(
////                      children: [
////                        TextSpan(
////                          text: '( 15.000 - ',
////                          style: Theme.of(context).textTheme.display2.copyWith(
////                                fontSize: 14,
////                              ),
////                        ),
////                        TextSpan(
////                          text: "6.000 ) ",
////                          style: Theme.of(context).textTheme.display2.copyWith(
////                                fontSize: 15,
////                                color: blue,
////                              ),
////                        ),
////                        TextSpan(
////                          text: '9.000',
////                          style: Theme.of(context).textTheme.display2.copyWith(
////                                fontSize: 15,
////                              ),
////                        ),
////                      ],
////                    ),
////                  ),
//                ],
//              ),
//              verticalSizedBox(),
              divider(),
              verticalSizedBox(),
              paymentDetailRow(
                textValueOne: S.of(context).totalPayment,
                styleOne: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                textValueTwo:
                    '${model.currencySymbol} ${model.cartBillData.grandTotal}',
                styleTwo: Theme.of(context).textTheme.display2.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      );

  @override
  bool get wantKeepAlive => true;
}
