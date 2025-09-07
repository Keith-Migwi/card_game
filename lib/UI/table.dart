import 'dart:math';
import 'package:card/Models/deck.dart';
import 'package:card/Models/flying_card.dart';
import 'package:card/Models/hand.dart';
import 'package:card/Models/model.dart';
import 'package:flutter/material.dart';

class PlayTable extends StatefulWidget {
  final List<Player> players;
  final List<PlayingCard> deck;
  final int cardsToDeal;

  const PlayTable({
    required this.players,
    required this.deck,
    this.cardsToDeal = 4,
    super.key,
  });

  @override
  State<PlayTable> createState() => _PlayTableState();
}

class _PlayTableState extends State<PlayTable> {
  final List<FlyingCard> flyingCards = [];
  int dealIndex = 0;
  GlobalKey<DeckState> deckKey = GlobalKey<DeckState>();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      deckKey.currentState?.shuffleDeck();
      await Future.delayed(Duration(milliseconds: 2000));
      _dealNextCard();
    });
  }

  void _dealNextCard() {
    if (dealIndex >= widget.players.length * widget.cardsToDeal) return;
    final size = MediaQuery.of(context).size;
    double cardHeight = (MediaQuery.of(context).size.height * 0.17).clamp(60, 100);
    final center = Offset(size.width / 2, (size.height / 2) - (cardHeight / 2));

    final player = widget.players[dealIndex % widget.players.length];
    final target = _getPlayerHandPosition(player, size);

    final PlayingCard selectedCard = widget.deck.removeLast();
    selectedCard.isFaceUp = false;

    final card = FlyingCard(
      card: selectedCard,
      from: center,
      to: target,
      flip: player.isCurrent,
      duration: const Duration(milliseconds: 600),
      onArrive: () async{
        if(player.isCurrent){
          setState(() {});
          await Future.delayed(Duration(milliseconds: 500));
        }

        setState(() {
          player.hand.add(selectedCard);
          flyingCards.removeWhere((c) => c.card == selectedCard);
        });
        Future.delayed(const Duration(milliseconds: 200), _dealNextCard);
      },
    );

    setState(() {
      flyingCards.add(card);
      dealIndex++;
    });
  }

  Offset _getPlayerHandPosition(Player player, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 20;
    final radiusX = (size.width - 80) * 0.4;
    final radiusY = (size.height - 20) * 0.35;
    const double bottomPadding = 20;
    const double topPadding = 50;

    int currentIndex = widget.players.indexWhere((p) => p.isCurrent);
    if (currentIndex == -1) throw Exception("No current player set!");

    if (player.isCurrent) {
      double y = (centerY + radiusY + 40)
          .clamp(0.0, size.height - bottomPadding - 40);
      return Offset(centerX, y);
    }

    int currentIndexPlayer = widget.players.indexWhere((p) => p.isCurrent);
    int otherPlayers = widget.players.length - 1;

    if (otherPlayers == 1) {
      double rawY = centerY - radiusY - 40;
      double y = rawY.clamp(topPadding, size.height);
      return Offset(centerX, y);
    } else {
      double arcAngle = pi;
      double startAngle = pi / 2 - arcAngle / 2;
      int playerIndex = (widget.players.indexOf(player) -
          currentIndexPlayer -
          1 +
          widget.players.length) %
          widget.players.length;

      double angle =
          startAngle + (arcAngle * playerIndex / (otherPlayers - 1));
      double x = centerX + radiusX * cos(angle);
      double y = centerY - radiusY * sin(angle);
      return Offset(x, y);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2 - 20;

    final radiusX = (size.width - 80) * 0.4;
    final radiusY = (size.height - 20) * 0.35;

    const double bottomPadding = 20;
    const double topPadding = 50;

    List<Widget> positions = [];

    // --- Find current player ---
    int currentIndex = widget.players.indexWhere((p) => p.isCurrent);
    if (currentIndex == -1) {
      throw Exception("No current player set!");
    }
    Player currentPlayer = widget.players[currentIndex];

    // --- Other players ---
    int otherPlayers = widget.players.length - 1;

    if (otherPlayers == 1) {
      Player opponent =
      widget.players[(currentIndex + 1) % widget.players.length];
      double x = centerX;
      double rawY = centerY - radiusY - 40;
      double y = rawY.clamp(topPadding, size.height);

      double radialAngle = atan2(y - centerY, x - centerX);
      double handRotation = radialAngle + pi / 2;

      positions.add(
        Positioned(
          left: x,
          top: y,
          child: FractionalTranslation(
            translation: const Offset(-0.5, -0.5),
            child: _playerWidget(opponent, radialAngle, handRotation, context),
          ),
        ),
      );
    } else if (otherPlayers > 1) {
      double arcAngle = pi;
      double startAngle = pi / 2 - arcAngle / 2;

      for (int i = 0; i < otherPlayers; i++) {
        Player opponent =
        widget.players[(currentIndex + 1 + i) % widget.players.length];

        double angle = startAngle + (arcAngle * i / (otherPlayers - 1));

        double x = centerX + radiusX * cos(angle);
        double y = centerY - radiusY * sin(angle);

        double radialAngle = atan2(y - centerY, x - centerX);
        double handRotation = radialAngle + pi / 2;

        positions.add(
          Positioned(
            left: x,
            top: y,
            child: FractionalTranslation(
              translation: const Offset(-0.5, -0.5),
              child:
              _playerWidget(opponent, radialAngle, handRotation, context),
            ),
          ),
        );
      }
    }

    positions.add(
      Positioned(
        left: 0,
        right: 0,
        bottom: size.height * 0.5,
        child: Deck(
          deck: widget.deck,
          height: (MediaQuery.of(context).size.height * 0.17).clamp(60, 100),
          key: deckKey,
        ),
      ),
    );

    positions.add(
      Positioned(
        left: 0,
        right: 0,
        top: size.height * 0.5,
        child: Deck(
          deck: widget.deck,
          height: (MediaQuery.of(context).size.height * 0.17).clamp(60, 100),
        ),
      ),
    );

    // --- Current player (bottom center) ---
        {
      double x = centerX;
      double rawY = centerY + radiusY + 40;
      double y = rawY.clamp(0.0, size.height - bottomPadding - 40);

      double radialAngle = atan2(y - centerY, x - centerX);
      double handRotation = radialAngle - pi / 2;

      positions.add(
        Positioned(
          left: 0,
          right: 0,
          bottom: 5,
          child:
          _playerWidget(currentPlayer, radialAngle, handRotation, context),
        ),
      );
    }

    // --- Flying cards layer ---
    positions.addAll(flyingCards.map((fc) => fc.build(context)));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: positions),
    );
  }

  Widget _playerWidget(
      Player player, double radialAngle, double handRotation, BuildContext context) {
    const double avatarDistance = 40.0;
    final Offset outward = Offset(cos(radialAngle), sin(radialAngle));

    if (player.isCurrent) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (player.hand.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Hand(
                cards: player.hand,
                height:
                (MediaQuery.of(context).size.height * 0.17).clamp(60, 100),
                isCurrent: player.isCurrent,
              ),
            ),
          CircleAvatar(
            radius: player.isCurrent ? 35 : 25,
            backgroundColor:
            player.isCurrent ? Colors.orange : Colors.blueAccent,
            child: Text(
              player.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      );
    }

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: handRotation,
          child: Hand(
            cards: player.hand,
            height:
            (MediaQuery.of(context).size.height * 0.17).clamp(60, 100),
            isCurrent: player.isCurrent,
          ),
        ),
        Transform.translate(
          offset: outward * avatarDistance,
          child: CircleAvatar(
            radius: 25,
            backgroundColor:
            player.isCurrent ? Colors.orange : Colors.blueAccent,
            child: Text(
              player.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

