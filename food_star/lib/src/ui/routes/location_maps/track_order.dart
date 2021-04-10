import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/core/models/sample_models/order_track_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/ui/shared/others.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';

class TrackOrderScreen extends StatefulWidget {
  @override
  _TrackOrderScreenState createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  var trackOrder = OrderTrackData().trackOrderInfo;
  var stepIcons = [Icons.done, Icons.done, Icons.done];
  int _curStep = 2;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 1.0,
      initialChildSize: .50,
      minChildSize: .50,
      builder: (context, scrollController) {
        return Scaffold(
          body: Consumer<ThemeManager>(
            builder: (BuildContext context, ThemeManager theme, Widget child) {
              return Container(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          dragIcon(),
                          verticalSizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                trackOrderMenu(
                                  iconValue: Icons.call,
                                  title: 'Call Restaurant',
                                ),
                                trackOrderMenu(
                                  iconValue: Icons.person_outline,
                                  title: 'Call Delivery boy',
                                ),
                                trackOrderMenu(
                                  iconValue: Icons.supervisor_account,
                                  title: 'Customer Care',
                                ),
                                trackOrderMenu(
                                  iconValue: Icons.playlist_add_check,
                                  title: 'Order details',
                                ),
                              ],
                            ),
                          ),
                          divider(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              StepsIndicator(
                                selectedStep: 1,
                                nbSteps: 4,
                                selectedStepColorOut: Colors.green,
                                doneStepColor: Colors.green,
                                selectedStepColorIn: Colors.white,
                                doneLineColor: Colors.green,
                                undoneLineColor: Colors.grey,
                                doneLineThickness: 1.0,
                                unselectedStepColorOut: Colors.grey,
                                isHorizontal: false,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  stepperView(
                                      title: trackOrder[0].title,
                                      subTitle: trackOrder[0].subTitle),
                                  stepperView(
                                      title: trackOrder[1].title,
                                      subTitle: trackOrder[1].subTitle),
                                  stepperView(
                                      title: trackOrder[2].title,
                                      subTitle: trackOrder[2].subTitle),
                                  stepperView(
                                      title: trackOrder[3].title,
                                      subTitle: trackOrder[3].subTitle),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Padding stepperView({String title, String subTitle}) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.display3.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              subTitle,
              style: Theme.of(context).textTheme.display2.copyWith(
                    fontSize: 12,
                  ),
            ),
          ],
        ),
      );

  Flexible trackOrderMenu({IconData iconValue, String title}) => Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(iconValue),
            verticalSizedBox(),
            Text(
              title,
              style:
                  Theme.of(context).textTheme.display1.copyWith(fontSize: 13),
            ),
          ],
        ),
      );
}
