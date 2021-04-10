import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/models/api_models/socket_data_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/socket/listen_socket_event.dart';
import 'package:foodstar/src/ui/res/colors.dart';
import 'package:foodstar/src/ui/routes/UpcomingOrdersCard.dart';
import 'package:foodstar/src/ui/routes/auth/login_screen.dart';
import 'package:foodstar/src/ui/routes/cart/cart.dart';
import 'package:foodstar/src/ui/routes/food_star_screen.dart';
import 'package:foodstar/src/ui/routes/my_account/profile.dart';
import 'package:foodstar/src/ui/routes/search/search_restaurant_dish.dart';
import 'package:foodstar/src/utils/network_aware/connectivity_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomeScreen extends StatefulWidget {
  final int selectedIndexFromRoutedScreen;

  HomeScreen({this.selectedIndexFromRoutedScreen = 0});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomNavMenuIndex = 0;
  SharedPreferences prefs;
  Socket socket;

  final List<Widget> _bottomNavScreensIfNotLoggedIn = [
    FoodStarScreen(),
    SearchScreen(),
    CartScreen(
      showArrow: false,
    ),
    LoginScreen(),
  ];

  final List<Widget> _bottomNavScreensIfLoggedIn = [
    FoodStarScreen(),
    SearchScreen(),
    //RateYourOrderScreen(),
    CartScreen(
      showArrow: false,
    ),
    MyAccountScreen(),
  ];

  ConnectivityStatus network;

  @override
  void initState() {
    super.initState();
    setIndexValue();
//    socket = io(socketUrl, <String, dynamic>{
//      'transports': ['websocket'],
//      'autoConnect': false,
//    });
  }

  setIndexValue() {
    setState(() {
      _bottomNavMenuIndex = widget.selectedIndexFromRoutedScreen ?? 0;
    });
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  checkLoginOrNot() async {
    await initPref();
  }

  @override
  Widget build(BuildContext context) {
    network = Provider.of<ConnectivityStatus>(context);
    return SafeArea(
      child: Consumer2<AuthViewModel, HomeRestaurantListViewModel>(
        builder: (builder, auth, homeModel, child) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: Stack(
                children: <Widget>[
//                network == ConnectivityStatus.Offline
//                    ? NoNetworkConnectionScreen()
//                    :
                  _bottomNavScreensIfLoggedIn[_bottomNavMenuIndex ?? 0],
                  //network == ConnectivityStatus.Offline
                  Visibility(
                    visible: false,
                    child: Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 5.0,
                      child: Container(
                        color: Colors.black,
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                          child: Text(
                            CommonStrings.noInternet,
                            style: Theme.of(context)
                                .textTheme
                                .display1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<SocketDataModel>(
                      initialData: SocketDataModel(
                          status: SocketEventStatus.none, orderId: 0),
                      stream: ListenSocketEvents(context: context)
                          .connectionStatusController
                          .stream,
                      builder:
                          (context, AsyncSnapshot<SocketDataModel> snapshot) {
                        return Visibility(
                          visible:
                              snapshot.data.status != SocketEventStatus.none
                                  ? true
                                  : false,
                          child: GestureDetector(
                            onTap: () {
                              //  updateClicked(false);
                              ListenSocketEvents(
                                context: context,
                              ).connectionStatusController.add(
                                    SocketDataModel(
                                        status: SocketEventStatus.none,
                                        orderId: 0),
                                  );

                              snapshot.data.status ==
                                      SocketEventStatus.delivered
                                  ? Navigator.pushNamed(
                                      context,
                                      rateOrder,
                                      arguments: snapshot.data.orderId,
                                    )
                                  : Navigator.pushNamed(
                                      context, trackOrderRoute, arguments: {
                                      orderIDKey: '${snapshot.data.orderId}'
                                    });
                            },
                            child: UpcomingOrdersCard(),
                          ),
                        );
                      }),
//                  GestureDetector(
//                      onTap: (){
//
//                      },
//                      child: UpcomingOrdersCard())
//                  StreamBuilder<SocketDataModel>(
//                      initialData: SocketDataModel(
//                          status: SocketEventStatus.none, orderId: 0),
//                      stream:
//                          //, socket: socket
//                          ListenSocketEvents(context: context)
//                              .connectionStatusController
//                              .stream,
//                      builder:
//                          (context, AsyncSnapshot<SocketDataModel> snapshot) {
//                        return Visibility(
//                          visible:
//                              snapshot.data.status != SocketEventStatus.none
//                                  ? true
//                                  : false,
//                          child: GestureDetector(
//                            onTap: () async {
//                              //  updateClicked(false);
//                              ListenSocketEvents(context: context)
//                                  .connectionStatusController
//                                  .add(
//                                    SocketDataModel(
//                                      status: SocketEventStatus.none,
//                                      orderId: 0,
//                                    ),
//                                  );
//                              showLog(
//                                  "GestureDetector--${snapshot.data.status}--${snapshot.data.orderId}");
//                              snapshot.data.status ==
//                                      SocketEventStatus.delivered
//                                  ? Navigator.pushNamed(
//                                      context,
//                                      rateOrder,
//                                      arguments: snapshot.data.orderId,
//                                    )
//                                  : Navigator.pushNamed(
//                                      context, trackOrderRoute, arguments: {
//                                      orderIDKey: '${snapshot.data.orderId}'
//                                    });
//                            },
//                            child: Align(
//                              alignment: Alignment.bottomCenter,
////                              child: Text(
////                                '${snapshot.data.status}',
////                                style: Theme.of(context).textTheme.display1,
////                              ),
//                              child: UpcomingOrdersCard(
//                                acceptOrNewOrders:
//                                    snapshot.data.status.toString(),
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
//                              ),
//                            ),
//                          ),
//                        );
//                      }),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                selectedItemColor: appColor,
                onTap: (value) {
                  setState(() {
                    _bottomNavMenuIndex = value;
                  });
                  homeModel.showSortFilter(false);
                },
                // new
                type: BottomNavigationBarType.fixed,
                currentIndex: _bottomNavMenuIndex,
                // new
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.stars,
                    ),
                    title: bottomNavText(
                      S.of(context).foodstar,
                      _bottomNavMenuIndex == 0 ? appColor : Colors.grey,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search,
                    ),
                    title: bottomNavText(
                      S.of(context).search,
                      _bottomNavMenuIndex == 1 ? appColor : Colors.grey,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      children: <Widget>[
                        Icon(
                          Icons.shopping_basket,
                        ),
                        Consumer<CartQuantityViewModel>(
                          builder: (BuildContext context,
                              CartQuantityViewModel model, Widget child) {
                            return Visibility(
                              visible: _bottomNavMenuIndex != 2
                                  ? model.showBadge
                                  : false,
                              child: Positioned(
                                // top: -1.0,
                                right: 0, //-1.0,
                                child: new Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: new BoxDecoration(
                                    color: darkRed,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: new Text(
                                    '${model.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .display3
                                        .copyWith(
                                          fontSize: 9,
                                          color: white,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    title: bottomNavText(
                      S.of(context).cart,
                      _bottomNavMenuIndex == 2 ? appColor : Colors.grey,
                    ),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person_outline,
                    ),
                    title: bottomNavText(
                      S.of(context).account,
                      _bottomNavMenuIndex == 3 ? appColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Text bottomNavText(String title, Color textColor) => Text(
        title,
        style: Theme.of(context).textTheme.body1.copyWith(
              color: textColor,
            ),
      );

  int moveToNext() {
    return _bottomNavMenuIndex == 2 ? 0 : 1;
  }

  void onMenuClicked(int value, HomeRestaurantListViewModel model) {}

  Future<bool> _onWillPop() {
    AlertDialog alert = AlertDialog(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      title: Text(
        'Are you sure you want to exit the app?',
        style: Theme.of(context).textTheme.headline3,
      ),
      actions: [
        new FlatButton(
          onPressed: () async {
            await initPref();
            // this line exits the app.

            prefs.setString(SharedPreferenceKeys.latitude, "");
            prefs.setString(SharedPreferenceKeys.longitude, "");
            prefs.setString(SharedPreferenceKeys.currentLocationMarked, "");
            // socket.disconnect();
            Navigator.of(context).pop(true);

            //   model.removeLocationData();
            //  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: new Text(
            'Yes',
            style: new TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        ),
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(false),
          //  Navigator.pop(context), // this line dismisses the dialog
          child: new Text(
            'No',
            style: new TextStyle(fontSize: 18.0, color: Colors.black),
          ),
        )
      ],
    );

    return showDialog(
          context: context,
          builder: (context) => alert,
        ) ??
        false;
  }

  @override
  void dispose() {
    //socket.disconnect();
    super.dispose();
  }
}
