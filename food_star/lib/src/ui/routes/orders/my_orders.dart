import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_widget.dart';
import 'package:foodstar/src/core/provider_viewmodels/my_orders_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/colored_sized_box.dart';
import 'package:foodstar/src/ui/shared/my_orders_shimmer.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/banner_slider_shimmer.dart';

class MyOrdersScreen extends StatefulWidget {
  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _showShimmerView = false;

  @override
  void initState() {
    super.initState();
    // create a future delayed function that will change showInagewidget to true after 5 seconds

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showShimmerView = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text(
          S.of(context).myOrders,
          style: Theme.of(context).textTheme.subhead,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: BaseWidget<MyOrdersViewModel>(
          model: MyOrdersViewModel(context: context),
          onModelReady: (model) => model.initApiMyOrdersApiCall(context),
          builder: (BuildContext context, MyOrdersViewModel myOrdersModel,
              Widget child) {
            return myOrdersModel.state == BaseViewState.Busy
                ? MyOrdersShimmer()
                : (myOrdersModel.aOrder.length == 0)
                    ? Column(
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
                            'No Orders available',
                            style: Theme.of(context).textTheme.subhead,
                          )
                        ],
                      )
                    : ListView.builder(
                        itemCount: myOrdersModel.aOrder.length,
                        itemBuilder: (context, index) {
                          return myOrdersList(index, myOrdersModel);
                        },
                      );
          }),
    );
  }

  Padding myOrdersList(int index, MyOrdersViewModel model) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Material(
          color: transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(trackOrderRoute, arguments: {
                orderIDKey: model.aOrder[index].id.toString()
              } // show order success details below map
                  ).then((value) => {
                    model.initApiMyOrdersApiCall(context),
                  });
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  verticalSizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: model.aOrder[index].restaurantInfo.src == " "
                              ? Image.asset(
                                  'assets/images/no_image.png',
                                  height: 80.0,
                                  width: 80.0,
                                )
                              : model.aOrder[index].restaurantInfo.availability
                                          .status ==
                                      1
                                  ? networkImage(
                                      image: model
                                          .aOrder[index].restaurantInfo.src,
                                      loaderImage: loaderBeforeImage(),
                                      height: 80.0,
                                      width: 80.0,
                                    )
                                  : networkClosedRestImage(
                                      image: model
                                          .aOrder[index].restaurantInfo.src,
                                      loaderImage: loaderBeforeImage(),
                                      height: 80.0,
                                      width: 80.0,
                                    ),
                        ),
                        horizontalSizedBox(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: 13,
                                    width: 13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        2.0,
                                      ),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.fiber_manual_record,
                                        color: Colors.green,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                  horizontalSizedBoxFive(),
                                  Expanded(
                                    child: Text(
                                        model.aOrder[index].restaurantInfo.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .display1),
                                  ),
                                ],
                              ),
                              verticalSizedBox(),
                              Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${model.aOrder[index].createdDateTime}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                        ),
                                        TextSpan(
                                          text: " - ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .display2,
                                        ),
//                                        TextSpan(
//                                          text:
//                                              "${model.aOrder[index].statusText}",
//                                          style: Theme.of(context)
//                                              .textTheme
//                                              .display2
//                                              .copyWith(
//                                                fontSize: 14.0,
//                                                color: darkRed,
//                                                fontWeight: FontWeight.w600,
//                                              ),
//                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "${model.aOrder[index].statusText}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .display2
                                            .copyWith(
                                              fontSize: 14.0,
                                              color:
                                                  model.aOrder[index].status ==
                                                              '0' ||
                                                          model.aOrder[index]
                                                                  .status ==
                                                              '5'
                                                      ? darkRed
                                                      : darkGreen,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSizedBox(),
                              Text(
                                "${model.aOrder[index].orderDetails}",
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              verticalSizedBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  divider(),
                  verticalSizedBox(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                "${model.aOrder[index].foodAvailableCount.totalCount} items | ${model.aOrder[index].grandTotal}",
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(fontSize: 14)),
                            verticalSizedBox(),
                            Visibility(
                              visible: model.aOrder[index].foodAvailableCount
                                          .unavailableCount >
                                      0
                                  ? true
                                  : false,
                              child: Text(
                                "${model.aOrder[index].foodAvailableCount.unavailableCount} items are unavailable",
                                style: Theme.of(context)
                                    .textTheme
                                    .display2
                                    .copyWith(
                                      color: darkRed,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: model.aOrder[index].doPay,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                addPaymentScreen,
                                arguments: {
                                  grandTotalKey:
                                      model.aOrder[index].grandTotal.toString(),
                                  orderIDKey: model.aOrder[index].id.toString(),
                                  typeKey: pendingPay
                                },
                              ).then((value) => {
                                    model.initApiMyOrdersApiCall(context),
                                  });
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                color: appColor,
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Center(
                                child: Text(
                                  'Pay',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display3
                                      .copyWith(
                                        color: white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  verticalSizedBox(),
                  VerticalColoredSizedBox(),
                ],
              ),
            ),
          ),
        ),
      );
}
