
import 'package:card/Models/deck.dart';
import 'package:card/Models/model.dart';
import 'package:card/UI/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<DeckState> childKey = GlobalKey<DeckState>();
  List<PlayingCard> deck = [];
  List<Player> players = [];

  @override
  void initState() {
    deck = createDeck();
    players = createPlayers(5);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return PlayTable(
      players: players,
      deck: deck,
    );
  }
}