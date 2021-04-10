import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/buttons/form_submit_button.dart';

class SuccessOrderScreen extends StatefulWidget {
  final String orderID;

  SuccessOrderScreen({this.orderID});

  @override
  _SuccessOrderScreenState createState() => _SuccessOrderScreenState();
}

class _SuccessOrderScreenState extends State<SuccessOrderScreen>
    with TickerProviderStateMixin {
  Animation successOrderAnimation;
  AnimationController _orderAnimationController;
  final double pi = 3.1415926535897932;

  @override
  void initState() {
    super.initState();
    _orderAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

//    successOrderAnimation = Tween(begin: 150.0, end: 170.0).animate(
//        CurvedAnimation(
//            curve: Curves.bounceOut, parent: _orderAnimationController));

    _orderAnimationController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _orderAnimationController.repeat();
      }
    });
    _orderAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text('Your order placed successfully',
                                    style: Theme.of(context).textTheme.subhead),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
//                  child: AnimatedBuilder(
//                    animation: _orderAnimationController,
//                    builder: (BuildContext context, Widget child) {
//                      return Container(
//                        height: 100,
//                        width: 100,
//                        decoration: BoxDecoration(
//                          color: Colors.grey[100],
//                          shape: BoxShape.circle,
//                        ),
//                        child: Padding(
//                          padding: const EdgeInsets.all(15.0),
//                          child: Container(
//                            decoration: BoxDecoration(
//                              color: appColor,
//                              shape: BoxShape.circle,
//                            ),
//                            child: Center(
//                              child: Icon(
//                                Icons.check,
//                                size: 35,
//                                color: Colors.white,
//                              ),
//                            ),
//                          ),
//                        ),
//                      );
//                    },
//                  ),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: appColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: FormSubmitButton(
                  title: 'Track Order',
                  onPressed: () {
                    Navigator.of(context)
                        .popAndPushNamed(trackOrderRoute, arguments: {
                      orderIDKey: widget.orderID,
                    } // show order success details below map
                            );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _orderAnimationController.dispose();

    super.dispose();
  }

//  LayoutBuilder(
//  builder: (BuildContext context, BoxConstraints viewportConstraints) {
//  return Padding(
//  padding: const EdgeInsets.all(10.0),
//  child: Column(
//  crossAxisAlignment: CrossAxisAlignment.center,
//  mainAxisAlignment: MainAxisAlignment.center,
//  children: <Widget>[
//  Expanded(
//  child: SingleChildScrollView(
//  child: ConstrainedBox(
//  constraints: BoxConstraints(
//  minHeight: viewportConstraints.maxHeight,
//  ),
//  child: Column(
//  crossAxisAlignment: CrossAxisAlignment.center,
//  mainAxisAlignment: MainAxisAlignment.start,
//  children: <Widget>[
//  Text(
//  'Congratulations!',
//  style: Theme.of(context).textTheme.subhead.copyWith(
//  color: appColor,
//  ),
//  ),
//  verticalSizedBox(),
//  Container(
//  height: 100,
//  width: 100,
//  decoration: BoxDecoration(
//  color: Colors.grey[100],
//  shape: BoxShape.circle,
//  ),
//  child: Padding(
//  padding: const EdgeInsets.all(15.0),
//  child: Container(
//  decoration: BoxDecoration(
//  color: appColor,
//  shape: BoxShape.circle,
//  ),
//  child: Center(
//  child: Icon(
//  Icons.check,
//  size: 35,
//  color: Colors.white,
//  ),
//  ),
//  ),
//  ),
//  ),
//  verticalSizedBox(),
//  FormSubmitButton(
//  title: 'Track Order',
//  onPressed: () {},
//  ),
//  ],
//  ),
//  ),
//  ),
//  ),
//  ]),
//  );
//  }),
}
