class LinkedAccountModel {
  final String id;
  final String provider; // STEAM, GOG, EPIC_GAMES
  final String providerAccountId;
  final String? username;
  final String userId;
  final String createdAt;
  final String updatedAt;

  LinkedAccountModel({
    required this.id,
    required this.provider,
    required this.providerAccountId,
    this.username,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LinkedAccountModel.fromMap(Map<String, dynamic> map) {
    return LinkedAccountModel(
      id: map['id'] ?? '',
      provider: map['provider'] ?? '',
      providerAccountId: map['providerAccountId'] ?? '',
      username: map['username'],
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }
}
