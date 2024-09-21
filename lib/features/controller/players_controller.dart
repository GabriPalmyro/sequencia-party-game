import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';

@Injectable()
class PlayersController extends ChangeNotifier {
  final List<PlayerEntity> _players = [];

  List<PlayerEntity> get players => _players;

  void addPlayer(PlayerEntity player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(PlayerEntity player) {
    _players.remove(player);
    notifyListeners();
  }

  void updatePlayerName(PlayerEntity player, String newName) {
    final index = _players.indexOf(player);
    _players[index] = player.copyWith(name: newName);
    notifyListeners();
  }
}
