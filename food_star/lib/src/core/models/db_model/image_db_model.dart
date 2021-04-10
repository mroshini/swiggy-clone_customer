//ImagesDbModel imagesDbModelFromJson(str) =>
//    ImagesDbModel.fromJson(json.decode(str));
//
//String imagesDbModelToJson(ImagesDbModel data) =>
//    json.encode(data.toJson());

class ImagesDbModel {
  List<Images> foodImages;

  ImagesDbModel({this.foodImages});

  ImagesDbModel.fromJson(Map<String, dynamic> json) {
    if (json['foodImages'] != null) {
      foodImages = new List<Images>();
      json['foodImages'].forEach((v) {
        foodImages.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.foodImages != null) {
      data['foodImages'] = this.foodImages.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Images {
  Images({
    this.id,
    this.image,
    this.src,
    this.type,
  });

  int id;
  String image;
  String src;
  int type;

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        id: json["id"],
        image: json["image"],
        src: json["src"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "src": src,
        "type": type,
      };
}
