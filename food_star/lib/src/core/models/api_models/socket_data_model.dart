import 'package:foodstar/src/core/socket/listen_socket_event.dart';

class SocketDataModel {
  SocketEventStatus status;
  int orderId;

  SocketDataModel({
    this.status,
    this.orderId,
  });
}
