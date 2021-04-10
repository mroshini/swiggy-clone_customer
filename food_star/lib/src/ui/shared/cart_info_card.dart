import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';

class CartInfoCard extends StatefulWidget {
  @override
  _CartInfoCardState createState() => _CartInfoCardState();
}

class _CartInfoCardState extends State<CartInfoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, cart, arguments: true);
      },
      child: Container(
        decoration: BoxDecoration(
          color: appColor,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
        ),
        child: Consumer<RestaurantDetailsViewModel>(
          builder: (BuildContext context, RestaurantDetailsViewModel model,
              Widget child) {
            return model.cartItemChanged
                ? Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                          backgroundColor: white,
                        ),
                      ),
                    ),
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      horizontalSizedBox(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          verticalSizedBoxFive(),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      '${model.cartData?.totalQuantity} items | ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(color: white, fontSize: 13),
                                ),
                                TextSpan(
                                  text: '${model.cartData?.totalPrice}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .display1
                                      .copyWith(color: white, fontSize: 11),
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
//                          ),
                              ],
                            ),
                          ),
                          verticalSizedBoxFive(),
                          Text(
                            'Cart Items',
                            style:
                                Theme.of(context).textTheme.display1.copyWith(
                                      color: white,
                                      fontSize: 11,
                                    ),
                          ),
                          verticalSizedBoxFive(),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.shopping_basket,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
