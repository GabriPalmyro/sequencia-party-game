import 'dart:math';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/core/game_themes.dart';
import 'package:sequencia/features/domain/game/game_type_enum%20.dart';

@Injectable()
class GameController extends ChangeNotifier {
  GameTypeEnum _gameType = GameTypeEnum.SHOW_THEME_CARD;

  GameTypeEnum get gameType => _gameType;

  void changeGameType(GameTypeEnum newGameType) {
    _gameType = newGameType;
    notifyListeners();
  }

  final List<String> _numbersUsed = [];

  void resetGame() {
    _gameType = GameTypeEnum.SHOW_THEME_CARD;
    _numbersUsed.clear();
    notifyListeners();
  }

  String getRandomAvailableNumber() {
    final random = Random();

    final number = random.nextInt(100).toString();

    if (!_numbersUsed.contains(number)) {
      _numbersUsed.add(number);
      return number;
    }

    if (_numbersUsed.length < 100) {
      return getRandomAvailableNumber();
    }

    throw Exception('No more numbers available');
  }

  String gameThemeNumber = '';
  String gameThemeDescription = '';

  void selectRandomTheme() {
    final random = Random().nextInt(gameThemes.length);
    gameThemeNumber = random.toString();
    gameThemeDescription = gameThemes[random];
    notifyListeners();
  }
}
