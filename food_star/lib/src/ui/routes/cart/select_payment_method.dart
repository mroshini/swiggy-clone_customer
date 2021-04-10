import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/service/app_exception.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/common_navigation.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPaymentScreen extends StatefulWidget {
  final Map<String, String> paymentInfo;

  SelectPaymentScreen({this.paymentInfo});

  @override
  _SelectPaymentScreenState createState() => _SelectPaymentScreenState();
}

class _SelectPaymentScreenState extends State<SelectPaymentScreen> {
  TextEditingController addNoteController = TextEditingController();
  FocusNode addNoteTextFocus = new FocusNode();
  SharedPreferences prefs;
  bool paymentSelected = false;
  int paymentMethod;
  int selectedIndex;
  CartBillDetailViewModel cartBillDetailViewModel;
  String currencySymbol = "";

  List<String> paymentTypeMethods = ['Online Payment', ' Cash'];

  List<IconData> paymentIcons = [
    Icons.account_balance_wallet,
    Icons.attach_money
  ];

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    paymentMethod = null;
    getCurrencySymbol();
    // cartBillDetailViewModel = Provider.of<CartBillDetailViewModel>(context);
  }

  getCurrencySymbol() async {
    await initPref();
    setState(() {
      currencySymbol =
          prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";
    });
  }

  savePaymentType(int paymentType) async {
    //0--online , 1--cash

    await initPref();
    await prefs.setInt(SharedPreferenceKeys.paymentType, paymentType);

//    if (widget.paymentInfo[orderIDKey] != null &&
//        widget.paymentInfo[typeK╛ey] == pendingPay) {
//      await prefs.setInt(
//        SharedPreferenceKeys.orderIDSharedPrefKey,
//        int.parse(
//          widget.paymentInfo[orderIDKey],
//        ),
//      );
//    }

    paymentMethod = prefs.getInt(SharedPreferenceKeys.paymentType) ?? null;
    showLog("savePaymentType --${paymentMethod}");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartBillDetailViewModel>(builder:
        (BuildContext context, CartBillDetailViewModel model, Widget child) {
      return Scaffold(
        appBar: AppBar(
//        title: Text('To Pay:${widget.paymentInfo['grandTotal']}',style: ,),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'To pay',
                style: Theme.of(context).textTheme.display3.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Colors.green),
              ),
              horizontalSizedBox(),
              Text(
                "${currencySymbol} ${widget.paymentInfo[grandTotalKey]}",
                style: Theme.of(context).textTheme.display3.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              horizontalSizedBox(),
            ],
          ),
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //            closeIconButton(
//                context: context,
//                onClicked: () {
//                  Navigator.pop(context);
//                }),

//              Padding(
//                padding: const EdgeInsets.all(10.0),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      'Topay',
//                      style: Theme.of(context).textTheme.display3.copyWith(
//                            fontWeight: FontWeight.w600,
//                            fontSize: 16.0,
//                          ),
//                    ),
//                    horizontalSizedBox(),
//                    Text(
//                      "${widget.paymentInfo['grandTotal']}",
//                      style: Theme.of(context).textTheme.display3.copyWith(
//                          fontSize: 16.0, fontWeight: FontWeight.w600),
//                    ),
//                    horizontalSizedBox(),
//                  ],
//                ),
//              ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 10.0),
//              child: Text(
//                'Topay',
//                style: Theme.of(context).textTheme.subhead,
//              ),
//            ),
                    verticalSizedBox(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        S.of(context).selectPaymentMethod,
                        style: Theme.of(context).textTheme.subhead,
                      ),
                    ),
                    verticalSizedBoxTwenty(),
                    ListView.separated(
                        shrinkWrap: true,
                        itemCount: paymentTypeMethods.length,
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.grey,
                            ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                savePaymentType(index);
                                selectedIndex = index;
                              });

                              showLog("selectIndex--${index}");
                              //  Navigator.pop(context);
                            },
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            horizontalSizedBox(),
                                            Container(
                                              height: 30,
                                              width: 30,
                                              child: CircleAvatar(
                                                backgroundColor: appColor,
                                                child: Icon(
                                                  paymentIcons[index],
                                                  color: white,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ),
                                            horizontalSizedBox(),
                                            Text(
                                              paymentTypeMethods[index],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display3
                                                  .copyWith(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            )
                                          ],
                                        ),
                                        Visibility(
                                          visible: selectedIndex != null &&
                                              selectedIndex == index,
                                          child: OutlineButton(
                                            splashColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            highlightElevation: 0,
                                            borderSide:
                                                BorderSide(color: appColor),
                                            child: Text(
                                              model.paymentLoader
                                                  ? 'Processing'
                                                  : 'Pay',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .display3
                                                  .copyWith(
                                                    color: appColor,
                                                    fontSize: 15.0,
                                                  ),
                                            ),
                                            onPressed: () async {
                                              if (paymentMethod == 0) {
                                                // online payment
                                                try {
                                                  await model
                                                      .proceedOrderRequest({
                                                    orderIDKey: (widget.paymentInfo[
                                                                    typeKey] ==
                                                                pendingPay &&
                                                            widget.paymentInfo[
                                                                    typeKey] !=
                                                                null)
                                                        ? widget.paymentInfo[
                                                            orderIDKey]
                                                        : "",
                                                    orderNoteKey:
                                                        '${widget.paymentInfo[orderNoteKey]}',
                                                    deviceKey:
                                                        fetchTargetPlatform(),
                                                    paymentTypeKey:
                                                        razorPayPaymentType,
                                                    mobileNumKey:
                                                        model.mobileNumber,
                                                    userTypeKey: user,
                                                    actionKey: (widget.paymentInfo[
                                                                    typeKey] ==
                                                                pendingPay &&
                                                            widget.paymentInfo[
                                                                    typeKey] !=
                                                                null)
                                                        ? paymodeUpdate
                                                        : insertOrder
                                                  }, context).then((value) => {
                                                            if (value != null)
                                                              {
                                                                model
                                                                    .checkoutOptions(
                                                                  data: {
                                                                    orderIDfromRazorPay: value
                                                                        .aOrder
                                                                        .orderid,
                                                                    mobileNumKey: value
                                                                        .aOrder
                                                                        .mobileNum,
                                                                    orderIDKey:
                                                                        value
                                                                            .aOrder
                                                                            .id,
                                                                    grandTotalKey:
                                                                        widget.paymentInfo[
                                                                            grandTotalKey]
                                                                  },
                                                                  mContext:
                                                                      context,
                                                                ),
                                                              },
                                                            model
                                                                .updatePaymentLoader(
                                                                    false),
                                                          });
                                                } on BadRequestException catch (e) {
                                                  if (e.toString() ==
                                                      CommonStrings
                                                          .foodItemNotAvailable) {
                                                    showSnackbar(
                                                        context: context,
                                                        message: e.toString());
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    handleErrorResponse(
                                                      model,
                                                      context,
                                                      e.toString(),
                                                    );
                                                  }
                                                }
                                              } else {
                                                try {
                                                  await model
                                                      .proceedOrderRequest(
                                                    {
                                                      orderIDKey: (widget.paymentInfo[
                                                                      typeKey] ==
                                                                  pendingPay &&
                                                              widget.paymentInfo[
                                                                      typeKey] !=
                                                                  null)
                                                          ? widget.paymentInfo[
                                                              orderIDKey]
                                                          : "",
                                                      orderNoteKey:
                                                          '${widget.paymentInfo[orderNoteKey]}',
                                                      deviceKey:
                                                          fetchTargetPlatform(),
                                                      paymentTypeKey:
                                                          cashOnDeliveryPaymentType,
                                                      mobileNumKey:
                                                          model.mobileNumber,
                                                      userTypeKey: user,
                                                      actionKey: (widget.paymentInfo[
                                                                      typeKey] ==
                                                                  pendingPay &&
                                                              widget.paymentInfo[
                                                                      typeKey] !=
                                                                  null)
                                                          ? paymodeUpdate
                                                          : insertOrder
                                                    },
                                                    context,
                                                  ).then((value) => {
                                                            if (value != null)
                                                              {
                                                                showLog(
                                                                    "TrackorderSuccess--${value}"),
                                                                model
                                                                    .updateCartData(),
                                                                model
                                                                    .removeData(),
                                                                Navigator.of(
                                                                        context)
                                                                    .popAndPushNamed(
                                                                        successOrder,
                                                                        arguments:
                                                                            "${value.aOrder.id}")
                                                              },
                                                            model
                                                                .updatePaymentLoader(
                                                                    false),
                                                          });
                                                } on BadRequestException catch (e) {
                                                  if (e.toString() ==
                                                      CommonStrings
                                                          .foodItemNotAvailable) {
                                                    showSnackbar(
                                                        context: context,
                                                        message: e.toString());
                                                    Navigator.of(context).pop();
                                                  } else {
                                                    handleErrorResponse(
                                                      model,
                                                      context,
                                                      e.toString(),
                                                    );
                                                  }
                                                }
                                              }
                                            },
                                          ),
                                        ),
//                          Visibility(
//                            visible: paymentSelected,
//                            child: Container(
//                              height: 30,
//                              width: 30,
//                              decoration: BoxDecoration(
//                                shape: BoxShape.circle,
//                                border: Border.all(color: Colors.green),
//                              ),
//                              child: Center(
//                                child: Icon(
//                                  Icons.check,
//                                  size: 15,
//                                ),
//                              ),
//                            ),
//                          ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Text(
//                      S.of(context).delivery,
//                      style: Theme.of(context).textTheme.display3.copyWith(
//                            fontWeight: FontWeight.w600,
//                            fontSize: 16.0,
//                          ),
//                    ),
//                    horizontalSizedBox(),
//                    Text(
//                      "6,000",
//                      style: Theme.of(context).textTheme.display3.copyWith(
//                          fontSize: 16.0, fontWeight: FontWeight.w600),
//                    ),
//                    horizontalSizedBox(),
//                  ],
//                ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    verticalSizedBoxTwenty(),
                    Visibility(
                      visible: widget.paymentInfo[typeKey] != null
                          ? widget.paymentInfo[typeKey] == pendingPay
                              ? true
                              : false
                          : false,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '(Or)',
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                    ),
                    verticalSizedBoxTwenty(),
//                    Container(
//                      width: MediaQuery.of(context).size.width,
//                      child: OutlineButton(
//                        splashColor: Colors.grey,
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(8.0)),
//                        highlightElevation: 0,
//                        borderSide: BorderSide(color: darkGreen),
//                        child: Text(
//                          S.of(context).needHelp,
//                          style: Theme.of(context).textTheme.display3.copyWith(
//                                color: darkGreen,
//                                fontSize: 16.0,
//                              ),
//                        ),
//                        onPressed: () {},
//                      ),
//                    ),
                    Visibility(
                      visible: widget.paymentInfo[typeKey] != null
                          ? widget.paymentInfo[typeKey] == pendingPay
                              ? true
                              : false
                          : false,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: OutlineButton(
                          splashColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          highlightElevation: 0,
                          borderSide: BorderSide(color: darkRed),
                          child: Text(
                            S.of(context).cancelOrder,
                            style:
                                Theme.of(context).textTheme.display3.copyWith(
                                      color: darkRed,
                                      fontSize: 16.0,
                                    ),
                          ),
                          onPressed: () {
                            model.cancelOrder(
                                buildContext: context,
                                dynamicMapValue: {
                                  orderIDKey: widget.paymentInfo[orderIDKey],
                                  userTypeKey: user,
                                  statusKey: "5"
                                }).then((value) => {
                                  if (value != null)
                                    {
                                      showInfoAlertDialog(
                                              context: context,
                                              response:
                                                  'Order cancelled successfully')
                                          .then((value) => {
                                                if (value)
                                                  {
                                                    Navigator.pop(context),
                                                  }
                                              })
                                    }
                                });
                          },
                        ),
                      ),
                    ),
                    verticalSizedBox(),
