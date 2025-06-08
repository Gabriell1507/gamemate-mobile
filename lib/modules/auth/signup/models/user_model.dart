import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String nickname;
  final String email;
  final String password;

  UserModel({
    required this.username,
    required this.nickname,
    required this.email,
    required this.password,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'email': email,
      'password': password,
      'uid': uid,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      nickname: map['nickname'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  //Método copyWith
  UserModel copyWith({
    String? uid,
    String? username,
    String? nickname,
    String? email,
    String? password,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}