import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/custom_map.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/destination_picker_draggable.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/map_view_modal.dart';
import 'package:provider/provider.dart';

class MapHomeRoute extends StatefulWidget {
  @override
  _MapHomeRouteState createState() => _MapHomeRouteState();
}

class _MapHomeRouteState extends State<MapHomeRoute> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MapViewModel>(context);

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[
          model.initialPosition != null
              ? Consumer<MapViewModel>(
                  builder: (context, model, child) {
                    return CustomMap();
                  },
                )
              : Container(
                  alignment: Alignment.center,
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: model.locationServiceActive == false,
                        child: Text(
                          "Please enable location services!",
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      )
                    ],
                  ))),
          DestinationPickerDraggable()
        ],
      ),
    ));
  }
}
