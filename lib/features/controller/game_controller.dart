import 'dart:developer';
import 'dart:math' show Random;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/common/local_database/local_database.dart';
import 'package:sequencia/features/domain/game/game_type_enum.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';

@singleton
class GameController extends ChangeNotifier {
  GameController(this.localDatabase);
  final LocalDatabase localDatabase;

  GameTypeEnum _gameType = GameTypeEnum.SHOW_THEME_CARD;

  GameTypeEnum get gameType => _gameType;

  List<String> gameThemes = List.empty(growable: true);

  void setGameThemes(List<String> themes) {
    gameThemes = themes;
    notifyListeners();
  }

  void addGameTheme(String theme) {
    gameThemes.add(theme);
    notifyListeners();
  }

  Future<void> getGameThemes() async {
    final themesCollection = FirebaseFirestore.instance.collection(
      'themes',
    );

    try {
      // Obtém todos os documentos da coleção
      final QuerySnapshot snapshot = await themesCollection.get();

      // Extrai os temas dos documentos
      final List<String> themes = snapshot.docs
          .map(
            (doc) => doc['theme'] as String,
          )
          .toList();

      setGameThemes(themes);

      log('Temas carregados: ${themes.length}');

      localDatabase.saveData('gameThemes', themes);
      notifyListeners();
    } catch (e) {
      try {
        log('Erro ao buscar os temas firebase: $e');
        final themes = await getThemesFromLocalDatabase();
        setGameThemes(themes);
      } catch (e) {
        log('Erro ao buscar os temas locallmente: $e');
      }
    }
  }

  Future<List<String>> getThemesFromLocalDatabase() async {
    final List<String> themes = await localDatabase.getData('gameThemes');
    return themes;
  }

  bool isGameFinished() {
    return _gameType == GameTypeEnum.GAME_FINISHED || _gameType == GameTypeEnum.REVEAL_PLAYERS;
  }

  void changeGameType(GameTypeEnum newGameType) {
    _gameType = newGameType;
    notifyListeners();
  }

  final List<String> _numbersUsed = [];

  void resetGame() {
    _gameType = GameTypeEnum.SHOW_THEME_CARD;
    _numbersUsed.clear();
    gameThemeNumber = '';
    gameThemeDescription = '';
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

  List<PlayerEntity> players = [];

  set setPlayers(List<PlayerEntity> newPlayers) {
    players = newPlayers;
    notifyListeners();
  }

  void updatePlayer(PlayerEntity player, {String? newNumber}) {
    final index = players.indexOf(player);

    if (newNumber != null) {
      players[index] = player.copyWith(orderNumber: newNumber);
    }

    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    final player = players.removeAt(oldIndex);
    players.insert(newIndex, player);
    notifyListeners();
  }
}
