library api_urls;

const int post = 1;
const int getUrl = 2;
const int put = 3;
const int multipart = 4;

const groupId = "4";
const google = 'google';
const apple = 'apple';
const userType = "user";
const isLogEnabled = true;
//const baseUrl = 'https://www.abservetechdemo.com/products/foodstar/dev/api/';
const baseUrl = 'https://abserve.tech/projects/tastyeats73/api/';
const socketUrl = 'https://abserve.tech:4003/';
//'https://www.abservetechdemo.com/products/foodstar-dev/api/';
const baseUrlGetRequest = 'abserve.tech';
const baseGetUrlPath = '/projects/tastyeats73/api/';

const coreData = 'coreDatas';
const registerUrl = 'register'; // singup
const loginUrl = 'signin'; //signin
const activeAccount = 'activeAccount';
const forgetPasswordUrl = 'forgetPasswordrequest';
const resetPasswordUrl = 'resetPassword';
const changePasswordUrl = 'user/changePassword';
const editProfileUrl = "user/editprofile";
const verifyEmailRequestUrl = "user/verifyEmailRequest";
const verifyEmailWithCode = "user/verifyEmail";
const userProfileDetails = "user/profile";
const userData = 'userDatas';

const restaurantList = 'restaurantList/home';
const restaurantDetailsUrl = 'restaurant';

//search
const savedSearchKeywords = 'savedSearchKeywords'; //alreadySearchedKeyWord
const saveSearchKeyword =
    'saveSearchKeyword'; // save search keyword clicked from searchlist
const searchRestaurantDish =
    'searchRestaurantDish'; //searchRestaurantDish with see all

const cartAction = 'cartAction';
const userFavAction = 'user/favoriteAction';

const cartBillDetail = 'viewCart';

const savedAddress = 'user/savedAddress';

const proceedOrder = 'order/insertOrder';
const savedFavorites = 'user/savedFavorites';
const editSavedAddress = 'user/manageSavedAddress';
const myOrders = 'order/orders';
const trackOrderDetails = 'order/orderDetail';
const currentOrderDetails = 'order/currentOrderDetail';
const socialLogin = 'socialLogin';
const availablePromosForUSer = 'user/userAvailablePromos';
const skipUpdateRatingUrl = 'order/updateRating';
const logoutUrl = 'user/logout';
const orderStatusChangeUrl = 'order/orderStatusChange';

const socketCreateConnection = 'create connection';
const socketPartnerRejected = 'partner rejected';
const socketOrderHandOvered = 'order handovered';
const socketBoyAccepted = 'boy accepted';
const socketOrderDelivered = 'delivered to customer';

const webUrl = 'http://abservetechdemo.com/products/foodstar-dev';
const privacyPolicyUrl =
    'https://abserve.tech/projects/tastyeats73/privacypolicy';

showLog(message) {
  if (isLogEnabled) {
    print(message);
  } else {}
}
