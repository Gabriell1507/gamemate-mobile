import 'package:gamemate/modules/profile/data/models/linked_account_model.dart';

class ProfileStats {
  final int totalGames;
  final int totalHoursPlayed;

  ProfileStats({
    required this.totalGames,
    required this.totalHoursPlayed,
  });

  factory ProfileStats.fromMap(Map<String, dynamic> map) {
    return ProfileStats(
      totalGames: map['totalGames'] ?? 0,
      totalHoursPlayed: map['totalHoursPlayed'] ?? 0,
    );
  }
}

class UserProfileModel {
  final String id;
  final String email;
  final String? name;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final String? level;
  final int? achievements;
  final int? platinums;
  final ProfileStats? profileStats;
  final List<LinkedAccountModel> linkedAccounts;

  UserProfileModel({
    required this.id,
    required this.email,
    this.name,
    this.username,
    this.bio,
    this.avatarUrl,
    this.level,
    this.achievements,
    this.platinums,
    this.profileStats,
    required this.linkedAccounts,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      username: map['username'],
      bio: map['bio'],
      avatarUrl: map['avatarUrl'],
      level: map['level']?.toString(),
      achievements: map['achievements'],
      platinums: map['platinums'],
      profileStats: map['profileStats'] != null
          ? ProfileStats.fromMap(map['profileStats'])
          : null,
      linkedAccounts: map['linkedAccounts'] != null
          ? List<LinkedAccountModel>.from(
              map['linkedAccounts'].map((x) => LinkedAccountModel.fromMap(x)))
          : [],
    );
  }
}
