import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodstar/generated/l10n.dart';
import 'package:foodstar/router.dart';
import 'package:foodstar/src/constants/common_strings.dart';
import 'package:foodstar/src/core/models/api_models/cart_action_api_model.dart';
import 'package:foodstar/src/core/models/api_models/cart_bill_detail_api_model.dart';
import 'package:foodstar/src/core/models/api_models/favorites_restaurant_api_model.dart';
import 'package:foodstar/src/core/models/api_models/food_items_api_model.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/api_models/my_orders_api_model.dart';
import 'package:foodstar/src/core/models/api_models/restaurant_details_api_model.dart';
import 'package:foodstar/src/core/models/api_models/saved_address_api_model.dart';
import 'package:foodstar/src/core/models/api_models/search_api_model.dart';
import 'package:foodstar/src/core/models/api_models/socket_data_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/auth/auth_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_bill_detail_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/cart_quantity_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/common/theme_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/home_restaurant_list_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/language_changer.dart';
import 'package:foodstar/src/core/provider_viewmodels/rate_your_order_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/restaurant_details_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/saved_address_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/search_view_model.dart';
import 'package:foodstar/src/core/provider_viewmodels/track_order_view_model.dart';
import 'package:foodstar/src/core/service/api_base_helper.dart';
import 'package:foodstar/src/core/socket/listen_socket_event.dart';
import 'package:foodstar/src/ui/res/style.dart';
import 'package:foodstar/src/ui/splash_screen.dart';
import 'package:foodstar/src/utils/network_aware/connectivity_service.dart';
import 'package:hive/hive.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

//void main() => runApp(MyApp());
//      DevicePreview(
//        enabled: !kReleaseMode,
//        builder: (context) => MyApp(),
//      ),

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ARestaurantAdapter());
  Hive.registerAdapter(AvailabilityAdapter());
  Hive.registerAdapter(AAddressAdapter());
  Hive.registerAdapter(AOrderAdapter());
  Hive.registerAdapter(FoodAvailableCountAdapter());
  Hive.registerAdapter(RestaurantInfoAdapter());
  Hive.registerAdapter(CartActionApiModelAdapter());
  Hive.registerAdapter(CartQuantityPriceAdapter());
  Hive.registerAdapter(CommonCatFoodItemAdapter());
  Hive.registerAdapter(ACommonFoodItemAdapter());
  Hive.registerAdapter(CartDetailAdapter());
  Hive.registerAdapter(HomeRestaurantListApiModelAdapter());
  Hive.registerAdapter(AFilterAdapter());
  Hive.registerAdapter(FilterValueAdapter());
  Hive.registerAdapter(ASliderAdapter());
  Hive.registerAdapter(RestaurantAdapter());
  Hive.registerAdapter(RestaurantCityAdapter());
  Hive.registerAdapter(PromocodeAdapter());
  Hive.registerAdapter(RestaurantTimingAdapter());
  Hive.registerAdapter(RestaurantDataAdapter());
  Hive.registerAdapter(ACateoryAdapter());
  Hive.registerAdapter(RestaurantDetailsApiModelAdapter());
  Hive.registerAdapter(RestaurantDetailAdapter());
  Hive.registerAdapter(CartBillDetailsApiModelAdapter());
  Hive.registerAdapter(CartRestaurantDataAdapter());
  Hive.registerAdapter(ACuisinesAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // ConnectivityStatus network = Provider.of<ConnectivityStatus>(context);
    return MultiProvider(
      providers: [
        Provider.value(
          value: ApiBaseHelper(),
        ),
//        ChangeNotifierProvider(
        //          create: (context) => ConnectivityServiceModel(),
//        ),
        StreamProvider<SocketDataModel>.value(
          value: ListenSocketEvents(context: context)
              .connectionStatusController
              .stream,
        ),
        ChangeNotifierProvider(
          create: (context) => ListenSocketEvents(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (cFontext) => ThemeManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => LanguageManager(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartQuantityViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => RateYourOrderViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeRestaurantListViewModel(context: context),
        ),
//        ChangeNotifierProvider(
//          create: (context) => MapViewModel(),
//        ),

//        ChangeNotifierProvider(
//          create: (context) =>
//              RestSearchCartFoodItemViewModel(context: context),
//        ),
        ChangeNotifierProvider(
          create: (context) => SearchViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantDetailsViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => SavedAddressViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => CartBillDetailViewModel(context: context),
        ),
        ChangeNotifierProvider(
          create: (context) => TrackOrderViewModel(context: context),
        ),
        StreamProvider<ConnectivityStatus>.value(
          value: ConnectivityService(context: context)
              .connectionStatusController
              .stream,
        ),
      ],
      child: Consumer3<ThemeManager, LanguageManager, AuthViewModel>(
        builder: (context, appTheme, locale, auth, child) {
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.white, // navigation bar color
              statusBarColor: Colors.white, // status bar color
              statusBarIconBrightness:
                  Brightness.dark, // status bar icons' color
              systemNavigationBarIconBrightness:
                  Brightness.dark, //navigation bar icons' color
            ),
          );
          return OverlaySupport(
            child: MaterialApp(
              title: CommonStrings.appName,
              debugShowCheckedModeBanner: false,
              theme: appTheme.darkMode ? dark : light,
              // builder: DevicePreview.appBuilder,
              onGenerateRoute: RouterNavigation.generateRoute,
              //Router().generateRoute,
              locale: locale.appLocale,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback:
                  (Locale locale, Iterable<Locale> supportedLocales) {
                return locale;
              },
              supportedLocales: S.delegate.supportedLocales,
              home: SplashScreen(
                model: auth,
              ),
            ),
          );
        },
      ),
    );
  }
}
