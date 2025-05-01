class UserModel {
  String? name;
  String? email;
  String? uId;
  String? image;
  String? phone;
  bool? isEmailVerified;
  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
    this.image,
    this.isEmailVerified,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'] ?? true;
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uId': uId,
      'image': image,
      'isEmailVerified': isEmailVerified,
    };
  }
}
