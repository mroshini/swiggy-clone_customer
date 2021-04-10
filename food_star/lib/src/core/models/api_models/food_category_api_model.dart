class FoodCategoryItemsApiModel {
  List<ACategoryItems> aCategoryItems;

  FoodCategoryItemsApiModel({this.aCategoryItems});

  FoodCategoryItemsApiModel.fromJson(Map<String, dynamic> json) {
    if (json['aCategoryItems'] != null) {
      aCategoryItems = new List<ACategoryItems>();
      json['aCategoryItems'].forEach((v) {
        aCategoryItems.add(new ACategoryItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.aCategoryItems != null) {
      data['aCategoryItems'] =
          this.aCategoryItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ACategoryItems {
  int mainCat;
  int foodCount;
  String mainCatName;

  ACategoryItems({this.mainCat, this.foodCount, this.mainCatName});

  ACategoryItems.fromJson(Map<String, dynamic> json) {
    mainCat = json['main_cat'];
    foodCount = json['food_count'];
    mainCatName = json['main_cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['main_cat'] = this.mainCat;
    data['food_count'] = this.foodCount;
    data['main_cat_name'] = this.mainCatName;
    return data;
  }
}
