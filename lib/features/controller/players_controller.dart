import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/common/local_database/local_database.dart';
import 'package:sequencia/core/app_card_colors.dart';
import 'package:sequencia/features/domain/player/entities/player_entity.dart';
import 'package:sequencia/helpers/extension/color_extension.dart';
import 'package:sequencia/utils/app_consts.dart';
import 'package:sequencia/utils/app_strings.dart';

@Injectable()
class PlayersController extends ChangeNotifier {
  PlayersController({required this.localDatabase});
  final LocalDatabase localDatabase;

  final List<PlayerEntity> _players = [];
  final Map<String, bool> _availableColors = Map.fromEntries(
    playersColors.entries.map(
      (entry) => MapEntry(entry.key.toUpperCase(), entry.value),
    ),
  );

  List<PlayerEntity> get players => _players;
  Map<String, bool> get availableColors => _availableColors;

  int get playersCount => _players.length;

  Color getRandomAvailableColor() {
    if (!_availableColors.containsValue(true)) {
      final fallbackHex = _availableColors.keys.first;
      return HexColor.fromHex(fallbackHex);
    }

    String randomColor = _availableColors.keys
        .elementAt(Random().nextInt(_availableColors.length));

    while (!_availableColors[randomColor]!) {
      randomColor = _availableColors.keys
          .elementAt(Random().nextInt(_availableColors.length));
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

  void addPlayer(PlayerEntity player, {bool notify = true}) {
    final assignedPlayer = player.color == null
        ? player.copyWith(color: getRandomAvailableColor())
        : player;

    if (assignedPlayer.color != null) {
      final colorKey = _colorKey(assignedPlayer.color!);
      if (_availableColors.containsKey(colorKey)) {
        _availableColors[colorKey] = false;
      }
    }

    _players.add(assignedPlayer);
    if (notify) {
      notifyListeners();
    }
  }

  void removePlayer(PlayerEntity player) {
    _players.remove(player);
    if (player.color != null) {
      final colorKey = _colorKey(player.color!);
      if (_availableColors.containsKey(colorKey)) {
        _availableColors[colorKey] = true;
      }
    }
    _ensureTrailingPlaceholder(notify: false);
    notifyListeners();
  }

  void updatePlayer(
    PlayerEntity player, {
    String? newName,
    Color? newColor,
    String? newNumber,
  }) {
    final index = _players.indexOf(player);
    if (newName != null) {
      _players[index] = player.copyWith(name: newName);
    }

    if (newColor != null) {
      if (player.color != null) {
        final previousColorKey = _colorKey(player.color!);
        if (_availableColors.containsKey(previousColorKey)) {
          _availableColors[previousColorKey] = true;
        }
      }
      final nextColorKey = _colorKey(newColor);
      if (_availableColors.containsKey(nextColorKey)) {
        _availableColors[nextColorKey] = false;
      }
      _players[index] = player.copyWith(color: newColor);
    }

    if (newNumber != null) {
      _players[index] = player.copyWith(orderNumber: newNumber);
    }
    notifyListeners();
  }

  void resetPlayers() {
    _players.clear();
    _availableColors.updateAll((key, value) => true);
    _ensureTrailingPlaceholder(notify: false);
    notifyListeners();
  }

  List<PlayerEntity> removeEmptyPlayers() {
    final removedPlayers =
        _players.where((player) => player.name.isEmpty).toList();
    for (final player in removedPlayers) {
      if (player.color != null) {
        final colorKey = _colorKey(player.color!);
        if (_availableColors.containsKey(colorKey)) {
          _availableColors[colorKey] = true;
        }
      }
    }
    _players.removeWhere((player) => player.name.isEmpty);
    _ensureTrailingPlaceholder();
    return List<PlayerEntity>.from(
      _players.where(
        (player) => player.name.isNotEmpty,
      ),
    );
  }

  Future<void> getSavedPlayers() async {
    try {
      final savedPlayers = await localDatabase.getData(AppStrings.playersKey);
      if (savedPlayers == null) {
        _ensureTrailingPlaceholder();
        return;
      }

      _players.clear();
      _availableColors.updateAll((key, value) => true);

      final List<Map<String, dynamic>> parsedPlayers = [];
      if (savedPlayers is String && savedPlayers.isNotEmpty) {
        final decoded = jsonDecode(savedPlayers);
        if (decoded is List) {
          for (final entry in decoded) {
            if (entry is Map<String, dynamic>) {
              parsedPlayers.add(entry);
            } else if (entry is Map) {
              parsedPlayers.add(
                Map<String, dynamic>.from(
                  entry as Map,
                ),
              );
            }
          }
        }
      } else if (savedPlayers is List) {
        for (final playerName in savedPlayers) {
          parsedPlayers.add({'name': playerName});
        }
      }

      for (final playerMap in parsedPlayers) {
        final name = (playerMap['name'] ?? '').toString();
        if (name.isEmpty) {
          continue;
        }

        final rawColorHex = playerMap['color'] as String?;
        Color? color;
        if (rawColorHex != null && rawColorHex.isNotEmpty) {
          final normalizedKey =
              (rawColorHex.startsWith('#') ? rawColorHex : '#$rawColorHex')
                  .toUpperCase();
          if (_availableColors[normalizedKey] == true) {
            color = HexColor.fromHex(normalizedKey);
          } else {
            color = getRandomAvailableColor();
          }
        }

        addPlayer(
          PlayerEntity(
            name: name,
            color: color,
          ),
          notify: false,
        );
      }

      _ensureTrailingPlaceholder(notify: false);
      notifyListeners();
    } catch (e) {
      dev.log('Error getting saved players $e');
    }
  }

  void savePlayers() {
    final playersNormalized =
        _players.where((player) => player.name.isNotEmpty).toList();
    final serialized = playersNormalized
        .map(
          (player) => {
            'name': player.name,
            'color': player.color != null ? _colorKey(player.color!) : null,
          },
        )
        .toList();

    localDatabase.saveData(
      AppStrings.playersKey,
      jsonEncode(serialized),
    );
  }

  String _colorKey(Color color) {
    final hex = color.toHex();
    final sanitized = hex.replaceFirst('#', '').toUpperCase();
    final rgb = sanitized.length >= 6
        ? sanitized.substring(sanitized.length - 6)
        : sanitized;
    return '#$rgb';
  }

  void _ensureTrailingPlaceholder({bool notify = true}) {
    final hasTrailingPlaceholder =
        _players.isNotEmpty && _players.last.name.isEmpty;
    if (!hasTrailingPlaceholder && _players.length < AppConsts.maxPlayers) {
      addPlayer(
        PlayerEntity(
          name: '',
          color: getRandomAvailableColor(),
        ),
        notify: notify,
      );
    }
  }
}
