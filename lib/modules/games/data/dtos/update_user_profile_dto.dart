class UpdateUserProfileDto {
  final String? name;

  UpdateUserProfileDto({this.name});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
  };
}