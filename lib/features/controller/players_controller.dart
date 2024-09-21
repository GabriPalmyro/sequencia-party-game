import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/core/app_card_colors.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';

@Injectable()
class PlayersController extends ChangeNotifier {
  final List<PlayerEntity> _players = [];
  final Map<String, bool> _availableColors = Map.from(playersColors);

  List<PlayerEntity> get players => _players;
  Map<String, bool> get availableColors => _availableColors;

  int get playersCount => _players.length;

  void addPlayer(PlayerEntity player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(PlayerEntity player) {
    _players.remove(player);
    if (player.color != null) {
      _availableColors[player.color!.value.toRadixString(16).substring(2)] = true;
    }
    notifyListeners();
  }

  void updatePlayerName(PlayerEntity player, String newName) {
    final index = _players.indexOf(player);
    _players[index] = player.copyWith(name: newName);
    notifyListeners();
  }

  void updatePlayerColor(PlayerEntity player, Color color) {
    final index = _players.indexOf(player);
    if (player.color != null) {
      _availableColors[player.color!.value.toRadixString(16).substring(2)] = true;
    }
    _availableColors[color.value.toRadixString(16).substring(2)] = false;
    _players[index] = player.copyWith(color: color);
    notifyListeners();
  }

  bool isAllPlayersNameValid() {
    return _players.every((player) => player.name.isNotEmpty);
  }
}
