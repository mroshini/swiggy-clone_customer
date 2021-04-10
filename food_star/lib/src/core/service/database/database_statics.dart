class DbStatics {
  ///common
  static const _createTable = 'CREATE TABLE';
  static const _integer = 'INTEGER';
  static const _text = 'TEXT';
  static const _primaryKey = 'PRIMARY KEY';

  static const id = 'id';
  static const name = 'name';
  static const url = 'url';
  static const userRandomId = 'user_random_id';
  static const lastUpdatedAt = 'updated_at';
  static const phoneCode = 'phone_code';

  /// countries Table

  static const tableCountryCode = 'countryCode';
  static const countryID = '$id';
  static const countryName = '$name';
  static const countryCode = '$phoneCode';

  static const createCountryTable =
      '$_createTable $tableCountryCode ($countryID $_integer $_primaryKey,'
      '$countryName $_text, $countryCode $_integer)';

  // ProfileTable
  static const tableProfile = 'profile';
  static const profileName = 'username';
  static const profileEmail = 'email';
  static const profileNumber = 'phone_number';
  static const profileImageSrc = 'src';
  static const profilePhoneCode = '$phoneCode';
  static const profileEmailVerifiedStatus = 'email_verified';
  static const profileSocialType = 'social_type';
  static const profileUpdatedAt = '$lastUpdatedAt';

  static const createProfileTable = '$_createTable $tableProfile '
      '($profileName $_text $_primaryKey,$profileEmail $_text,'
      '$profileNumber $_integer, $profileImageSrc $_text, $profilePhoneCode $_integer,'
      '$profileEmailVerifiedStatus $_integer,$profileSocialType $_text,$profileUpdatedAt $_text)';

  //Images
  static const tableImages = 'images';
  static const imageId = '$id';
  static const imageImage = 'image';
  static const imageSrc = 'src';
  static const imageType = 'type';

  // type of image 1 - slider, 2-restaurant image, 3-food items image

  static const createImageTable = '$_createTable $tableImages'
      ' ($imageId $_integer $_primaryKey,$imageImage $_text, $imageSrc $_text, $imageType $_integer)';

  //frequently searched data

  static const tableTopAndRecentSearchedKeyWords = 'searched_keywords';
  static const searchedKeyWordId = '$id';
  static const searchedKeyWord = 'keyword';
  static const searchedKeyWordRestaurantId = 'restaurant_id';
  static const searchedKeyWordFoodId = 'food_id'; // dish id,
  static const searchedKeyWordType =
      'type'; // 1 - top search, 2 - recent search

  static const createTopAndRecentSearchedKeyWordsTable =
      '$_createTable $tableTopAndRecentSearchedKeyWords ($searchedKeyWordId '
      '$_integer $_primaryKey,$searchedKeyWord $_text,$searchedKeyWordRestaurantId $_integer,'
      '$searchedKeyWordFoodId $_integer,$searchedKeyWordType $_integer)';

  // sort and filter table

  static const tableSortAndFilter = 'sort_filter';
  static const sortFilterID = '$id';
  static const sortFilterValueName = 'name';
  static const sortFilterName = 'filter_name';
  static const createSortAndFilterTable =
      '$_createTable $tableSortAndFilter ($sortFilterID $_integer $_primaryKey,$sortFilterValueName $_text,$sortFilterName $_text)';

  static const tableTotalPages = 'total_pages';
  static const totalPageId = '$id';
  static const totalPageUrl = '$url';
  static const totalPagesNumbers = 'totalPages';
  static const createTotalPagesTable =
      '$_createTable $tableTotalPages ($totalPageId  $_integer $_primaryKey, $totalPageUrl $_text ,$totalPagesNumbers $_integer)';
}
