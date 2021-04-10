import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/models/api_models/socket_data_model.dart';
import 'package:foodstar/src/core/socket/listen_socket_event.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/shared/sizedbox.dart';
import 'package:socket_io_client/socket_io_client.dart';

class UpcomingOrdersCard extends StatefulWidget {
  final String acceptOrNewOrders;

  UpcomingOrdersCard({this.acceptOrNewOrders});

  @override
  _UpcomingOrdersCardState createState() =>
      _UpcomingOrdersCardState(acceptOrNewOrders: acceptOrNewOrders);
}

class _UpcomingOrdersCardState extends State<UpcomingOrdersCard> {
  final String acceptOrNewOrders;
  Socket socket;

  _UpcomingOrdersCardState({this.acceptOrNewOrders});

  @override
  void initState() {
    super.initState();
    socket = io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SocketDataModel>(
        initialData:
            SocketDataModel(status: SocketEventStatus.none, orderId: 0),
        stream:
            //, socket: socket
            ListenSocketEvents(context: context)
                .connectionStatusController
                .stream,
        builder: (context, AsyncSnapshot<SocketDataModel> snapshot) {
          return Visibility(
            visible:
                snapshot.data.status != SocketEventStatus.none ? true : false,
            child: GestureDetector(
              onTap: () async {
                //  updateClicked(false);
                setState(() {
                  ListenSocketEvents(context: context)
                      .connectionStatusController
                      .sink
                      .add(
                        SocketDataModel(
                          status: SocketEventStatus.none,
                          orderId: 0,
                        ),
                      );
                });
                showLog(
                    "GestureDetector--${snapshot.data.status}--${snapshot.data.orderId}");
//                snapshot.data.status == SocketEventStatus.delivered
//                    ? Navigator.pushNamed(
//                        context,
//                        rateOrder,
//                        arguments: snapshot.data.orderId,
//                      )
//                    : Navigator.pushNamed(context, trackOrderRoute,
//                        arguments: {orderIDKey: '${snapshot.data.orderId}'});
              },
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  color: appColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      verticalSizedBoxFive(),
                      Expanded(
                        child: Text(
                          //   '$acceptOrNewOrders',
                          snapshot.data.status ==
                                  SocketEventStatus.handOveredToBoy
                              ? "Order handovered to delivery boy"
                              : snapshot.data.status ==
                                      SocketEventStatus.boyAccepted
                                  ? "Delivery Boy Accepted your Orders"
                                  : snapshot.data.status ==
                                          SocketEventStatus.delivered
                                      ? "Order Delivered"
                                      : snapshot.data.status ==
                                              SocketEventStatus.rejected
                                          ? "Order Rejected"
                                          : "Track your orders",
                          style: Theme.of(context).textTheme.display1.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

//                              child: Text(
//                                '${snapshot.data.status}',
//                                style: Theme.of(context).textTheme.display1,
//                              ),
//                child: UpcomingOrdersCard(
//                  acceptOrNewOrders:
//                  snapshot.data.status.toString(),
////                                acceptOrNewOrders: snapshot.data.status ==
////                                        SocketEventStatus.handOveredToBoy
////                                    ? "Order handovered to delivery boy"
////                                    : snapshot.data.status ==
////                                            SocketEventStatus.boyAccepted
////                                        ? "Delivery Boy Accepted your Orders"
////                                        : snapshot.data.status ==
////                                                SocketEventStatus.delivered
////                                            ? "Order Delivered"
////                                            : snapshot.data.status ==
////                                                    SocketEventStatus.rejected
////                                                ? "Order Rejected"
////                                                : "",
//                ),
              ),
            ),
          );
        });

//    Container(
//    width: MediaQuery.of(context).size.width,
//    height: 70,
//    color: appColor,
//    child: Column(
//    crossAxisAlignment: CrossAxisAlignment.center,
//    mainAxisAlignment: MainAxisAlignment.start,
//    children: <Widget>[
//    Expanded(
//    child: Icon(
//    Icons.keyboard_arrow_up,
//    color: Colors.white,
//    size: 30,
//    ),
//    ),
//    verticalSizedBoxFive(),
//    Expanded(
//    child: Text(
//    '$acceptOrNewOrders',
////              snapshot.data.status == SocketEventStatus.handOveredToBoy
////                  ? "Order handovered to delivery boy"
////                  : snapshot.data.status == SocketEventStatus.boyAccepted
////                      ? "Delivery Boy Accepted your Orders"
////                      : snapshot.data.status == SocketEventStatus.delivered
////                          ? "Order Delivered"
////                          : snapshot.data.status == SocketEventStatus.rejected
////                              ? "Order Rejected"
////                              : "Track your orders",
//    style: Theme.of(context).textTheme.display1.copyWith(
//    color: Colors.white,
//    ),
//    ),
//    ),
//    ]
//    ,
//    )
//    ,
//    );
//    return StreamBuilder<SocketDataModel>(
//        initialData:
//            SocketDataModel(status: SocketEventStatus.none, orderId: 0),
//        stream: ListenSocketEvents(context: context, socket: socket)
//            .connectionStatusController
//            .stream,
//        builder: (context, AsyncSnapshot<SocketDataModel> snapshot) {
//          return Container(
//            width: MediaQuery.of(context).size.width,
//            height: 70,
//            color: appColor,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                Expanded(
//                  child: Icon(
//                    Icons.keyboard_arrow_up,
//                    color: Colors.white,
//                    size: 30,
//                  ),
//                ),
//                verticalSizedBoxFive(),
//                Expanded(
//                  child: Text(
//                    snapshot.data.status == SocketEventStatus.handOveredToBoy
//                        ? "Order handovered to delivery boy"
//                        : snapshot.data.status == SocketEventStatus.boyAccepted
//                            ? "Delivery Boy Accepted your Orders"
//                            : snapshot.data.status ==
//                                    SocketEventStatus.delivered
//                                ? "Order Delivered"
//                                : snapshot.data.status ==
//                                        SocketEventStatus.rejected
//                                    ? "Order Rejected"
//                                    : "Track your orders",
//                    style: Theme.of(context).textTheme.display1.copyWith(
//                          color: Colors.white,
//                        ),
//                  ),
//                ),
//              ],
//            ),
//          );
//        });
  }
}
