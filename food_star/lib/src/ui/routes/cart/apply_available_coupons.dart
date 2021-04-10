import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/delivery_address_model.dart';
import 'package:foodstar/src/core/models/api_models/promo_code_api_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplyAvailableCoupons extends StatefulWidget {
  @override
  _ApplyAvailableCouponsState createState() => _ApplyAvailableCouponsState();
}

class _ApplyAvailableCouponsState extends State<ApplyAvailableCoupons> {
  TextEditingController enterCouponTextController;
  FocusNode enterCouponFocus;

  CartBillDetailViewModel cartBillDetailViewModel;
  SharedPreferences prefs;
  List<APromocode> availablePromoCodes;
  DeliveryAddressSharedPrefModel deliveryData;
  bool isLoading = false;
  bool onEntered = false;

  @override
  void initState() {
    enterCouponTextController = TextEditingController();
    cartBillDetailViewModel =
        Provider.of<CartBillDetailViewModel>(context, listen: false);

    availablePromoCodes = cartBillDetailViewModel.availablePromoCodes;
    super.initState();
  }

  @override
  void dispose() {
    enterCouponTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          CommonStrings.applyCoupons,
          style: Theme.of(context).textTheme.subhead,
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    verticalSizedBoxTwenty(),
                    Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: TextFormField(
                                  controller: enterCouponTextController,
                                  style: Theme.of(context).textTheme.body1,
                                  onFieldSubmitted: (term) {
                                    enterCouponFocus.unfocus();
                                    FocusScope.of(context).requestFocus(null);
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      onEntered = true;
                                    });
                                  },
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    //labelText: 'Floor (Optional)',
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Colors.grey[400],
                                        ),
                                    hintText: 'Enter Coupon Code',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Colors.grey,
                                        ),
                                    counterText: '',
                                  ),
                                  onSaved: (value) =>
                                      enterCouponTextController.text = value,
                                  focusNode: enterCouponFocus,
                                ),
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    if (onEntered) {
                                      applyCoupons(
                                        promoCode:
                                            enterCouponTextController.text,
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      child: Text(
                                        'Apply',
                                        style: Theme.of(context)
                                            .textTheme
                                            .display3
                                            .copyWith(
                                                color: onEntered
                                                    ? appColor
                                                    : Colors.grey,
                                                fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    verticalSizedBoxTwenty(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: viewportConstraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'AVAILABLE COUPONS',
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                              divider(),
                              ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                        color: Colors.grey[200],
                                      ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: availablePromoCodes.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        applyCoupons(
                                            promoCode:
                                                availablePromoCodes[index]
                                                    .promoCode);
                                      },
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(),
                                                    color: appColor
                                                        .withOpacity(0.4),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      availablePromoCodes[index]
                                                          .promoCode,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display1,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0),
                                                  child: Container(
                                                    child: Text(
                                                      'Apply',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .display3
                                                          .copyWith(
                                                              color: appColor,
                                                              fontSize: 15),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            verticalSizedBox(),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/percentage.jpg",
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.grey,
                                                ),
                                                horizontalSizedBox(),
                                                Text(
                                                  availablePromoCodes[index]
                                                      .promoName,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .display1
                                                      .copyWith(fontSize: 17),
                                                ),
                                              ],
                                            ),
                                            divider(),
                                            Text(
                                              availablePromoCodes[index]
                                                  .promoCodeText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isLoading,
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
      ),
    );
  }

  applyCoupons({String promoCode}) async {
    await getDeliveryAddressDataFromPref();
    try {
      handleProgress(true);
      await cartBillDetailViewModel
          .initCartBillDetailRequest(
              addressData: deliveryData == null
                  ? {
                      promoCodeKey: promoCode,
                      addressChangeKey: "0",
                    }
                  : {
                      latKey: deliveryData.latitude.toString(),
                      longKey: deliveryData.longitude.toString(),
                      addressKey: deliveryData.address,
                      stateKey: deliveryData.state,
                      addressChangeKey: "2",
                      buildingKey: deliveryData.building,
                      landmarkKey: deliveryData.landmark,
                      addressTypeKey: deliveryData.addressType,
                      cityKey: deliveryData.city,
                      promoCodeKey: promoCode,
                      distance: deliveryData.distance,
                      durationTextKey: deliveryData.durationText,
                    },
              mContext: context)
          .then((value) => {
                if (value != null)
                  {
                    showLog("getDeliveryAddressDataFromPref--${value}"),
                    if (value == "success")
                      {
                        saveAppliedCoupons(promoCode),
                        Navigator.pop(context, promoCode),
                      }
                    else
                      {showInfoAlertDialog(context: context, response: value)}
                  },
                handleProgress(false)
              });
    } catch (e) {
      handleProgress(false);
    }
  }

  handleProgress(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  saveAppliedCoupons(String promoCode) async {
    await initPref();
    prefs.setString(SharedPreferenceKeys.availablePromoCoupons, promoCode);
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  getDeliveryAddressDataFromPref() async {
    await initPref();
    if (prefs.containsKey(SharedPreferenceKeys.deliveryDataSharedPrefKey)) {
      deliveryData = DeliveryAddressSharedPrefModel.fromJson(
        await json.decode(
            prefs.getString(SharedPreferenceKeys.deliveryDataSharedPrefKey) ??
                ""),
      );
    }
  }
}
