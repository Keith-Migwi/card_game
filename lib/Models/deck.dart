import 'dart:math';
import 'package:card/Models/card.dart';
import 'package:card/Models/model.dart';
import 'package:flutter/material.dart';

class Deck extends StatefulWidget {
  final List<PlayingCard> deck;
  final double height;

  const Deck({
    required this.deck,
    this.height = 100,
    super.key,
  });

  @override
  State<Deck> createState() => DeckState();
}

class DeckState extends State<Deck> with SingleTickerProviderStateMixin {

  late final AnimationController _controller;
  final Random _random = Random();

  late List<int> _directions;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _initAnimations();
  }

  void _initAnimations() {
    double maxSpread = (widget.height) * 2.5 / 3.5;

    _directions = List.generate(
      widget.deck.length,
          (_) => _random.nextBool() ? 1 : -1,
    );

    _animations = List.generate(widget.deck.length, (i) {
      final scale = (i + 1) / widget.deck.length;
      return Tween<double>(
        begin: 0,
        end: _directions[i] * scale * maxSpread,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
    });
  }

  Future<void> shuffleDeck() async {
    _initAnimations();
    await _controller.forward();
    await _controller.reverse();
    _initAnimations();
    await _controller.forward();
    await _controller.reverse();
  }

  Widget _buildCard(int i) => AnimatedBuilder(
    animation: _controller,
    builder: (_, child) {
      final half = widget.deck.length / 2;
      // top -> negative (left), bottom -> positive (right)
      final spread = (half - i) * 0.4;

      return Transform.translate(
        offset: Offset(_animations[i].value + spread, 0),
        child: child,
      );
    },
    child: CardModel(
      card: widget.deck[i],
      height: widget.height,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: shuffleDeck,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(widget.deck.length, _buildCard),
        ),
      ),
    );
  }
}
