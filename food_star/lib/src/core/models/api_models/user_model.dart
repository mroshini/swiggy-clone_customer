class UserModel {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final bool status;
  final bool isActive;

  UserModel({this.id, this.name, this.mobile, this.email, this.status, this.isActive});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id'],
    name: json['name'],
    mobile: json['mobile'],
    email: json['email'],
    status: json['status'],
    isActive: json['isActive'],
  );

  Map<String, dynamic> toJson() => {
      'name': name,
      'isActive': isActive,
      'status': status,
      '_id': id,
      'mobile': mobile,
      'email': email,
  };
}