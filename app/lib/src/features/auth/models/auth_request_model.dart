import 'dart:convert';

class AuthRequestModel {
  final String email;
  final String password;

  AuthRequestModel(this.email, this.password);

  AuthRequestModel copyWith({String? email, String? password}) {
    return AuthRequestModel(
      email ?? this.email,
      password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory AuthRequestModel.fromMap(Map<String, dynamic> map) {
    return AuthRequestModel(
      map['email'],
      map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthRequestModel.fromJson(String source) => AuthRequestModel.fromMap(json.decode(source));
}
