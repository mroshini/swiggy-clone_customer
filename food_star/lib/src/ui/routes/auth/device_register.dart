import 'package:flutter/material.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/constants/sharedpreference_keys.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/language_changer.dart';
import 'package:foodstar/src/core/service/api_repository.dart';
import 'package:foodstar/src/ui/shared/progress_indicator.dart';
import 'package:foodstar/src/utils/push_notification/push_notification_manager.dart';
import 'package:foodstar/src/utils/target_platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceRegisterScreen extends StatefulWidget {
  @override
  _DeviceRegisterScreenState createState() => _DeviceRegisterScreenState();
}

class _DeviceRegisterScreenState extends State<DeviceRegisterScreen> {
  var currencySymbol;
  SharedPreferences prefs;
  AuthViewModel auth;
  String deviceId;
  CartQuantityViewModel cartQuantityPriceProvider;
  LanguageManager lanuageModel;

  @override
  void initState() {
    super.initState();
    PushNotificationsManager().init();
    initialSetup();
    auth = Provider.of<AuthViewModel>(context, listen: false);
    cartQuantityPriceProvider =
        Provider.of<CartQuantityViewModel>(context, listen: false);
    lanuageModel = Provider.of<LanguageManager>(context, listen: false);
  }

  initPref() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  initialSetup() async {
    await initPref();
    deviceId = await fetchDeviceId();
    currencySymbol = prefs.getString(SharedPreferenceKeys.currencySymbol) ?? "";

//    ApiRepository(mContext: context).getCartQuantityWhileOpenApp({
//      userIdKey: prefs.getString(SharedPreferenceKeys.userId) ?? "",
//      deviceIDKey: deviceId,
//    }).then((value) => {
//      if (value != null)
//        {
//
//          cartQuantityPriceProvider.updateCartQuantity(value.aCart, false),
//        },
//      showLog("initialSetup -- ${value.aCart}"),
//  });

    showLog("lanuageModel-- ${lanuageModel.appLocale}");

    S.load(lanuageModel.appLocale);

    if (currencySymbol == "") {
      await ApiRepository(mContext: context)
          .fetchAppEssentialCorerData(context: context);
    } else {}

    // Navigator.of(context).pop();
    if ((prefs.getBool(SharedPreferenceKeys.onboard) ?? false) &&
        auth.authState == AuthState.onBoard) {
      Navigator.pushReplacementNamed(context, login); //login
    } else if (auth.authState == AuthState.authenticated ||
        auth.authState == AuthState.authSkiped) {
      Navigator.pushReplacementNamed(context, mainHome); //mainHome
    } else {
      Navigator.pushReplacementNamed(context, onBoard); //onBoard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: showProgress(context),
      ),
    );
  }
}
