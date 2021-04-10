//class UserProfileDbModel {
//  User user;
//
//  UserProfileDbModel({this.user});
//
//  UserProfileDbModel.fromJson(Map<String, dynamic> json) {
//    user = json['user'] != null ? new User.fromJson(json['user']) : null;
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    if (this.user != null) {
//      data['user'] = this.user.toJson();
//    }
//    return data;
//  }
//}

class UserProfileDbModel {
  String username;
  String email;
  int phoneCode;
  int phoneNumber;
  int emailVerified;
  String updatedAt;
  String src;
  String socialType;

  UserProfileDbModel(
      {this.username,
      this.email,
      this.phoneCode,
      this.phoneNumber,
      this.emailVerified,
      this.updatedAt,
      this.src,
      this.socialType});

  UserProfileDbModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    phoneCode = json['phone_code'];
    phoneNumber = json['phone_number'];
    emailVerified = json['email_verified'];
    updatedAt = json['updated_at'];
    src = json['src'];
    socialType = json['social_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone_code'] = this.phoneCode;
    data['phone_number'] = this.phoneNumber;
    data['email_verified'] = this.emailVerified;
    data['updated_at'] = this.updatedAt;
    data['src'] = this.src;
    data['social_type'] = this.socialType;
    return data;
  }
}
