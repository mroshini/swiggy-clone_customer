import 'dart:io';

import 'package:device_info/device_info.dart';
//import 'package:device_info/device_info.dart';

String fetchTargetPlatform() {
  if (Platform.isAndroid) {
    return 'android';
  } else if (Platform.isIOS) {
    return 'Ios';
  } else {
    return 'android';
  }
}

Future<String> fetchDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  var androidId;
  if (Platform.isAndroid) {
    return androidInfo.androidId.toString();
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.systemVersion.toString();
  } else {
    return '';
  }
}
