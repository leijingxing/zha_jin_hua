import 'package:collection/collection.dart';

import 'player_round_status.dart';
import 'player_id.dart';
import 'playing_card.dart';

/// 玩家在牌桌上的即时状态，采用不可变数据结构便于 Riverpod 管理。
class PlayerState {
  const PlayerState({
    required this.id,
    required this.name,
    required this.isBot,
    required this.stack,
    this.hand = const <PlayingCard>[],
    this.chipsInPot = 0,
    this.hasSeenCards = false,
    this.roundStatus = PlayerRoundStatus.waiting,
  });

  /// 对应的唯一标识。
  final PlayerId id;

  /// 展示给用户的昵称。
  final String name;

  /// 是否为 AI 控制的座位。
  final bool isBot;

  /// 当前剩余筹码数量。
  final int stack;

  /// 当局所持三张牌。
  final List<PlayingCard> hand;

  /// 本局已投入底池的筹码。
  final int chipsInPot;

  /// 是否已经看牌，影响跟注金额。
  final bool hasSeenCards;

  /// 在本局中的阶段状态。
  final PlayerRoundStatus roundStatus;

  /// 是否可以参与后续行动。
  bool get isActive => switch (roundStatus) {
        PlayerRoundStatus.active => true,
        PlayerRoundStatus.allIn => false,
        PlayerRoundStatus.folded => false,
        PlayerRoundStatus.eliminated => false,
        PlayerRoundStatus.waiting => false,
      };

  /// 是否仍在本局内等待结算。
  bool get isInRound => switch (roundStatus) {
        PlayerRoundStatus.active => true,
        PlayerRoundStatus.allIn => true,
        PlayerRoundStatus.folded => false,
        PlayerRoundStatus.eliminated => false,
        PlayerRoundStatus.waiting => false,
      };

  /// 快速判定玩家是否需要摊牌或比较大小。
  bool get shouldShowdown =>
      roundStatus == PlayerRoundStatus.active ||
      roundStatus == PlayerRoundStatus.allIn;

  /// 使用 copyWith 生成新的 [PlayerState]。
  PlayerState copyWith({
    PlayerId? id,
    String? name,
    bool? isBot,
    int? stack,
    List<PlayingCard>? hand,
    int? chipsInPot,
    bool? hasSeenCards,
    PlayerRoundStatus? roundStatus,
  }) {
    return PlayerState(
      id: id ?? this.id,
      name: name ?? this.name,
      isBot: isBot ?? this.isBot,
      stack: stack ?? this.stack,
      hand: hand ?? this.hand,
      chipsInPot: chipsInPot ?? this.chipsInPot,
      hasSeenCards: hasSeenCards ?? this.hasSeenCards,
      roundStatus: roundStatus ?? this.roundStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          other.id == id &&
          other.name == name &&
          other.isBot == isBot &&
          other.stack == stack &&
          other.chipsInPot == chipsInPot &&
          other.hasSeenCards == hasSeenCards &&
          other.roundStatus == roundStatus &&
          const ListEquality<PlayingCard>().equals(other.hand, hand);

  @override
  int get hashCode => Object.hash(
        id,
        name,
        isBot,
        stack,
        chipsInPot,
        hasSeenCards,
        roundStatus,
        Object.hashAll(hand),
      );
}
