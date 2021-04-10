class TotalPagesModel {
  int id;
  int totalPages;
  String url;

  TotalPagesModel({this.id, this.totalPages, this.url});

  TotalPagesModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] == null ? 0 : json['id'],
        totalPages = json['id'] == null ? 0 : json['totalPages'],
        url = json['url'] == null ? "" : json['url'];

  Map<String, dynamic> toJson() => {
        'id': id == null ? 0 : id,
        'totalPages': totalPages == null ? 0 : totalPages,
        'url': url == null ? "" : url
      };
}
