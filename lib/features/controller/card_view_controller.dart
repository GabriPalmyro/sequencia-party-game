import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:sequencia/features/domain/game/card_view_enum.dart';

@Injectable()
class CardViewController extends ChangeNotifier {
  CardViewEnum _cardView = CardViewEnum.HIDE_CARD;

  CardViewEnum get cardView => _cardView;

  void changeCardView(CardViewEnum cardView) {
    _cardView = cardView;
    notifyListeners();
  }
}
