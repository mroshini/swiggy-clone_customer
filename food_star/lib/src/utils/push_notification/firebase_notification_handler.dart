import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/api_params_keys.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    showLog('on background data $message');

    return data;
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    showLog('on background data $message');

    return notification;
  }

  //return null;
  // Or do other work.
}

BuildContext _buildContext;

getBuildContext(BuildContext context) {
  _buildContext = context;
}

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  BuildContext _context;
  var notification;

  List<String> additionalData = [];
  String navigateToRespectivePage = "";
  String orderID = "0";

  FirebaseNotifications(this._context);

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  splitData(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      showLog('on message data $message');

      additionalData = data['additional_data'].toString().split("-");

      navigateToRespectivePage = additionalData[1];
      orderID = additionalData[0];
      // _sendNotificationSeenStatusToServer(data);
    }
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      showLog('firebase token: $token');
    });

    _firebaseMessaging.onTokenRefresh.listen((token) async {
      showLog('firebase refreshed token: $token');

      var prefs = await SharedPreferences.getInstance();

      if (token != prefs.getString('${SharedPreferenceKeys.firebaseToken}') ??
          "") {
        showLog('inside firebase token refresh');
        prefs.setString('${SharedPreferenceKeys.firebaseToken}', token);

        //  _sendFirebaseTokenToServer(token);
      } else {
        showLog('inside firebase token refresh 2');
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showLog('on message $message');
        final dynamic data = message['data'];
//        if (message.containsKey('data')) {
//          final dynamic data = message['data'];
//          showLog('on message data $message');
//
//          additionalData=data['additional_data'].toString().split("-");
//
//          navigateToRespectivePage=additionalData[1];
//          orderID=additionalData[0];
//          // _sendNotificationSeenStatusToServer(data);
//        }

        splitData(message);

        if (Platform.isAndroid) {
          notification = PushNotificationMessage(
            title: message['notification']['title'],
            body: message['notification']['body'],
          );
        }

        showLog(
            "PushNotificationMessage: ${notification.body}--${notification.title}");
        if (Platform.isIOS) {
          notification = PushNotificationMessage(
            title: message['aps']['alert']['title'],
            body: message['aps']['alert']['body'],
          );
        }
//        showSimpleNotification(
//          Container(
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: [
//                Text(
//                  notification.title,
//                ),
//                verticalSizedBoxFive(),
//                Text(
//                  notification.body,
//                ),
//                verticalSizedBoxFive(),
//              ],
//            ),
//          ),
//          position: NotificationPosition.top,
//          background: Colors.white,
//        );
        showOverlayNotification((context) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, trackOrderRoute,
                  arguments: {orderIDKey: '$orderID'});
            },
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: SafeArea(
                child: ListTile(
                  leading: SizedBox.fromSize(
                      size: const Size(40, 40),
                      child: ClipOval(
                          child: Container(
                        child: Image.asset('assets/images/logo.png'),
                      ))),
                  title: Text(notification.title),
                  subtitle: Text(notification.body),
                  trailing: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        OverlaySupportEntry.of(context).dismiss();
                      }),
                ),
              ),
            ),
          );
        }, duration: Duration(milliseconds: 5000));
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onResume: (Map<String, dynamic> message) async {
        if (message.containsKey('data')) {
          final dynamic data = message['data'];
          showLog('onresumedata $message--${data['additional_data']}');
          splitData(message);
//          Navigator.pushNamed(_buildContext, trackOrderRoute,
//              arguments: {orderIDKey: '${data['additional_data']}'});
          Navigator.pushNamed(
            _buildContext,
            mainHome,
          );
          //   _sendNotificationSeenStatusToServer(data);
        }
      },

      onLaunch: (Map<String, dynamic> message) async {
        if (message.containsKey('data')) {
          final dynamic data = message['data'];
          showLog('on launch data $message');
          splitData(message);
//          Navigator.pushNamed(_buildContext, trackOrderRoute,
//              arguments: {orderIDKey: '${data['additional_data']}'});
          Navigator.pushNamed(
            _buildContext,
            mainHome,
          );
          //  _sendNotificationSeenStatusToServer(data);
        }
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}

class PushNotificationMessage {
  final String title;
  final String body;

  PushNotificationMessage({
    @required this.title,
    @required this.body,
  });
}
