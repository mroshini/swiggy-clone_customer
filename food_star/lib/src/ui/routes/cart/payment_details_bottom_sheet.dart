import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/doted_divider.dart';

class PaymentDetailScreen extends StatefulWidget {
  final Map<String, String> paymentInfo;

  PaymentDetailScreen({this.paymentInfo});

  @override
  _PaymentDetailScreenState createState() =>
      _PaymentDetailScreenState(paymentInfo: paymentInfo);
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  final Map<String, String> paymentInfo;

  _PaymentDetailScreenState({this.paymentInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                dragIcon(),
                verticalSizedBox(),
                paymentDetailRow(
                  textValueOne: S.of(context).paymentDetails,
                  styleOne: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontSize: 16),
                ),
                verticalSizedBoxFive(),
                divider(),
                Column(
                  children: <Widget>[
                    verticalSizedBoxFive(),
                    paymentDetailRow(
                      textValueOne: CommonStrings.originalPrice,
                      styleOne: Theme.of(context).textTheme.display2,
                      textValueTwo: paymentInfo[itemOriginalPrice],
                      styleTwo: Theme.of(context).textTheme.display2.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                    paymentDetailRow(
                      textValueOne: S.of(context).priceEstimated,
                      styleOne: Theme.of(context).textTheme.display2,
                      textValueTwo: paymentInfo[estimatedPrice],
                      styleTwo: Theme.of(context).textTheme.display2,
                    ),
//                    Visibility(
//                      visible: paymentInfo[offerDiscount].isNotEmpty,
//                      child: paymentDetailRow(
//                        textValueOne: CommonStrings.offerDiscount,
//                        styleOne: Theme.of(context).textTheme.display2,
//                        textValueTwo: paymentInfo[offerDiscount],
//                        styleTwo: Theme.of(context).textTheme.display2,
//                      ),
//                    ),
                    Visibility(
                      visible: paymentInfo[tax].isNotEmpty,
                      child: paymentDetailRow(
                        textValueOne: CommonStrings.tax,
                        styleOne: Theme.of(context).textTheme.display2,
                        textValueTwo: paymentInfo[tax],
                        styleTwo: Theme.of(context).textTheme.display2,
                      ),
                    ),
//                    paymentDetailRow(
//                      textValueOne: "",
//                      styleOne: Theme.of(context).textTheme.display2,
//                      textValueTwo: paymentInfo[itemOriginalPrice],
//                      styleTwo: Theme.of(context).textTheme.display2,
//                    ),
                    Visibility(
                      visible: paymentInfo[deliveryPrice].isNotEmpty,
                      child: paymentDetailRow(
                        textValueOne: CommonStrings.deliveryCharges,
                        styleOne: Theme.of(context).textTheme.display2,
                        textValueTwo: paymentInfo[deliveryPrice],
                        styleTwo: Theme.of(context).textTheme.display2,
                      ),
                    ),
                    Visibility(
                      visible: paymentInfo[delChargeTaxPrice].isNotEmpty,
                      child: paymentDetailRow(
                        textValueOne: CommonStrings.deliveryChargeTax,
                        styleOne: Theme.of(context).textTheme.display2,
                        textValueTwo: paymentInfo[delChargeTaxPrice],
                        styleTwo: Theme.of(context).textTheme.display2,
                      ),
                    ),
//                    Visibility(
//                      visible: paymentInfo[deliveryChargeDiscount].isNotEmpty,
//                      child: paymentDetailRow(
//                        textValueOne: CommonStrings.deliveryChargeDiscount,
//                        styleOne: Theme.of(context).textTheme.display2,
//                        textValueTwo: paymentInfo[deliveryChargeDiscount],
//                        styleTwo: Theme.of(context).textTheme.display2,
//                      ),
//                    ),
                    Visibility(
                      visible: paymentInfo[promoamount].isNotEmpty,
                      child: paymentDetailRow(
                        textValueOne: CommonStrings.couponDiscount,
                        styleOne: Theme.of(context).textTheme.display2,
                        textValueTwo: paymentInfo[promoamount],
                        styleTwo: Theme.of(context).textTheme.display2,
                      ),
                    ),
//                    Visibility(
//                      visible: paymentInfo[savedPrice] != null ||
//                          paymentInfo[savedPrice] != "0",
//                      child: Column(
//                        children: [
//                          verticalSizedBoxFive(),
//                          DotedDivider(
//                            color: Colors.grey[300],
//                          ),
//                          verticalSizedBoxFive(),
//                          paymentDetailRow(
//                            textValueOne: 'You Saved',
//                            styleOne: Theme.of(context).textTheme.display2,
//                            textValueTwo: '${paymentInfo[savedPrice]}',
//                            styleTwo: Theme.of(context).textTheme.display2,
//                          ),
//                        ],
//                      ),
//                    ),
//                    verticalSizedBoxFive(),

//                    DotedDivider(
//                      color: Colors.grey[300],
//                    ),
//                    verticalSizedBoxFive(),
//                    Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(
//                          S.of(context).deliveryFee,
//                          style: Theme.of(context).textTheme.display2,
//                        ),
//                        Text(
//                          paymentInfo[deliveryPrice],
//                          style: Theme.of(context).textTheme.display2,
//                        ),
////                            RichText(
////                              text: TextSpan(
////                                children: [
////                                  TextSpan(
////                                    text: '( 15,000 - ',
////                                    style: Theme.of(context).textTheme.display2,
////                                  ),
////                                  TextSpan(
////                                    text: "6,000 ) ",
////                                    style: Theme.of(context)
////                                        .textTheme
////                                        .display2
////                                        .copyWith(color: blue),
////                                  ),
////                                  TextSpan(
////                                    text: '9,000',
////                                    style: Theme.of(context).textTheme.display2,
////                                  ),
////                                ],
////                              ),
////                            ),
//                      ],
//                    ),
//                    verticalSizedBox(),
                    DotedDivider(
                      color: Colors.grey[300],
                    ),
//                        verticalSizedBoxFive(),
//                        paymentDetailRow(
//                          textValueOne: S.of(context).restoOffer,
//                          styleOne: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                          textValueTwo: '-12.000',
//                          styleTwo: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                        ),
//                        verticalSizedBoxFive(),
//                        DotedDivider(
//                          color: Colors.grey[300],
//                        ),
//                        verticalSizedBoxFive(),
//                        paymentDetailRow(
//                          textValueOne: S.of(context).gofoodPartnerDiscount,
//                          styleOne: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                          textValueTwo: '-6.000',
//                          styleTwo: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                        ),
//                        verticalSizedBoxFive(),
//                        DotedDivider(
//                          color: Colors.grey[300],
//                        ),
//                        verticalSizedBoxFive(),
//                        paymentDetailRow(
//                          textValueOne: S.of(context).promo,
//                          styleOne: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                          textValueTwo: '-157.000',
//                          styleTwo: Theme.of(context)
//                              .textTheme
//                              .display2
//                              .copyWith(color: blue),
//                        ),
//                        verticalSizedBoxFive(),
//                        divider(),
                    verticalSizedBoxFive(),
                    paymentDetailRow(
                      textValueOne: S.of(context).totalPayment,
                      styleOne: Theme.of(context).textTheme.display2.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                      textValueTwo: paymentInfo[totalPrice],
                      styleTwo: Theme.of(context).textTheme.display2.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                // verticalSizedBoxTwenty(),
                //  verticalSizedBoxFive(),
                //  divider(),
                //  verticalSizedBoxFive(),
//                Expanded(
//                  child: Column(
//                    children: <Widget>[
//                      Text(
//                        S
//                            .of(context)
//                            .disclaimerFinalPriceMayChangeSlightlyIfTheRestaurantHas,
//                        style: Theme.of(context)
//                            .textTheme
//                            .body2
//                            .copyWith(fontSize: 12),
//                      ),
//                      verticalSizedBoxFive(),
//                      Text(
//                          S
//                              .of(context)
//                              .forYourEasePleaseMakeSureYourOrderDoesntNeed,
//                          style: Theme.of(context)
//                              .textTheme
//                              .body2
//                              .copyWith(fontSize: 12)),
//                      verticalSizedBoxFive(),
//                      DotedDivider(
//                        color: Colors.grey[300],
//                      ),
//                      verticalSizedBoxFive(),
//                      Text(
//                        S
//                            .of(context)
//                            .convenienceFeeIsAFeeForOrderingThroughGofood,
//                        style: Theme.of(context)
//                            .textTheme
//                            .body2
//                            .copyWith(fontSize: 12),
//                      ),
//                    ],
//                  ),
//                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
