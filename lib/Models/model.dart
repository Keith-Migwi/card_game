import 'dart:math';

class PlayingCard {
  final String rank;
  final String suit;
  bool isFaceUp;

  PlayingCard({
    required this.rank,
    required this.suit,
    this.isFaceUp = false,
  });
}


List<PlayingCard> createDeck() {
  const ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];
  const suits = ['♠', '♥', '♦', '♣'];

  List<PlayingCard> deck = [];
  for (var suit in suits){
    for (var rank in ranks){
      deck.add(PlayingCard(rank: rank, suit: suit, isFaceUp: false));
    }
  }

  deck.add(PlayingCard(rank: 'JOKER', suit: 'red', isFaceUp: false));
  deck.add(PlayingCard(rank: 'JOKER', suit: 'black', isFaceUp: false));
  final random = Random();


  return List.from(deck)..shuffle(random);
}

class Player {
  final List<PlayingCard> hand;
  final String name;
  final int index;
  bool isCurrent;

  Player({
    required this.hand,
    required this.name,
    required this.index,
    this.isCurrent = false,
  });
}

List<Player> createPlayers(int playerCount) {
  // Pick one random player to be the current player
  int currentPlayerIndex = Random().nextInt(playerCount);
  List<Player> players = [];
  for (int i = 0; i < playerCount; i++) {
    players.add(Player(
      hand: [],
      name: "Pl${i + 1}", // short name like P1, P2, ...
      index: i,
      isCurrent: i == currentPlayerIndex,
    ));
  }

  return players;
}



