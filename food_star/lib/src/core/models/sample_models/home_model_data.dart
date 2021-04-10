import 'package:foodstar/src/core/models/sample_models/home_model.dart';

class HomeModelData {
  List<HomeInfo> homeInfo = [
    HomeInfo(
        lineOne: "Kfc,Trademart Kfc,Trademart, Kfc,Trademart",
        lineTwo: 'Rice, chicken & duck',
        rating: '4.7',
        distance: '7.8 km',
        image: "assets/images/food1.jpg",
        shopStatus: 1,
        timing: "(33 mins)"),
    HomeInfo(
        lineOne: "Roberty, STA KRL juadaa",
        lineTwo: 'Rice, chicken & duck',
        rating: '4.3',
        distance: '6.8 km',
        image: 'assets/images/shop2.jpg',
        shopStatus: 2,
        timing: "(30 mins)"),
    HomeInfo(
        lineOne: "Warnugg, Trademart Amigos",
        lineTwo: 'Rice, chicken & duck',
        rating: '4.6',
        distance: '8.8 km',
        image: 'assets/images/food1.jpg',
        shopStatus: 3,
        timing: "(30 mins)"),
    HomeInfo(
        lineOne: "Pawon mas Yono",
        lineTwo: 'Rice, chicken & duck',
        rating: '4.6',
        distance: '5.8 km',
        image: " ",
        shopStatus: 1,
        timing: "(30 mins)"),
    HomeInfo(
      lineOne: "Kfc,Trademart,Kfc,Trademart ,Kfc,Trademart",
      lineTwo: 'Rice, chicken & duck',
      rating: '4.2',
      distance: '6.8 km',
      image: 'assets/images/food3.jpg',
      shopStatus: 2,
    ),
    HomeInfo(
        lineOne: "Pawon mas Yono",
        lineTwo: 'Rice, chicken & duck',
        rating: '4.1',
        distance: '7.8 km',
        image: 'assets/images/food1.jpg',
        shopStatus: 1,
        timing: "(30 mins)"),
  ];

  List<String> imagePath = [
    "assets/images/food1.jpg",
    "assets/images/food2.jpg",
    "assets/images/food3.jpg",
    "assets/images/food4.jpg",
    "assets/images/food5.jpg",
    "assets/images/food6.jpg",
    "assets/images/food7.jpg",
  ];
}
