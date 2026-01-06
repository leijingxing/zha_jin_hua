import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';

class GameController extends GetxController {
  final int baseBet = 10;
  final int maxRound = 10;
  final int turnSeconds = 12;

  final RxList<PlayerModel> players = <PlayerModel>[].obs;
  final RxInt pot = 0.obs;
  final RxInt round = 1.obs;
  final RxInt currentBet = 10.obs;
  final RxInt currentPlayerIndex = 0.obs;
  final RxBool inGame = false.obs;
  final RxInt countdown = 0.obs;
  final RxString statusText = '等待开始'.obs;
  final RxBool revealAll = false.obs;

  final Random _random = Random();
  Timer? _countdownTimer;
  Timer? _aiTimer;
  int _actionCount = 0;
  int _dealerIndex = 0;
  bool _hasStarted = false;

  @override
  void onInit() {
    super.onInit();
    _initPlayers();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    _aiTimer?.cancel();
    super.onClose();
  }

  void _initPlayers() {
    players.assignAll(
      [
        PlayerModel(name: '你', chips: 1200, isHuman: true),
        PlayerModel(name: '玩家A', chips: 980),
        PlayerModel(name: '玩家B', chips: 1050),
        PlayerModel(name: '玩家C', chips: 760),
      ],
    );
  }

  bool get isHumanTurn =>
      inGame.value && currentPlayerIndex.value == 0 && !players[0].isFolded;

  bool get canAct => isHumanTurn && countdown.value > 0;

  bool get canPeek => round.value >= 2;

  bool get canCompare => true;

  int get activePlayerCount =>
      players.where((player) => !player.isFolded).length;

  bool isActivePlayer(int index) {
    if (!inGame.value) {
      return false;
    }
    if (index < 0 || index >= players.length) {
      return false;
    }
    return currentPlayerIndex.value == index && !players[index].isFolded;
  }

  void startGame() {
    _stopCountdown();
    _aiTimer?.cancel();
    if (players.isEmpty) {
      _initPlayers();
    }
    inGame.value = true;
    revealAll.value = false;
    round.value = 1;
    currentBet.value = baseBet;
    pot.value = 0;
    _actionCount = 0;
    if (_hasStarted) {
      _dealerIndex = (_dealerIndex + 1) % players.length;
    } else {
      _dealerIndex = 0;
      _hasStarted = true;
    }

    for (var index = 0; index < players.length; index++) {
      final player = players[index];
      player.resetForRound();
      player.isDealer = index == _dealerIndex;
      if (player.chips < baseBet) {
        player.isFolded = true;
        continue;
      }
      player.chips -= baseBet;
      pot.value += baseBet;
    }

    final deck = _buildDeck()..shuffle(_random);
    _dealCards(deck);
    _resetRoundBets();
    _setCurrentToNextFromDealer();
    players.refresh();
    _announce('新局开始，轮到 ${players[currentPlayerIndex.value].name}');
    _startCountdown();
    _scheduleAiIfNeeded();
  }

  void onFollow() {
    if (!canAct) {
      return;
    }
    final player = players[0];
    _follow(player);
    _afterAction('${player.name}跟注');
  }

  void onRaise() {
    if (!canAct) {
      return;
    }
    final player = players[0];
    if (!canRaise(player)) {
      _afterAction('${player.name}筹码不足，自动弃牌', forcedFold: true);
      return;
    }
    _raise(player);
    _afterAction('${player.name}加注');
  }

  void onPeek() {
    if (!canAct || !canPeek) {
      return;
    }
    final player = players[0];
    if (player.hasSeen) {
      return;
    }
    player.hasSeen = true;
    players.refresh();
    _afterAction('${player.name}看牌');
  }

  void onCompare() {
    if (!canAct || activePlayerCount <= 1) {
      return;
    }
    final player = players[0];
    final opponentIndex = _pickOpponentIndex(0);
    if (opponentIndex == null) {
      return;
    }
    final outcome = _comparePlayers(0, opponentIndex);
    if (outcome == null) {
      _afterAction('${player.name}筹码不足，自动弃牌', forcedFold: true);
      return;
    }
    _afterAction('${player.name}比牌，$outcome');
  }

  void onFold() {
    if (!canAct) {
      return;
    }
    final player = players[0];
    _foldPlayer(player);
    _afterAction('${player.name}弃牌');
  }

  bool canFollow(PlayerModel player) {
    if (!inGame.value) {
      return false;
    }
    final need = _callNeed(player);
    return player.chips >= need;
  }

  bool canRaise(PlayerModel player) {
    if (!inGame.value) {
      return false;
    }
    final newBase = currentBet.value + baseBet;
    final required = _requiredBet(player, base: newBase);
    final need = required - player.roundBet;
    return player.chips >= need;
  }

  void _follow(PlayerModel player) {
    final need = _callNeed(player);
    if (!_pay(player, need)) {
      _foldPlayer(player);
    }
  }

  void _raise(PlayerModel player) {
    currentBet.value += baseBet;
    final required = _requiredBet(player);
    final need = max(0, required - player.roundBet);
    if (!_pay(player, need)) {
      _foldPlayer(player);
    }
  }

