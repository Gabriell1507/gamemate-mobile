import 'package:gamemate/modules/profile/data/models/linked_account_model.dart';

class UserProfileModel {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final List<LinkedAccountModel> linkedAccounts;

  UserProfileModel({
    required this.id,
    required this.email,
    this.name,
    this.username,
    required this.linkedAccounts,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      username: map['username'],
      linkedAccounts: map['linkedAccounts'] != null
          ? List<LinkedAccountModel>.from(
              map['linkedAccounts'].map((x) => LinkedAccountModel.fromMap(x)))
          : [],
    );
  }
}
