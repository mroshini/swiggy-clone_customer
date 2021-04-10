// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Your Location`
  String get yourLocation {
    return Intl.message(
      'Your Location',
      name: 'yourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `CONTINUE`
  String get continue_button_text {
    return Intl.message(
      'CONTINUE',
      name: 'continue_button_text',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter registered phone number or email`
  String get enterRegisteredPhoneNumberOrEmail {
    return Intl.message(
      'Enter registered phone number or email',
      name: 'enterRegisteredPhoneNumberOrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number or Email`
  String get phoneNumberOrEmail {
    return Intl.message(
      'Phone Number or Email',
      name: 'phoneNumberOrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterYourPhoneNumber {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Login Mobile Number`
  String get loginMobileNumber {
    return Intl.message(
      'Login Mobile Number',
      name: 'loginMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get enterOtp {
    return Intl.message(
      'Enter OTP',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOtp {
    return Intl.message(
      'Resend OTP',
      name: 'resendOtp',
      desc: '',
      args: [],
    );
  }

  /// `Timer`
  String get timer {
    return Intl.message(
      'Timer',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `We've sent an otp on`
  String get weHaveSentAnOtpOn {
    return Intl.message(
      'We\'ve sent an otp on',
      name: 'weHaveSentAnOtpOn',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your personal details. Worry not, they are safe with us`
  String get pleaseEnterYourPersonalDetailsWorryNotTheyAreSafe {
    return Intl.message(
      'Please enter your personal details. Worry not, they are safe with us',
      name: 'pleaseEnterYourPersonalDetailsWorryNotTheyAreSafe',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `PhoneNumber`
  String get phonenumber {
    return Intl.message(
      'PhoneNumber',
      name: 'phonenumber',
      desc: '',
      args: [],
    );
  }

  /// `email`
  String get email {
    return Intl.message(
      'email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Hi Everyone`
  String get hiEveryone {
    return Intl.message(
      'Hi Everyone',
      name: 'hiEveryone',
      desc: '',
      args: [],
    );
  }

  /// `FOODSTAR`
  String get foodstar {
    return Intl.message(
      'FOODSTAR',
      name: 'foodstar',
      desc: '',
      args: [],
    );
  }

  /// `SEARCH`
  String get search {
    return Intl.message(
      'SEARCH',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `CART`
  String get cart {
    return Intl.message(
      'CART',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `ACCOUNT`
  String get account {
    return Intl.message(
      'ACCOUNT',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Search Restaurants`
  String get searchRestaurants {
    return Intl.message(
      'Search Restaurants',
      name: 'searchRestaurants',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `RECENT SEARCHERS`
  String get recentSearchers {
    return Intl.message(
      'RECENT SEARCHERS',
      name: 'recentSearchers',
      desc: '',
      args: [],
    );
  }

  /// `TOP SEARCHERS`
  String get topSearchers {
    return Intl.message(
      'TOP SEARCHERS',
      name: 'topSearchers',
      desc: '',
      args: [],
    );
  }

  /// `Sort and Filters`
  String get sortAndFilters {
    return Intl.message(
      'Sort and Filters',
      name: 'sortAndFilters',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message(
      'Clear All',
      name: 'clearAll',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Add notes to your dish`
  String get addNotesToYourDish {
    return Intl.message(
      'Add notes to your dish',
      name: 'addNotesToYourDish',
      desc: '',
      args: [],
    );
  }

  /// `Example, make my food spicy!`
  String get exampleMakeMyFoodSpicy {
    return Intl.message(
      'Example, make my food spicy!',
      name: 'exampleMakeMyFoodSpicy',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Want to change restaurant?`
  String get wantToChangeRestaurant {
    return Intl.message(
      'Want to change restaurant?',
      name: 'wantToChangeRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `No problem! But just a heads up, we'll need to clear your current cart first`
  String get changeRestaurantBodyContent {
    return Intl.message(
      'No problem! But just a heads up, we\'ll need to clear your current cart first',
      name: 'changeRestaurantBodyContent',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Sure, go ahead`
  String get sureGoAhead {
    return Intl.message(
      'Sure, go ahead',
      name: 'sureGoAhead',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Dish Price`
  String get dishPrice {
    return Intl.message(
      'Dish Price',
      name: 'dishPrice',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Opening Hours`
  String get openingHours {
    return Intl.message(
      'Opening Hours',
      name: 'openingHours',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order again`
  String get orderAgain {
    return Intl.message(
      'Order again',
      name: 'orderAgain',
      desc: '',
      args: [],
    );
  }

  /// `Delivery details`
  String get deliveryDetails {
    return Intl.message(
      'Delivery details',
      name: 'deliveryDetails',
      desc: '',
      args: [],
    );
  }

  /// `Deliver Location`
  String get deliverLocation {
    return Intl.message(
      'Deliver Location',
      name: 'deliverLocation',
      desc: '',
      args: [],
    );
  }

  /// `We got your order`
  String get weGotYourOrder {
    return Intl.message(
      'We got your order',
      name: 'weGotYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Diver is heading to Restaurant`
  String get diverIsHeadingToRestaurant {
    return Intl.message(
      'Diver is heading to Restaurant',
      name: 'diverIsHeadingToRestaurant',
      desc: '',
      args: [],
    );
  }

  /// `Order items(s)`
  String get orderItemss {
    return Intl.message(
      'Order items(s)',
      name: 'orderItemss',
      desc: '',
      args: [],
    );
  }

  /// `Payment Details`
  String get paymentDetails {
    return Intl.message(
      'Payment Details',
      name: 'paymentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Price (estimated)`
  String get priceEstimated {
    return Intl.message(
      'Price (estimated)',
      name: 'priceEstimated',
      desc: '',
      args: [],
    );
  }

  /// `Convenience Fee`
  String get convenienceFee {
    return Intl.message(
      'Convenience Fee',
      name: 'convenienceFee',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Delivery fee`
  String get deliveryFee {
    return Intl.message(
      'Delivery fee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Discounts`
  String get discounts {
    return Intl.message(
      'Discounts',
      name: 'discounts',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Need help`
  String get needHelp {
    return Intl.message(
      'Need help',
      name: 'needHelp',
      desc: '',
      args: [],
    );
  }

  /// `Cancel order`
  String get cancelOrder {
    return Intl.message(
      'Cancel order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Search for your location`
  String get searchForYourLocation {
    return Intl.message(
      'Search for your location',
      name: 'searchForYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Use current location`
  String get useCurrentLocation {
    return Intl.message(
      'Use current location',
      name: 'useCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Saved Address`
  String get savedAddress {
    return Intl.message(
      'Saved Address',
      name: 'savedAddress',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Recent Locations`
  String get recentLocations {
    return Intl.message(
      'Recent Locations',
      name: 'recentLocations',
      desc: '',
      args: [],
    );
  }

  /// `CHANGE`
  String get change {
    return Intl.message(
      'CHANGE',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Select delivery location`
  String get selectDeliveryLocation {
    return Intl.message(
      'Select delivery location',
      name: 'selectDeliveryLocation',
      desc: '',
      args: [],
    );
  }

  /// `CONFIRM LOCATION`
  String get confirmLocation {
    return Intl.message(
      'CONFIRM LOCATION',
      name: 'confirmLocation',
      desc: '',
      args: [],
    );
  }

  /// `+ Add more`
  String get addMore {
    return Intl.message(
      '+ Add more',
      name: 'addMore',
      desc: '',
      args: [],
    );
  }

  /// `Yay! You saved`
  String get yayYouSaved {
    return Intl.message(
      'Yay! You saved',
      name: 'yayYouSaved',
      desc: '',
      args: [],
    );
  }

  /// `on this order`
  String get onThisOrder {
    return Intl.message(
      'on this order',
      name: 'onThisOrder',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `More info`
  String get moreInfo {
    return Intl.message(
      'More info',
      name: 'moreInfo',
      desc: '',
      args: [],
    );
  }

  /// `Total payment`
  String get totalPayment {
    return Intl.message(
      'Total payment',
      name: 'totalPayment',
      desc: '',
      args: [],
    );
  }

  /// `Promo`
  String get promo {
    return Intl.message(
      'Promo',
      name: 'promo',
      desc: '',
      args: [],
    );
  }

  /// `Gofood partner discount`
  String get gofoodPartnerDiscount {
    return Intl.message(
      'Gofood partner discount',
      name: 'gofoodPartnerDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Resto offer`
  String get restoOffer {
    return Intl.message(
      'Resto offer',
      name: 'restoOffer',
      desc: '',
      args: [],
    );
  }

  /// `Convenience fee is a fee for ordering through GoFood`
  String get convenienceFeeIsAFeeForOrderingThroughGofood {
    return Intl.message(
      'Convenience fee is a fee for ordering through GoFood',
      name: 'convenienceFeeIsAFeeForOrderingThroughGofood',
      desc: '',
      args: [],
    );
  }

  /// `For your ease, please make sure your order doesn't need changes.`
  String get forYourEasePleaseMakeSureYourOrderDoesntNeed {
    return Intl.message(
      'For your ease, please make sure your order doesn\'t need changes.',
      name: 'forYourEasePleaseMakeSureYourOrderDoesntNeed',
      desc: '',
      args: [],
    );
  }

  /// `Disclaimer: final price may change slightly if the restaurant has updates prices.`
  String get disclaimerFinalPriceMayChangeSlightlyIfTheRestaurantHas {
    return Intl.message(
      'Disclaimer: final price may change slightly if the restaurant has updates prices.',
      name: 'disclaimerFinalPriceMayChangeSlightlyIfTheRestaurantHas',
      desc: '',
      args: [],
    );
  }

  /// `Select payment method`
  String get selectPaymentMethod {
    return Intl.message(
      'Select payment method',
      name: 'selectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Your balance`
  String get yourBalance {
    return Intl.message(
      'Your balance',
      name: 'yourBalance',
      desc: '',
      args: [],
    );
  }

  /// `Top up`
  String get topUp {
    return Intl.message(
      'Top up',
      name: 'topUp',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Or Login With`
  String get orLoginWith {
    return Intl.message(
      'Or Login With',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `login`
  String get login {
    return Intl.message(
      'login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `OPEN`
  String get open {
    return Intl.message(
      'OPEN',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `My Favourites`
  String get myFavourites {
    return Intl.message(
      'My Favourites',
      name: 'myFavourites',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'ta'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}