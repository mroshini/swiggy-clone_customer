import 'package:foodstar/src/core/models/sample_models/my_orders_model.dart';

class MyOrdersData {
  List<MyOrdersModel> myOrders = [
    MyOrdersModel(
      title: 'Iced Lemon Meringue Latte VENTI',
      description: 'Lemon,Water,ice,Lemon,Water,ice,Lemon,Water,ice,',
      date: '2 Apr 2020 : 13:00',
      orderStatus: 'Canceled',
      totalItem: '5',
      price: '534.000',
      image: 'assets/images/food2.jpg',
      availableStatus: 1,
    ),
    MyOrdersModel(
      title: 'Choclate Lover (Tall size)',
      description:
          'Signature choclate + Brown choclate + Drop cream choclate + Choclate Chip Flipndsfkdshf',
      date: '2 Apr 2020 : 13:00',
      orderStatus: 'Canceled',
      totalItem: '3',
      price: '450.000',
      image: 'assets/images/shop2.jpg',
      availableStatus: 0,
    ),
    MyOrdersModel(
      title: 'Iced Lemon Meringue Latte VENTI',
      description: 'Lemon,Water,ice,Lemon,Water,ice,Lemon,Water,ice,',
      date: '2 Apr 2020 : 13:00',
      orderStatus: 'Canceled',
      totalItem: '2',
      price: '390.000',
      image: 'assets/images/food1.jpg',
      availableStatus: 0,
    ),
  ];
}
