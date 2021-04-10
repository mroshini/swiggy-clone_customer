import 'dart:async';

import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/socket_data_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/base_change_notifier_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum SocketEventStatus {
  handOveredToBoy,
  boyAccepted,
  delivered,
  rejected,
  none
}

class ListenSocketEvents extends BaseChangeNotifierModel {
  BuildContext context;
  Socket socket;
  int userID;
  SharedPreferences prefs;

  StreamSubscription subscription;

  // Create our public controller
  StreamController<SocketDataModel> connectionStatusController =
      StreamController<SocketDataModel>();

  //{this.context, this.socket}
  ListenSocketEvents({this.context}) {
    initSocket();
  }

  initSocket() {
    socket = io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.on('connect', (_) async {
      print('connect');
      await getUserID();
      socket.emit(socketCreateConnection, 'cust_$userID');
    });

    socket.on(
        socketBoyAccepted,
        (data) => {
              //showSnackbar(message: socketNewOrdersPlaced, context: context),
//              Provider.of<PartnerOrderViewModel>(context, listen: false)
//                  .getPartnerOrdersData(status: newOrdersData),
              showLog("socketBoyAccepted--${data}"),
              connectionStatusController.sink.add(
                SocketDataModel(
                    status: SocketEventStatus.boyAccepted,
                    orderId: data['order_id']),
              ),
//              subscription = connectionStatusController.stream.listen((event) {
//                showLog("socketBoyAccepted1--${event.status}");
//              }),
            });

    socket.on(
        socketOrderHandOvered,
        (data) => {
              //  showSnackbar(message: socketBoyAccepted, context: context),
//              Provider.of<PartnerOrderViewModel>(context, listen: false)
//                  .getPartnerOrdersData(status: partnerAccepted),
              showLog("socketOrderHandOvered--${data}-${data['order_id']}"),

              connectionStatusController.sink.add(
                SocketDataModel(
                    status: SocketEventStatus.handOveredToBoy,
                    orderId: data['order_id']),
              ),
//              subscription = connectionStatusController.stream.listen((event) {
//                showLog("socketOrderHandOvered1--${event.status}");
//              }),
            });

    socket.on(
        socketPartnerRejected,
        (data) => {
              //  showSnackbar(message: socketBoyAccepted, context: context),
//              Provider.of<PartnerOrderViewModel>(context, listen: false)
//                  .getPartnerOrdersData(status: partnerAccepted),
              showLog("socketPartnerRejected--${data}-${data['order_id']}"),
              connectionStatusController.sink.add(
                SocketDataModel(
                    status: SocketEventStatus.rejected,
                    orderId: data['order_id']),
              ),
//              subscription = connectionStatusController.stream.listen((event) {
//                showLog("socketPartnerRejected1--${event.status}");
//              }),
            });

    socket.on(
        socketOrderDelivered,
        (data) => {
              //  showSnackbar(message: socketBoyAccepted, context: context),
//              Provider.of<PartnerOrderViewModel>(context, listen: false)
//                  .getPartnerOrdersData(status: partnerAccepted),
              showLog("socketOrderDelivered--${data}-${data['order_id']}"),
              connectionStatusController.sink.add(
                SocketDataModel(
                    status: SocketEventStatus.delivered,
                    orderId: data['order_id']),
              ),
//              subscription = connectionStatusController.stream.listen((event) {
//                showLog("socketOrderDelivered1--${event.status}");
//              }),
            });

    socket.connect();
  }

  getUserID() async {
    await initPref();
    userID = prefs.getInt(SharedPreferenceKeys.userId) ?? 0;
    showLog("userID--${userID}");
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

// Convert from the third part enum to our own enum
  SocketDataModel _getStatusFromResult(SocketDataModel result) {
    switch (result.status) {
      case SocketEventStatus.boyAccepted:
        showLog("ConnectivityResultmobile--${result}");
        return SocketDataModel(
            status: SocketEventStatus.boyAccepted, orderId: result.orderId);
      case SocketEventStatus.rejected:
        showLog("ConnectivityResultwifi--${result}");
        return SocketDataModel(
            status: SocketEventStatus.rejected, orderId: result.orderId);
      case SocketEventStatus.delivered:
        showLog("ConnectivityResultwifi--${result}");
        return SocketDataModel(
            status: SocketEventStatus.delivered, orderId: result.orderId);
      case SocketEventStatus.handOveredToBoy:
        showLog("ConnectivityResultwifi--${result}");
        return SocketDataModel(
            status: SocketEventStatus.handOveredToBoy, orderId: result.orderId);
      default:
        showLog("ConnectivityResultdefault--${result}");
        return null;
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    connectionStatusController.sink.close();
    super.dispose();
  }
}
