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
  final Random _randomGenerator = Random();

  GameTypeEnum _gameType = GameTypeEnum.SHOW_THEME_CARD;

  GameTypeEnum get gameType => _gameType;

  List<String> gameThemes = List.empty(growable: true);
  
  // Set to track used themes in memory (resets every app session)
  final Set<String> _usedThemes = <String>{};
  // Pool of themes available for selection before needing a reset
  final List<String> _availableThemePool = <String>[];

  /// Returns a copy of the used themes set (for debugging purposes)
  Set<String> get usedThemes => Set.unmodifiable(_usedThemes);

  /// Returns the number of available themes that haven't been used yet
  int get availableThemesCount => _availableThemePool.length;

  void setGameThemes(List<String> themes) {
    gameThemes = themes;
    _resetThemeCycle();
    notifyListeners();
  }

  void addGameTheme(String theme) {
    gameThemes.add(theme);
    if (!_availableThemePool.contains(theme)) {
      _availableThemePool.add(theme);
    }
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

  /// Resets the used themes list to allow all themes to be used again
  void resetUsedThemes() {
    _resetThemeCycle();
  }

  void _resetThemeCycle() {
    _usedThemes.clear();
    _availableThemePool
      ..clear()
      ..addAll(gameThemes);
  }

  /// Marks the current theme as used after game completion
  void markCurrentThemeAsUsed() {
    if (gameThemeDescription.isNotEmpty) {
      _usedThemes.add(gameThemeDescription);
    }
  }

  String getRandomAvailableNumber() {
    final number = _randomGenerator.nextInt(100).toString();

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
    if (gameThemes.isEmpty) {
      log('No themes available to select');
      return;
    }
    
    if (_availableThemePool.isEmpty) {
      resetUsedThemes();
    }

    if (_availableThemePool.isEmpty) {
      log('No themes available to select');
      return;
    }
    
    final randomIndex = _randomGenerator.nextInt(_availableThemePool.length);
    final selectedTheme = _availableThemePool.removeAt(randomIndex);
    _usedThemes.add(selectedTheme);
    
    gameThemeNumber = gameThemes.indexOf(selectedTheme).toString();
    gameThemeDescription = selectedTheme;
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

  bool isGameSuccess() {
    if (_gameType != GameTypeEnum.GAME_FINISHED) {
      return false;
    }

    // Verify if the  List<PlayerEntity> players = []; is in a sequencial increase ordem
    for (int i = 1; i < players.length; i++) {
      final prev = int.tryParse(players[i - 1].orderNumber ?? '');
      final curr = int.tryParse(players[i].orderNumber ?? '');
      if (prev == null || curr == null || curr <= prev) {
        return false;
      }
    }
    return true;
  }

  /// Call this method when a game is completed (regardless of success or failure)
  /// to mark the current theme as used
  void completeGame() {
    markCurrentThemeAsUsed();
  }

  void onReorder(int oldIndex, int newIndex) {
    final player = players.removeAt(oldIndex);
    players.insert(newIndex, player);
    notifyListeners();
  }
}
