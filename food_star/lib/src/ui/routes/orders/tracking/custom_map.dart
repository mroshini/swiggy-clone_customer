import 'package:flutter/material.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/map_view_modal.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CustomMap extends StatefulWidget {
  @override
  _CustomMapState createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<MapViewModel>(context);

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition:
          CameraPosition(target: model.initialPosition, zoom: 15),
      //  myLocationButtonEnabled: true,
      myLocationEnabled: true,
      compassEnabled: true,
      markers: model.markers,
      polylines: model.polyLines,
      onCameraMove: model.onCameraMove,
      onMapCreated: model.onCreated,
    );
  }
}
