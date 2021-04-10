import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/rate_your_order_view_model.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/ui/shared/show_snack_bar.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:foodstar/src/utils/validation.dart';
import 'package:provider/provider.dart';

class RateYourOrderScreen extends StatefulWidget {
  final int orderID;

  RateYourOrderScreen({this.orderID});

  @override
  _RateYourOrderScreenState createState() =>
      _RateYourOrderScreenState(orderID: orderID);
}

class _RateYourOrderScreenState extends State<RateYourOrderScreen> {
  final int orderID;
  TextEditingController restaurantFeedbackController;
  TextEditingController boyFeedbackController;
  FocusNode restaurantFocus;
  FocusNode boyFocus;
  final _formKey = GlobalKey<FormState>();

  _RateYourOrderScreenState({this.orderID});

  @override
  void initState() {
    super.initState();
    restaurantFeedbackController = TextEditingController();
    boyFeedbackController = TextEditingController();
    restaurantFocus = FocusNode();
    boyFocus = FocusNode();
  }

  @override
  void dispose() {
    restaurantFeedbackController.dispose();
    restaurantFocus.dispose();
    boyFocus.dispose();
    boyFeedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RateYourOrderViewModel>(builder:
        (BuildContext context, RateYourOrderViewModel model, Widget child) {
      return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          actions: [
            GestureDetector(
              onTap: () {
                model.updateRatingOrSkip(
                  dynamicMapValue: {
                    orderIDKey: "15", //orderID.toString(),
                    ratingKey: "",
                    actionKey: skipRating,
                    commentsKey: "",
                    boyRatingKey: "",
                    boyCommentsKey: "",
                  },
                  buildContext: context,
                ).then((value) => {
                      if (value != null)
                        {
                          Navigator.pop(context),
                        }
                    });
              },
              child: Container(
                child: Center(
                    child: Text(
                  'SKIP',
                  style: Theme.of(context).textTheme.display1,
                )),
              ),
            ),
            horizontalSizedBoxTwenty(),
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(
            children: [
              Column(children: <Widget>[
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
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  verticalSizedBox(),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.grey[200], width: .5),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Restaurant Food Rating',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        verticalSizedBox(),
                                        RatingBar(
                                          initialRating: 0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            // print(rating);
                                            model.restRating = rating;
                                          },
                                        ),
                                        verticalSizedBox(),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: TextFormField(
                                              controller:
                                                  restaurantFeedbackController,
                                              minLines: 3,
                                              maxLines: 3,
                                              autocorrect: false,
                                              validator: (value) {
                                                return nameValidation(value);
                                              },
                                              onFieldSubmitted: (term) {
                                                restaurantFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(boyFocus);
                                              },
                                              textInputAction:
                                                  TextInputAction.next,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Tell us what you loved...',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .display1
                                                    .copyWith(
                                                      color: Colors.grey[400],
                                                    ),
//filled: true,
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  verticalSizedBox(),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color: Colors.grey[200], width: .5),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Rate delivery boy service',
                                          style: Theme.of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        verticalSizedBox(),
                                        RatingBar(
                                          initialRating: 0,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            //  print(rating);
                                            model.boyRating = rating;
                                          },
                                        ),
                                        verticalSizedBox(),
                                        Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: TextFormField(
                                              controller: boyFeedbackController,
                                              validator: (value) {
                                                return nameValidation(value);
                                              },
                                              onFieldSubmitted: (term) {
                                                boyFocus.unfocus();
                                                FocusScope.of(context)
                                                    .requestFocus(null);
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .body1,
                                              minLines: 3,
                                              maxLines: 3,
                                              autocorrect: false,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Tell us what you loved...',
                                                hintStyle: Theme.of(context)
                                                    .textTheme
                                                    .display1
                                                    .copyWith(
                                                      color: Colors.grey[400],
                                                    ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10.0),
                                                  ),
                                                  borderSide: BorderSide(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(
                      'SUBMIT FEEDBACK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                    color: appColor,
                    disabledColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    )),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _formKey.currentState.save();

                        if (model.restRating != 0.0 || model.boyRating != 0.0) {
                          model.updateRatingOrSkip(
                            dynamicMapValue: {
                              orderIDKey: "15", //orderID.toString(),
                              ratingKey: model.restRating.toString(),
                              actionKey: updateRating,
                              commentsKey: restaurantFeedbackController.text,
                              boyRatingKey: model.boyRating.toString(),
                              boyCommentsKey: boyFeedbackController.text,
                            },
                            buildContext: context,
                          ).then((value) => {
                                if (value != null)
                                  {
                                    Navigator.pop(context),
                                  }
                              });
                        } else {
                          showSnackbar(
                              message: 'Please give rating for the service',
                              context: context);
                        }
                      }
                    },
                  ),
                ),
//            FormSubmitButton(
//            title: 'CONTINUE',
//            onPressed: () async {},
//            )
//            ,
              ]),
              Visibility(
                visible: model.state == BaseViewState.Busy,
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
        }),
      );
    });
  }
}
