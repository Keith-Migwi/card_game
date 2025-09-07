import 'dart:math';
import 'package:card/Models/model.dart';
import 'package:card/UI/card_back.dart';
import 'package:card/UI/card_front.dart';
import 'package:flutter/material.dart';

class CardModel extends StatefulWidget {
  final PlayingCard card;
  final double height;
  final bool horizontalFlip; /// true = horizontal (Y axis), false = vertical (X axis)

  const CardModel({
    super.key,
    required this.card,
    this.height = 100,
    this.horizontalFlip = true,
  });

  @override
  State<CardModel> createState() => CardModelState();
}

class CardModelState extends State<CardModel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  void flipCard() {
    if (widget.card.isFaceUp) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      widget.card.isFaceUp = !widget.card.isFaceUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: GestureDetector(
        // onTap: flipCard,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final angle = _controller.value * pi;
            final isBack = angle <= pi / 2;

            // Build the transform matrix
            final Matrix4 transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001); // perspective

            if (widget.horizontalFlip) {
              transform.rotateY(angle); // horizontal flip
            } else {
              transform.rotateX(-angle); // vertical flip with reversed direction
            }

            return Transform(
              transform: transform,
              alignment: Alignment.center,
              child: widget.card.isFaceUp
                  ? CardFront(
                rank: widget.card.rank,
                suit: widget.card.suit,
              ) : isBack
                  ? CardBack(
                height: widget.height,
              )
                  : Transform(
                transform: widget.horizontalFlip
                    ? (Matrix4.identity()..rotateY(pi))
                    : (Matrix4.identity()..rotateX(pi)),
                alignment: Alignment.center,
                child: CardFront(
                  rank: widget.card.rank,
                  suit: widget.card.suit,
                  height: widget.height,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
