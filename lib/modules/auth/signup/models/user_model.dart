class UserModel {
  String username;
  String nickname;
  String email;
  String password;

  UserModel({
    required this.username,
    required this.nickname,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'nickname': nickname,
      'email': email,
      'password': password,
    };
  }
}