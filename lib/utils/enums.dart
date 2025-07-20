enum GameStatus {
  ZERADO,
  JOGANDO,
  NUNCA_JOGADO,
  DROPADO,
  PLATINADO,
  PROXIMO,
}

enum Provider {
  STEAM,
  GOG,
  GAMEMATE,
}

extension ProviderExtension on Provider {
  String get name {
    switch (this) {
      case Provider.STEAM:
        return 'STEAM';
      case Provider.GOG:
        return 'GOG';
      case Provider.GAMEMATE:
        return 'GAMEMATE';
    }
  }

  static Provider fromString(String value) {
    switch (value) {
      case 'STEAM':
        return Provider.STEAM;
      case 'GOG':
        return Provider.GOG;
      case 'GAMEMATE':
        return Provider.GAMEMATE;
      default:
        throw Exception('Provider inválido');
    }
  }
}