//                    Center(
//                      child: Text(
//                        S.of(context).cancelOrder,
//                        style: Theme.of(context).textTheme.display3.copyWith(
//                              color: darkRed,
//                              fontSize: 16.0,
//                              fontWeight: FontWeight.w800,
//                            ),
//                      ),
//                    ),
//

//            Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                horizontalSizedBox(),
//                Row(
//                  children: <Widget>[
//                    Container(
//                      height: 30,
//                      width: 30,
//                      child: CircleAvatar(
//                        backgroundColor: Colors.blue,
//                        child: Icon(
//                          Icons.account_balance_wallet,
//                          color: white,
//                          size: 20.0,
//                        ),
//                      ),
//                    ),
//                    horizontalSizedBox(),
//                    Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          "Online Payment",
//                          style: Theme.of(context).textTheme.display3.copyWith(
//                              fontSize: 15.0, fontWeight: FontWeight.w600),
////                          style: TextStyle(
////                              fontSize: 16.0,
////                              color: Colors.black,
////                              fontWeight: FontWeight.bold),
//                        ),
////                        verticalSizedBox(),
////                        RichText(
////                          text: TextSpan(
////                            children: [
////                              TextSpan(
////                                text: S.of(context).yourBalance,
////                                style: Theme.of(context).textTheme.display2,
////                              ),
////                              TextSpan(
////                                text: "  0 ",
////                                style: Theme.of(context)
////                                    .textTheme
////                                    .display3
////                                    .copyWith(
////                                      color: darkRed,
////                                      fontWeight: FontWeight.w600,
////                                    ),
////                              ),
////                            ],
////                          ),
////                        ),
//                      ],
//                    ),
//                  ],
//                ),
//                Spacer(),
//                GestureDetector(
//                  onTap: () {
//                    savePaymentType(1);
//                  },
//                  child: Container(
//                    height: 30,
//                    width: 30,
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      border: Border.all(color: Colors.grey),
//                    ),
//                    child: Center(
//                      child: Icon(
//                        Icons.check,
//                        size: 15,
//                      ),
//                    ),
//                  ),
//                ),
//
////                OutlineButton(
////                  splashColor: Colors.grey,
////                  shape: RoundedRectangleBorder(
////                    borderRadius: BorderRadius.circular(10.0),
////                  ),
////                  highlightElevation: 0,
////                  borderSide: BorderSide(color: appColor),
////                  child: Text(
////                    'Pay now',
////                    style: Theme.of(context).textTheme.display3.copyWith(
////                          color: appColor,
////                          fontSize: 13.0,
////                        ),
////                  ),
////                  onPressed: () {},
////                ),
//              ],
//            ),
//            verticalSizedBox(),
//            divider(),
//            verticalSizedBoxTwenty(),
//            Row(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    horizontalSizedBox(),
//                    Icon(
//                      Icons.note_add,
//                      color: appColor,
//                      size: 25.0,
//                    ),
//                    horizontalSizedBox(),
//                    Text(
//                      S.of(context).cash,
//                      style: Theme.of(context).textTheme.display3.copyWith(
//                            fontSize: 16.0,
//                            fontWeight: FontWeight.w600,
//                          ),
//                    )
//                  ],
//                ),
//                GestureDetector(
//                  onTap: () {
//                    savePaymentType(0);
//                  },
//                  child: Container(
//                    height: 30,
//                    width: 30,
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      border: Border.all(color: Colors.grey),
//                    ),
//                    child: Center(
//                      child: Icon(
//                        Icons.check,
//                        size: 15,
//                      ),
//                    ),
//                  ),
//                ),
////                Row(
////                  mainAxisAlignment: MainAxisAlignment.end,
////                  crossAxisAlignment: CrossAxisAlignment.start,
////                  children: <Widget>[
////                    Text(
////                      S.of(context).delivery,
////                      style: Theme.of(context).textTheme.display3.copyWith(
////                            fontWeight: FontWeight.w600,
////                            fontSize: 16.0,
////                          ),
////                    ),
////                    horizontalSizedBox(),
////                    Text(
////                      "6,000",
////                      style: Theme.of(context).textTheme.display3.copyWith(
////                          fontSize: 16.0, fontWeight: FontWeight.w600),
////                    ),
////                    horizontalSizedBox(),
////                  ],
////                ),
//              ],
//            ),
//            verticalSizedBoxTwenty(),
                  ],
                ),
                Visibility(
                  visible: model.paymentLoader || model.cancelOrderLoader,
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
            ),
          ),
        ),
      );
    });
  }

  handleErrorResponse(CartBillDetailViewModel model, BuildContext context,
      String errorMsg) async {
    model.removeData();
    showLog('OrderError--${errorMsg}');
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
          }).then((value) => {
            if (value)
              {
                Navigator.pop(context),
              }
          });
    }
  }
}
