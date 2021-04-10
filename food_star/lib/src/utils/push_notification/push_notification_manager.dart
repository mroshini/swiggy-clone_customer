import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  SharedPreferences prefs;

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initialized = false;

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  Future<void> init() async {
    await initPref();
    try {
      if (!_initialized) {
        // For iOS request permission first.

        _firebaseMessaging.requestNotificationPermissions();

        _firebaseMessaging.configure();

        // For testing purposes print the Firebase Messaging token

        String token = await _firebaseMessaging.getToken();

        showLog("FirebaseMessaging token: $token");

        prefs.setString(SharedPreferenceKeys.firebaseToken, token);

        _initialized = true;
      }
    } catch (e) {}
  }
}
