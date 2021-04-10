import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class ConnectivityService {
  BuildContext context;

  // Create our public controller
  StreamController<ConnectivityStatus> connectionStatusController =
      StreamController<ConnectivityStatus>();

  ConnectivityService({this.context}) {
    // Subscribe to the connectivity Chanaged Steam
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Use Connectivity() here to gather more info if you need t

      connectionStatusController.add(_getStatusFromResult(result));
    });
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        showLog("ConnectivityResultmobile--${result}");
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        showLog("ConnectivityResultwifi--${result}");
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        showLog("ConnectivityResultnone--${result}");
        return ConnectivityStatus.Offline;
      default:
        showLog("ConnectivityResultdefault--${result}");
        return ConnectivityStatus.Offline;
    }
  }
}
