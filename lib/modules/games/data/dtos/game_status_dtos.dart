class AddGameDto {
  final String gameId;
  final String sourceProvider;
  final String status;        

  AddGameDto({
    required this.gameId,
    required this.sourceProvider,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
    'sourceProvider': sourceProvider,
    'status': status,
  };
}

class UpdateGameStatusDto {
  final String status;

  UpdateGameStatusDto(this.status);

  Map<String, dynamic> toJson() => {
    'status': status,
  };
}

class RemoveGameDto {
  final String gameId;

  RemoveGameDto(this.gameId);

  Map<String, dynamic> toJson() => {
    'gameId': gameId,
  };
}
