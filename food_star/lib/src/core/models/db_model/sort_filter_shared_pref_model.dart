class SortFilterSharedPrefModel {
  String sortBy;

  String rating;

  String cuisines;

  SortFilterSharedPrefModel();

  SortFilterSharedPrefModel.fromJson(Map<String, dynamic> json)
      : sortBy = json['sortBy'] == null ? "" : json['sortBy'],
        rating = json['rating'] == null ? "" : json['rating'],
        cuisines = json['cuisines'] == null ? "" : json['cuisines'];

  Map<String, dynamic> toJson() => {
        'sortBy': sortBy == null ? "" : sortBy,
        'rating': rating == null ? "" : rating,
        'cuisines': cuisines == null ? "" : cuisines,
      };
}
