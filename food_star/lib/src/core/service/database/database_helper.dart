import 'dart:io';

import 'package:foodstar/src/constants/api_urls.dart';
import 'package:foodstar/src/core/models/api_models/already_searched_keyword_model.dart';
import 'package:foodstar/src/core/models/api_models/home_restaurant_list_api_model.dart';
import 'package:foodstar/src/core/models/db_model/country_code_db_model.dart';
import 'package:foodstar/src/core/models/db_model/image_db_model.dart';
import 'package:foodstar/src/core/models/db_model/profile_db_model.dart';
import 'package:foodstar/src/core/service/database/database_statics.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _databaseName = "MyDatabase.db";

  static final _databaseVersion = 1;

  // make this a singleton class

  DBHelper._privateConstructor();

  static final DBHelper instance = DBHelper._privateConstructor();

  // only have a single app-wide reference to the database

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // lazily instantiate the db the first time it is accessed

    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute("DROP TABLE IF EXISTS ${DbStatics.createCountryTable}");
    await db.execute("DROP TABLE IF EXISTS ${DbStatics.createProfileTable}");
    await db.execute("DROP TABLE IF EXISTS ${DbStatics.createImageTable}");
    await db.execute(
        "DROP TABLE IF EXISTS ${DbStatics.createTopAndRecentSearchedKeyWordsTable}");
    await db
        .execute("DROP TABLE IF EXISTS ${DbStatics.createSortAndFilterTable}");
    await db.execute("DROP TABLE IF EXISTS ${DbStatics.createTotalPagesTable}");
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(DbStatics.createCountryTable);
    await db.execute(DbStatics.createProfileTable);
    await db.execute(DbStatics.createImageTable);
    await db.execute(DbStatics.createTopAndRecentSearchedKeyWordsTable);
    await db.execute(DbStatics.createSortAndFilterTable);
    await db.execute(DbStatics.createTotalPagesTable);
  }

  Future<void> insert(dynamic row, dynamic tableName) async {
    Database db = await instance.database;

    showLog('table  $row');

    if (tableName == DbStatics.tableProfile) {
      await db.delete(tableName);
    }
    var inserted = await db.insert(tableName, row,
        conflictAlgorithm: ConflictAlgorithm.replace);
    showLog('table row inserted $inserted');
    showLog('table row inserted :: TABLE_NAME: $tableName :: VALUES: $row');
  }

  deleteTableRecordsAfterLogout(dynamic tableName) async {
    Database db = await instance.database;
    await db.delete(tableName);
  }

  Future<AlreadySearchedKeywordsApiModel>
      getTopAndRecentlySearchedKeywords() async {
    Database db = await instance.database;
    List<Search> topSearchers;
    List<Search> recentSearchers;

//    var topSearchersMap =
//    await db.query(DbStatics.tableTopAndRecentSearchedKeyWords,
//        columns: [
//          DbStatics.searchedKeyWordId,
//          DbStatics.searchedKeyWord,
//          DbStatics.searchedKeyWordRestaurantId,
//          DbStatics.searchedKeyWordFoodId
//        ],
//        where: '${DbStatics.searchedKeyWordType} = ?',
//        whereArgs: [1]);

    var topSearchersMap =
        await db.query('${DbStatics.tableTopAndRecentSearchedKeyWords}');
    topSearchers = List.generate(topSearchersMap.length, (i) {
      return Search(
        id: topSearchersMap[i]['${DbStatics.searchedKeyWordId}'],
        keyword: topSearchersMap[i]['${DbStatics.searchedKeyWord}'],
        restaurantId: topSearchersMap[i]
            ['${DbStatics.searchedKeyWordRestaurantId}'],
        foodId: topSearchersMap[i]['${DbStatics.searchedKeyWordFoodId}'],
      );
    });

//    var topSearchersMap =
//        await db.query(DbStatics.tableTopAndRecentSearchedKeyWords,
//            columns: [
//              DbStatics.searchedKeyWordId,
//              DbStatics.searchedKeyWord,
//              DbStatics.searchedKeyWordRestaurantId,
//              DbStatics.searchedKeyWordFoodId
//            ],
//            where: '${DbStatics.searchedKeyWordType} = ?',
//            whereArgs: [1]);
//
//    var recentSearchersMap =
//        await db.query(DbStatics.tableTopAndRecentSearchedKeyWords,
//            columns: [
//              DbStatics.searchedKeyWordId,
//              DbStatics.searchedKeyWord,
//              DbStatics.searchedKeyWordRestaurantId,
//              DbStatics.searchedKeyWordFoodId
//            ],
//            where: '${DbStatics.searchedKeyWordType} = ?',
//            whereArgs: [2]);
//
//    topSearchers = List.generate(topSearchersMap.length, (i) {
//      return Search(
//        id: topSearchersMap[i]['${DbStatics.searchedKeyWordId}'],
//        keyword: topSearchersMap[i]['${DbStatics.searchedKeyWord}'],
//        restaurantId: topSearchersMap[i]
//            ['${DbStatics.searchedKeyWordRestaurantId}'],
//        foodId: topSearchersMap[i]['${DbStatics.searchedKeyWordFoodId}'],
//      );
//    });
//
//    recentSearchers = List.generate(recentSearchersMap.length, (i) {
//      return Search(
//        id: recentSearchersMap[i]['${DbStatics.searchedKeyWordId}'],
//        keyword: recentSearchersMap[i]['${DbStatics.searchedKeyWord}'],
//        restaurantId: recentSearchersMap[i]
//            ['${DbStatics.searchedKeyWordRestaurantId}'],
//        foodId: recentSearchersMap[i]['${DbStatics.searchedKeyWordFoodId}'],
//      );
//    });
    return AlreadySearchedKeywordsApiModel(
      aTopSearch: topSearchers,
      aRecentSearch: topSearchers,
    );
  }

  deleteRecordFromTable(String tableName) async {
    Database db = await instance.database;

    await db.delete(tableName);
  }

  Future<CountryCodeDBModel> getCountriesDetails() async {
    Database db = await instance.database;
    List<Countries> countryMap;

    var countriesNameMap = await db.query('${DbStatics.tableCountryCode}');

    showLog("countriesNameMap -${countriesNameMap}");

    countryMap = List.generate(countriesNameMap.length, (i) {
      return Countries(
        id: countriesNameMap[i]['${DbStatics.countryID}'],
        name: countriesNameMap[i]['${DbStatics.countryName}'],
        phoneCode: countriesNameMap[i]['${DbStatics.countryCode}'],
      );
    });

    showLog("countryMap -${countryMap[0].name}");

    return CountryCodeDBModel(aCountries: countryMap);
  }

  Future<ImagesDbModel> getSliderImages() async {
    final db = await database;
    List<Images> images;

    List<Map> results = await db.query(DbStatics.tableImages,
        columns: [
          DbStatics.imageId,
          DbStatics.imageImage,
          DbStatics.imageSrc,
          DbStatics.imageType
        ],
        where: '${DbStatics.imageType} = ?',
        whereArgs: [1]);

    if (results.length > 0) {
      images = List.generate(results.length, (i) {
        return Images(
          id: results[i]['${DbStatics.imageId}'],
          image: results[i]['${DbStatics.imageImage}'],
          src: results[i]['${DbStatics.imageSrc}'],
          type: results[i]['${DbStatics.imageType}'],
        );
      });

      return ImagesDbModel(foodImages: images);
    }
    return null;
  }

  Future<UserProfileDbModel> getProfileData() async {
    final db = await database;

    var response = await db.query('${DbStatics.tableProfile}');

    var userData = response.length == 0
        ? null
        : UserProfileDbModel(
            username: response[0]['${DbStatics.profileName}'],
            email: response[0]['${DbStatics.profileEmail}'],
            phoneCode: response[0]['${DbStatics.phoneCode}'],
            phoneNumber: response[0]['${DbStatics.profileNumber}'],
            emailVerified: response[0]
                ['${DbStatics.profileEmailVerifiedStatus}'],
            updatedAt: response[0]['${DbStatics.profileUpdatedAt}'],
            src: response[0]['${DbStatics.profileImageSrc}'],
            socialType: response[0]['${DbStatics.profileSocialType}']);

    // showLog("getProfileData --${response[0]["${DbStatics.profileName}"]}");

    return userData;
  }

  Future<int> getTotalPagesForUrl(String url) async {
    final db = await database;
    int totalPages = 0;

    List<Map> results = await db.query(DbStatics.tableTotalPages,
        columns: [
          DbStatics.totalPagesNumbers,
        ],
        where: '${DbStatics.totalPageUrl} = ?',
        whereArgs: [url]);
    if (results.length > 0) {
      showLog("getTotalPagesForUrl -- ${results}");
      totalPages = results[0]['${DbStatics.totalPagesNumbers}'];
    }
    return totalPages;
  }

  getSortFilterData() async {
    final db = await database;

    var response = await db.query('${DbStatics.tableSortAndFilter}');

    showLog("getSortFilterData -- ${response}");

    if (response.length > 0) {
      List.generate(response.length, (filterIndex) {
        return AFilter(
          filterName: response[filterIndex]['${DbStatics.sortFilterName}'],
          filterValues: List.generate(
            response.length,
            (filterValueIndex) {
              return FilterValue(
                  // id: response[filterIndex][''],
                  );
              // response[i]['${DbStatics.sortFilterName}']
            },
          ),
        );
      });
    }
    // showLog("getProfileData --${response[0]["${DbStatics.profileName}"]}");

    //return userData;
  }
}
