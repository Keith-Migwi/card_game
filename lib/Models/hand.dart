import 'dart:math';
import 'package:flutter/material.dart';
import 'package:card/Models/card.dart';
import 'package:card/Models/model.dart';

class Hand extends StatefulWidget {
  final List<PlayingCard> cards;
  final double fanAngle; /// in radians
  final double radius;
  final int maxVisibleInFan; /// threshold before switching to scroll
  final double height;
  final bool isCurrent;

  const Hand({
    super.key,
    required this.cards,
    this.fanAngle = pi / 4, // 45 degrees total spread
    this.radius = 120,
    this.maxVisibleInFan = 5,
    required this.height,
    this.isCurrent = true,
  });

  @override
  State<Hand> createState() => _HandState();
}

class _HandState extends State<Hand> {
  PlayingCard? _selectedCard;

  void _onCardTap(PlayingCard card) {
    setState(() {
      if (_selectedCard == card) {
        // tapped again → deselect
        _selectedCard = null;
      } else {
        // select new card
        _selectedCard = card;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cards excluding the selected one
    final List<PlayingCard> visibleCards = [
      for (final c in widget.cards)
        if (c != _selectedCard) c
    ];

    Widget buildFan() {
      final angleStep = visibleCards.length > 1
          ? widget.fanAngle / (visibleCards.length - 1)
          : 0.0;

      final startAngle = visibleCards.length > 1
          ? -widget.fanAngle / 2
          : 0.0; // 👈 center single card

      return SizedBox(
        height: widget.radius + 40,
        width: widget.radius * 2,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            for (int i = 0; i < visibleCards.length; i++)
              Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()
                  ..translate(
                    widget.radius * sin(startAngle + angleStep * i),
                    -widget.radius * cos(startAngle + angleStep * i) + widget.radius,
                  )
                  ..rotateZ(startAngle + angleStep * i),
                child: GestureDetector(
                  onTap: () => _onCardTap(visibleCards[i]),
                  child: CardModel(
                    card: visibleCards[i],
                    height: widget.height,
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget buildScrollable() {
      final double cardWidth = widget.height * 2.5 / 3.5;
      final double overlap = cardWidth * 0.6;
      final double totalWidth =
          cardWidth + (visibleCards.length - 1) * (cardWidth - overlap);
      final double containerHeight = widget.height * 1.1;
      final double verticalOffset = (containerHeight - widget.height) / 2;

      return SizedBox(
        height: widget.height * 1.1,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: totalWidth,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (int i = 0; i < visibleCards.length; i++)
                  Positioned(
                    left: i * (cardWidth - overlap),
                    top: verticalOffset,
                    child: GestureDetector(
                      onTap: () => _onCardTap(visibleCards[i]),
                      child: CardModel(
                        card: visibleCards[i],
                        height: widget.height,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    Widget otherPlayersHand(){
      final double height = widget.height * 0.5;
      final double cardWidth = height * 2.5 / 3.5;
      final double overlap = cardWidth * 0.7;
      final double totalWidth =
          cardWidth + (visibleCards.length - 1) * (cardWidth - overlap);

      return SizedBox(
        width: totalWidth,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < visibleCards.length; i++)
              Positioned(
                left: i * (cardWidth - overlap),
                child: CardModel(
                  card: visibleCards[i],
                  height: height,
                ),
              ),
          ],
        ),
      );
    }

    Color color = Colors.black;
    if(['♥', '♦', 'red'].contains(_selectedCard?.suit)){
      color = Color(0xFFE20F0F);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if(!widget.isCurrent)
          otherPlayersHand()
        else if (visibleCards.length <= widget.maxVisibleInFan)
          buildFan()
        else
          buildScrollable(),

        // Highlighted selected card on top
        // Highlighted selected card on top
        if (_selectedCard != null)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => _onCardTap(_selectedCard!),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6), // glow color
                      blurRadius: 10, // how soft the glow is
                      spreadRadius: 1, // how far it spreads
                    ),
                  ],
                ),
                child: CardModel(
                  card: _selectedCard!,
                  height: widget.height * 1.1,
                ),
              ),
            ),
          ),

      ],
    );
  }
}
