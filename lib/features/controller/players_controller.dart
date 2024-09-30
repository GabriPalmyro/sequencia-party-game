import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/common/local_database/local_database.dart';
import 'package:sequencia/core/app_card_colors.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/helpers/extension/color_extension.dart';
import 'package:sequencia/utils/app_strings.dart';

@Injectable()
class PlayersController extends ChangeNotifier {
  PlayersController({required this.localDatabase});
  final LocalDatabase localDatabase;

  final List<PlayerEntity> _players = [];
  final Map<String, bool> _availableColors = Map.from(playersColors);

  List<PlayerEntity> get players => _players;
  Map<String, bool> get availableColors => _availableColors;

  int get playersCount => _players.length;

  Color getRandomAvailableColor() {
    String randomColor = _availableColors.keys.elementAt(Random().nextInt(_availableColors.length));

    while (!_availableColors[randomColor]!) {
      randomColor = _availableColors.keys.elementAt(Random().nextInt(_availableColors.length));
    }

    _availableColors[randomColor] = false;
    return HexColor.fromHex(randomColor);
  }

  List<Color> getAvailableColors() => _availableColors.keys
      .toList()
      .where((color) => _availableColors[color]!)
      .map(
        (color) => HexColor.fromHex(color),
      )
      .toList();

  void addPlayer(PlayerEntity player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(PlayerEntity player) {
    _players.remove(player);
    if (player.color != null) {
      _availableColors[player.color!.toHex()] = true;
    }
    notifyListeners();
  }

  void updatePlayer(PlayerEntity player, {String? newName, Color? newColor, String? newNumber}) {
    final index = _players.indexOf(player);
    if (newName != null) {
      _players[index] = player.copyWith(name: newName);
    }

    if (newColor != null) {
      if (player.color != null) {
        _availableColors[player.color!.toHex()] = true;
      }
      _availableColors[newColor.toHex()] = false;
      _players[index] = player.copyWith(color: newColor);
    }

    if (newNumber != null) {
      _players[index] = player.copyWith(orderNumber: newNumber);
    }
    notifyListeners();
  }

  void resetPlayers() {
    _players.clear();
    _availableColors.forEach((key, value) {
      _availableColors[key] = true;
    });
    notifyListeners();
  }

  List<PlayerEntity> removeEmptyPlayers() {
    final tempPlayers = _players;
    tempPlayers.removeWhere((player) => player.name.isEmpty);
    return tempPlayers;
  }

  Future<void> getSavedPlayers() async {
    try {
      final savedPlayers = await localDatabase.getData(AppStrings.playersKey);
      if (savedPlayers != null && savedPlayers.isNotEmpty) {
        _players.clear();
        for (final playerName in savedPlayers) {
          addPlayer(
            PlayerEntity(
              name: playerName,
              color: getRandomAvailableColor(),
            ),
          );
        }
      }
    } catch (e) {
      dev.log('Error getting saved players $e');
    }
  }

  void savePlayers() {
    final playersNormalized = removeEmptyPlayers();
    localDatabase.saveData(
      AppStrings.playersKey,
      playersNormalized.map((player) => player.name).toList(),
    );
  }
}
