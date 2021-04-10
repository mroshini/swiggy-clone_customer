import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/utils/push_notification/firebase_notification_handler.dart';
import 'package:foodstar/src/utils/push_notification/push_notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final String nxtScreen;
  final AuthViewModel model;

  SplashScreen({this.nxtScreen = login, this.model});

  @override
  _SplashScreenState createState() => _SplashScreenState(auth: model);
}

class _SplashScreenState extends State<SplashScreen> {
  var clientId;
  SharedPreferences prefs;
  final AuthViewModel auth;

  _SplashScreenState({this.auth});

  @override
  void initState() {
    super.initState();
    initialSetup();
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initialSetup() async {
    PushNotificationsManager().init();
    FirebaseNotifications(context).setUpFirebase();
//    await initPref();
//
//    clientId = prefs.getString(SharedPreferenceKeys.clientId) ?? "";
//
//    if (clientId == "") {
//      await ApiRepository(mContext: context)
//          .fetchAppEssentialCorerData(context: context);
//    } else {}

    Future.delayed(
      Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, deviceRegister);
        //   Navigator.pushReplacementNamed(context, mapRoute);
//        Navigator.of(context).pop();
//        if ((prefs.getBool(SharedPreferenceKeys.onboard) ?? false) &&
//            auth.authState == AuthState.onBoard) {
//          Navigator.pushNamed(context, login); //login
//        } else if (auth.authState == AuthState.authenticated ||
//            auth.authState == AuthState.authSkiped) {
//          Navigator.pushNamed(context, mainHome); //mainHome
//        } else {
//          Navigator.pushNamed(context, onBoard); //onBoard
//        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    getBuildContext(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}
