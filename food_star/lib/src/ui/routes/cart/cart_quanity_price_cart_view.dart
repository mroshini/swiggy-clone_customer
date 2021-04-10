import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';

class CartQuantityPriceCardView extends StatefulWidget {
  @override
  _CartQuantityPriceCardViewState createState() =>
      _CartQuantityPriceCardViewState();
}

class _CartQuantityPriceCardViewState extends State<CartQuantityPriceCardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Consumer<CartQuantityViewModel>(
          builder: (BuildContext context, CartQuantityViewModel model,
              Widget child) {
            return Visibility(
              visible: model.cartQuantityData?.totalQuantity != null,
              maintainSize: false,
              child: model.cartItemChanged
                  ? Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          backgroundColor: white,
                          strokeWidth: 3,
                        ),
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalSizedBox(),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              verticalSizedBoxFive(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          '${model.cartQuantityData?.totalQuantity} items | ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(color: white, fontSize: 14),
                                    ),
                                    TextSpan(
                                      text:
                                          '${model.currencySymbol} ${model.cartQuantityData?.totalPrice}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .display1
                                          .copyWith(color: white, fontSize: 14),
                                    ),
                                    TextSpan(text: " "),
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.shopping_basket,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
//                          TextSpan(
//                            text: ' ${model.cartData.totalPrice} ',
//                            style: Theme.of(context)
//                                .textTheme
//                                .display1
//                                .copyWith(
//                                    color: white,
//                                    fontWeight: FontWeight.w400,
//                                    decoration: TextDecoration.lineThrough,
//                                    decorationColor: white,
//                                    fontSize: 11),
//                          ),
//                          TextSpan(
//                            text: '(est)',
//                            style:
//                                Theme.of(context).textTheme.display1.copyWith(
//                                      color: white,
//                                      fontSize: 10,
//                                    ),
//                          )
                                  ],
                                ),
                              ),
                              verticalSizedBoxFive(),
                              Text(
                                '${model.restaurantName}',
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .display1
                                    .copyWith(
                                      color: white,
                                      fontSize: 11,
                                    ),
                              ),
                              verticalSizedBoxFive(),
                            ],
                          ),
                        ),
                        horizontalSizedBoxTwenty(),
                        Flexible(
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                        horizontalSizedBox(),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
