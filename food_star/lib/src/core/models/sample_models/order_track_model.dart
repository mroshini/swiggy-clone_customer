class OrderTrackModel {
  String title;
  String subTitle;

  OrderTrackModel({
    this.title,
    this.subTitle,
  });
}

class OrderTrackData {
  List<OrderTrackModel> trackOrderInfo = [
    OrderTrackModel(
      title: 'Order Placed',
      subTitle: 'We just received your order',
    ),
    OrderTrackModel(
      title: 'Order Confirmed',
      subTitle: 'We are preparing your order',
    ),
    OrderTrackModel(
      title: 'Delivery in Progress',
      subTitle: 'Your food is on the way!',
    ),
    OrderTrackModel(
      title: 'Order Delivered',
      subTitle: 'Your order has been delivered',
    ),
  ];
}