  void _afterAction(String message, {bool forcedFold = false}) {
    _stopCountdown();
    if (forcedFold) {
      _foldPlayer(players[currentPlayerIndex.value]);
    }
    players.refresh();
    _announce(message);
    if (_checkGameOver()) {
      return;
    }
    _actionCount++;
    if (_actionCount >= activePlayerCount) {
      round.value += 1;
      _actionCount = 0;
      _resetRoundBets();
    }
    if (round.value > maxRound) {
      _finishByCompare();
      return;
    }
    _moveToNextActive();
    _announce('轮到 ${players[currentPlayerIndex.value].name}');
    _startCountdown();
    _scheduleAiIfNeeded();
  }

  void _startCountdown() {
    _stopCountdown();
    countdown.value = turnSeconds;
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!inGame.value) {
          timer.cancel();
          return;
        }
        countdown.value -= 1;
        if (countdown.value <= 0) {
          timer.cancel();
          _handleTimeout();
        }
      },
    );
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    countdown.value = 0;
  }

  void _handleTimeout() {
    if (!isHumanTurn || !inGame.value) {
      return;
    }
    final player = players[0];
    if (canFollow(player)) {
      _follow(player);
      _afterAction('${player.name}超时自动跟注');
    } else {
      _foldPlayer(player);
      _afterAction('${player.name}超时自动弃牌');
    }
  }

  void _scheduleAiIfNeeded() {
    if (!inGame.value) {
      return;
    }
    if (currentPlayerIndex.value == 0) {
      return;
    }
    _aiTimer?.cancel();
    _aiTimer = Timer(
      const Duration(milliseconds: 900),
      () {
        if (!inGame.value) {
          return;
        }
        if (currentPlayerIndex.value == 0) {
          return;
        }
        final player = players[currentPlayerIndex.value];
        _performAiAction(player);
      },
    );
  }

  void _performAiAction(PlayerModel player) {
    if (player.isFolded) {
      _afterAction('${player.name}已弃牌');
      return;
    }
    if (!player.hasSeen && round.value >= 2 && _random.nextDouble() < 0.35) {
      player.hasSeen = true;
      players.refresh();
      _afterAction('${player.name}看牌');
      return;
    }
    final value = _evaluateHand(player.cards);
    if (value.category <= 2 && round.value >= 2 && _random.nextDouble() < 0.35) {
      _foldPlayer(player);
      _afterAction('${player.name}弃牌');
      return;
    }
    if (value.category >= 5 &&
        activePlayerCount > 1 &&
        _random.nextDouble() < 0.3) {
      final opponentIndex = _pickOpponentIndex(currentPlayerIndex.value);
      if (opponentIndex != null) {
        final outcome =
            _comparePlayers(currentPlayerIndex.value, opponentIndex);
        if (outcome != null) {
          _afterAction('${player.name}比牌，$outcome');
          return;
        }
      }
    }
    if (value.category >= 4 && _random.nextDouble() < 0.45) {
      _raise(player);
      _afterAction('${player.name}加注');
      return;
    }
    _follow(player);
    _afterAction('${player.name}跟注');
  }

  void _dealCards(List<CardModel> deck) {
    for (var roundIndex = 0; roundIndex < 3; roundIndex++) {
      for (final player in players) {
        if (player.isFolded) {
          continue;
        }
        if (deck.isEmpty) {
          continue;
        }
        player.cards.add(deck.removeLast());
      }
    }
  }

  void _resetRoundBets() {
    for (final player in players) {
      player.roundBet = 0;
    }
  }

  void _setCurrentToNextFromDealer() {
    currentPlayerIndex.value = _dealerIndex;
    _moveToNextActive();
  }

  void _moveToNextActive() {
    var nextIndex = currentPlayerIndex.value;
    for (var step = 0; step < players.length; step++) {
      nextIndex = (nextIndex + 1) % players.length;
      if (!players[nextIndex].isFolded) {
        currentPlayerIndex.value = nextIndex;
        return;
      }
    }
  }

  int _requiredBet(PlayerModel player, {int? base}) {
    final effectiveBase = base ?? currentBet.value;
    return player.hasSeen ? effectiveBase * 2 : effectiveBase;
  }

  int _callNeed(PlayerModel player) {
    final required = _requiredBet(player);
    final need = required - player.roundBet;
    return max(0, need);
  }

  bool _pay(PlayerModel player, int amount) {
    if (amount <= 0) {
      return true;
    }
    if (player.chips < amount) {
      return false;
    }
    player.chips -= amount;
    pot.value += amount;
    player.roundBet += amount;
    return true;
  }

  String? _comparePlayers(int aIndex, int bIndex) {
    final player = players[aIndex];
    final opponent = players[bIndex];
    final compareCost = _requiredBet(player);
    if (player.chips < compareCost) {
      return null;
    }
    player.chips -= compareCost;
    pot.value += compareCost;
    final result = _compareHands(player.cards, opponent.cards);
    if (result >= 0) {
      _foldPlayer(opponent);
      return '${player.name}胜过${opponent.name}';
    }
    _foldPlayer(player);
    return '${opponent.name}胜过${player.name}';
  }

  int? _pickOpponentIndex(int fromIndex) {
    for (var step = 1; step < players.length; step++) {
      final index = (fromIndex + step) % players.length;
      if (!players[index].isFolded) {
        return index;
      }
    }
    return null;
  }

  void _foldPlayer(PlayerModel player) {
    player.isFolded = true;
  }

  bool _checkGameOver() {
    final active = players.where((player) => !player.isFolded).toList();
    if (active.length <= 1) {
      final winner = active.isEmpty ? players.first : active.first;
      _finishGame(winner);
      return true;
    }
    return false;
  }

  void _finishByCompare() {
    final winnerIndex = _findBestPlayerIndex();
    _finishGame(players[winnerIndex]);
  }

  int _findBestPlayerIndex() {
    var bestIndex = -1;
    HandValue? bestValue;
    for (var index = 0; index < players.length; index++) {
      final player = players[index];
      if (player.isFolded) {
        continue;
      }
      final value = _evaluateHand(player.cards);
      if (bestValue == null || _compareHandValue(value, bestValue) > 0) {
        bestValue = value;
        bestIndex = index;
      }
    }
    return bestIndex == -1 ? 0 : bestIndex;
  }

  void _finishGame(PlayerModel winner) {
    _stopCountdown();
    _aiTimer?.cancel();
    inGame.value = false;
    revealAll.value = true;
    winner.chips += pot.value;
    pot.value = 0;
    players.refresh();
    _announce('本局结束，${winner.name}胜利');
  }

  void _announce(String text) {
    statusText.value = text;
  }

  List<CardModel> _buildDeck() {
    const suits = ['S', 'H', 'D', 'C'];
    final deck = <CardModel>[];
    for (final suit in suits) {
      for (var rank = 2; rank <= 14; rank++) {
        deck.add(CardModel(rank: rank, suit: suit));
      }
    }
    return deck;
  }

  HandValue _evaluateHand(List<CardModel> cards) {
    final ranks = cards.map((card) => card.rank).toList()..sort();
    final isFlush = cards.every((card) => card.suit == cards.first.suit);
    final isThree = ranks[0] == ranks[1] && ranks[1] == ranks[2];
    var isStraight = false;
    var straightHigh = ranks[2];
    if (ranks[0] + 1 == ranks[1] && ranks[1] + 1 == ranks[2]) {
      isStraight = true;
      straightHigh = ranks[2];
    } else if (ranks[0] == 2 && ranks[1] == 3 && ranks[2] == 14) {
      isStraight = true;
      straightHigh = 3;
    }

    if (isThree) {
      return HandValue(6, [ranks[0]]);
    }
    if (isStraight && isFlush) {
      return HandValue(5, [straightHigh]);
    }
    if (isFlush) {
      return HandValue(4, ranks.reversed.toList());
    }
    if (isStraight) {
      return HandValue(3, [straightHigh]);
    }
    if (ranks[0] == ranks[1] || ranks[1] == ranks[2]) {
      final pairRank = ranks[1];
      final kicker = ranks[0] == ranks[1] ? ranks[2] : ranks[0];
      return HandValue(2, [pairRank, kicker]);
    }
    return HandValue(1, ranks.reversed.toList());
  }

  int _compareHands(List<CardModel> a, List<CardModel> b) {
    final valueA = _evaluateHand(a);
    final valueB = _evaluateHand(b);
    return _compareHandValue(valueA, valueB);
  }

  int _compareHandValue(HandValue a, HandValue b) {
    if (a.category != b.category) {
      return a.category.compareTo(b.category);
    }
    for (var index = 0; index < a.ranks.length; index++) {
      if (index >= b.ranks.length) {
        return 1;
      }
      final diff = a.ranks[index].compareTo(b.ranks[index]);
      if (diff != 0) {
        return diff;
      }
    }
    return 0;
  }
}

class PlayerModel {
  PlayerModel({
    required this.name,
    required this.chips,
    this.isHuman = false,
  });

  final String name;
  final bool isHuman;
  int chips;
  bool isDealer = false;
  bool isFolded = false;
  bool hasSeen = false;
  int roundBet = 0;
  final List<CardModel> cards = [];

  void resetForRound() {
    isFolded = false;
    hasSeen = false;
    roundBet = 0;
    cards.clear();
  }
}

class CardModel {
  CardModel({
    required this.rank,
    required this.suit,
  });

  final int rank;
  final String suit;

  String get rankLabel {
    switch (rank) {
      case 11:
        return 'J';
      case 12:
        return 'Q';
      case 13:
        return 'K';
      case 14:
        return 'A';
      default:
        return '$rank';
    }
  }

  String get code => '$rankLabel$suit';

  String get assetPath => 'assets/images/cards/$code.png';
}

class HandValue {
  HandValue(this.category, this.ranks);

  final int category;
  final List<int> ranks;
}
