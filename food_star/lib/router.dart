import 'package:flutter/material.dart';
import 'package:foodstar/src/constants/route_path.dart';
import 'package:foodstar/src/ui/routes/auth/change_password.dart';
import 'package:foodstar/src/ui/routes/auth/device_register.dart';
import 'package:foodstar/src/ui/routes/auth/forgot_password_screen.dart';
import 'package:foodstar/src/ui/routes/auth/login_screen.dart';
import 'package:foodstar/src/ui/routes/auth/otp_screen.dart';
import 'package:foodstar/src/ui/routes/auth/register_screen.dart';
import 'package:foodstar/src/ui/routes/auth/reset_password_screen.dart';
import 'package:foodstar/src/ui/routes/cart/apply_available_coupons.dart';
import 'package:foodstar/src/ui/routes/cart/cart.dart';
import 'package:foodstar/src/ui/routes/cart/select_payment_method.dart';
import 'package:foodstar/src/ui/routes/food_star_screen.dart';
import 'package:foodstar/src/ui/routes/location_maps/confirm_address_bottom_sheet.dart';
import 'package:foodstar/src/ui/routes/location_maps/manage_address.dart';
import 'package:foodstar/src/ui/routes/location_maps/map_confirm_proceed_address.dart';
import 'package:foodstar/src/ui/routes/location_maps/search_location.dart';
import 'package:foodstar/src/ui/routes/location_maps/show_delivery_location_map_screen.dart';
import 'package:foodstar/src/ui/routes/location_maps/show_location_map.dart';
import 'package:foodstar/src/ui/routes/location_maps/user_location.dart';
import 'package:foodstar/src/ui/routes/main_home.dart';
import 'package:foodstar/src/ui/routes/my_account/change_language.dart';
import 'package:foodstar/src/ui/routes/my_account/edit_profile.dart';
import 'package:foodstar/src/ui/routes/my_account/favorites.dart';
import 'package:foodstar/src/ui/routes/my_account/invite_friends.dart';
import 'package:foodstar/src/ui/routes/my_account/rate_your_order.dart';
import 'package:foodstar/src/ui/routes/my_account/terms_and_policy.dart';
import 'package:foodstar/src/ui/routes/onboard_pageview.dart';
import 'package:foodstar/src/ui/routes/orders/my_orders.dart';
import 'package:foodstar/src/ui/routes/orders/success_order.dart';
import 'package:foodstar/src/ui/routes/orders/track_success_order.dart';
import 'package:foodstar/src/ui/routes/orders/tracking/map_home_route.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_details_root.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_info_screen.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_map_view.dart';
import 'package:foodstar/src/ui/routes/restaurant_details/restaurant_menu_list_view.dart';
import 'package:foodstar/src/ui/routes/search/search_restaurant_dish.dart';
import 'package:foodstar/src/ui/routes/search/sort_filter_screen.dart';

class RouterNavigation {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case restaurantMenuListScreen:
        return MaterialPageRoute(
          builder: (_) => RestaurantMenuListScreen(
            menuItemsData: settings.arguments,
          ),
        );
      case rateOrder:
        return MaterialPageRoute(
          builder: (_) => RateYourOrderScreen(
            orderID: settings.arguments,
          ),
        );
      case mapRoute:
        return MaterialPageRoute(
          builder: (_) => MapHomeRoute(),
        );
      case applyCoupons:
        return MaterialPageRoute(
          builder: (_) => ApplyAvailableCoupons(),
        );
      case addPaymentScreen:
        return MaterialPageRoute(
          builder: (_) => SelectPaymentScreen(paymentInfo: settings.arguments),
        );
      case restaurantInfoScreen:
        return MaterialPageRoute(
          builder: (_) =>
              RestaurantInfoScreen(restaurantData: settings.arguments),
        );
      case restaurantMapView:
        return MaterialPageRoute(
          builder: (_) =>
              RestaurantMapViewScreen(restaurantData: settings.arguments),
        );
      case deviceRegister:
        return MaterialPageRoute(
          builder: (_) => DeviceRegisterScreen(),
        );
      case userLocationScreen:
        return MaterialPageRoute(
          builder: (_) => UserLocationScreen(mapValue: settings.arguments),
        );
      case trackOrderRoute:
        return MaterialPageRoute(
          builder: (_) => TrackSuccessOrderScreen(orderID: settings.arguments),
        );
      case changeUserAddressScreen:
        return MaterialPageRoute(
          builder: (_) => AddAddressScreen(fromWhichScreen: settings.arguments),
        );
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) =>
              AddAddressScreenOne(fromWhichScreen: settings.arguments),
        );
      case showLocationMapScreen:
        return MaterialPageRoute(
          builder: (_) => ShowLocationMapScreen(
            screenStatus: settings.arguments,
          ),
        );
      case onBoard:
        return MaterialPageRoute(
          builder: (_) => OnBoardScreen(),
        );
      case successOrder:
        return MaterialPageRoute(
          builder: (_) => SuccessOrderScreen(
            orderID: settings.arguments,
          ),
        );
      case termsOfService:
        return MaterialPageRoute(
          builder: (_) => TermsOfServiceScreen(screenName: settings.arguments),
        );
      case inviteFriendsScreen:
        return MaterialPageRoute(
          builder: (_) => InviteFriendsScreen(),
        );
      case manageAddress:
        return MaterialPageRoute(
          settings: RouteSettings(name: manageAddress),
          builder: (_) => ManageAddressScreen(
            fromHomeOrCartDetailsScreen: settings.arguments,
          ),
        );
      case editProfile:
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(
            profileInfo: settings.arguments,
          ),
        );
      case language:
        return MaterialPageRoute(
          builder: (_) => ChangeLanguageScreen(),
        );
      case myOrdersRoute:
        return MaterialPageRoute(
          builder: (_) => MyOrdersScreen(),
        );
      case favorites:
        return MaterialPageRoute(
          builder: (_) => FavoritesScreen(),
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );
      case otp:
        return MaterialPageRoute(
          builder: (_) => OtpScreen(otpInfo: settings.arguments),
        );
      case forgetPassword:
        return MaterialPageRoute(
          builder: (_) => ForgotPasswordScreen(),
        );
      case changePassword:
        return MaterialPageRoute(
          builder: (_) => ChangePassword(),
        );
      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(args: settings.arguments),
        );
      case sortFilter:
        return MaterialPageRoute(
          builder: (_) => SortFilterScreen(),
        );
      case mainHome:
        return MaterialPageRoute(
          settings: RouteSettings(name: mainHome),
          builder: (_) =>
              HomeScreen(selectedIndexFromRoutedScreen: settings.arguments),
        );
      case foodStarHome:
        return MaterialPageRoute(
          builder: (_) => FoodStarScreen(),
        );
      case search:
        return MaterialPageRoute(
          builder: (_) => SearchScreen(),
        );
      case cart:
        return MaterialPageRoute(
          builder: (_) => CartScreen(showArrow: settings.arguments),
        );
      case restaurantDetails:
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailScreen(
            restaurantDetailInfo: settings.arguments,
          ),
        );
      case searchLocation:
        return MaterialPageRoute(
          builder: (_) => SearchLocationScreen(
            fromWhichScreen: settings.arguments,
          ),
        );
      case deliveryLocationMapView:
        return MaterialPageRoute(
          builder: (_) => DeliveryLocationMapView(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route found for the name $settings.name',
              ),
            ),
          ),
        );
    }
  }
}
