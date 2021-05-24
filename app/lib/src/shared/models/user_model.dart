import 'dart:convert';

UserModel? globaUserModel;

class UserModel {
  final String name;
  final String email;
  final String token;

  UserModel({required this.name, required this.email, required this.token});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());
}
