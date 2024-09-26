enum GameTypeEnum {
  SHOW_THEME_CARD,
  SHOW_PLAYERS_NUMBER,
  ORDER_PLAYERS;

  static GameTypeEnum fromString(String value) {
    return GameTypeEnum.values.firstWhere((e) => e.toString() == value);
  }
}