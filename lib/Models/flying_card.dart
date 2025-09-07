import 'package:card/Models/card.dart';
import 'package:card/Models/model.dart' show PlayingCard;
import 'package:flutter/material.dart';

class FlyingCard {
  final PlayingCard card;
  final Offset from;
  final Offset to;
  final Duration duration;
  final VoidCallback onArrive;
  final bool flip;

  FlyingCard({
    required this.card,
    required this.from,
    required this.to,
    required this.duration,
    required this.onArrive,
    required this.flip
  });

  Widget build(BuildContext context) {
    double cardHeight = (MediaQuery.of(context).size.height * 0.17).clamp(60, 100);
    double cardWidth = cardHeight * 2.5 /3.5;
    GlobalKey<CardModelState> key = GlobalKey<CardModelState>();


    return TweenAnimationBuilder<Offset>(
      tween: Tween(begin: from, end: to),
      duration: duration,
      onEnd: ()async{
        if(flip){
          key.currentState?.flipCard();
        }
        onArrive();
      },
      builder: (context, value, child) {
        return Positioned(
          left: value.dx - cardWidth / 2,
          top: value.dy - cardHeight / 2,
          child: child!,
        );
      },
      child: CardModel(
        height: (MediaQuery.of(context).size.height * 0.17).clamp(60, 100),
        card: card,
        key: key,
      ),
    );
  }
}