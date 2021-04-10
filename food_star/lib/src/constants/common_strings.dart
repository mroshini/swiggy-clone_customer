class CommonStrings {
  static final RegExp mobileRegEx = RegExp(r'(^(?:[+0]9)?[0-9]{10,11}$)');
  static final RegExp emailRegEx = RegExp(
      "^[a-zA-Z0-9.!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*\$");

  static const appName = 'FoodStar';
  static const myOrders = 'My Orders';
  static const favourites = 'My Favourites';
  static const manageAddress = 'Manage Address';
  static const payment = "Payment";
  static const changePassword = "Change Password";
  static const changeLanguage = "Change Language";
  static const changeCurrency = "Change Currency";
  static const inviteFriends = "Invite Friends";
  static const privacyPolicy = "Privacy Policy";
  static const termsOfService = "Terms Of Service";
  static const account = "Account";
  static const general = "General";
  static const LookAtThis = "Look at this!";
  static const restaurantLinkDownloadNow =
      "Order Food Now from your favourite Restaurant! - Restaurant Link Download Now";

  static const inviteFriendsShareContent =
      "Order your Favourite Food Now! Door Step Delivery. Download Now ";
  static const notesSavedSuccessfully = "Notes Saved Successfully";
  static const kms = "kms";
  static const foodItemShare = "Love this Food! Wanna taste, Order now!";
  static const unServicable = "Unserviceable";
  static const foodItemNotAvailable = "Fooditem not available";
  static const someOfFoodItemsNotAvailable = "Some of Fooditems not available";
  static const restaurantNotAvailable = 'Restaurant not available';
  static const foodSpaceItemNotAvailable = "Food item not available";
  static const notAvailable = 'not available';
  static const noInternet = 'No Internet Connection';
  static const freeDelivery = 'free delivery';
  static const applyCoupons = 'Apply Coupons';
  static const pleaseWait = 'Please wait';

  static const cash = 'Cash';
  static const onlinePayment = 'Online Payment';
  static const proceedToPay = 'Proceed to pay';

  static const minimumOrderAmount = 'You should buy the food for at least';
  static const choosePaymentType = 'Choose Payment Method';
  static const selectAddress = 'Select Address';
  static const trackYourOrder = 'Track your Order';
  static const trackYourOrders = 'Track your Orders';
  static const wantToRemoveFoodItems = 'Want to remove food items';
  static const chooseAddress = 'Choose Address';
  static const offerDiscount = 'Offers Discount';
  static const tax = 'Tax';
  static const deliveryCharges = 'Delivery Charges';
  static const deliveryChargeTax = 'Delivery Charge Tax';
  static const deliveryChargeDiscount = 'Delivery Discount';
  static const couponDiscount = 'Coupons Discount';
  static const originalPrice = 'Original Price';
}
