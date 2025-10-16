import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:characters/characters.dart';

import '../models/card_suit.dart';
import '../models/round_stage.dart';
import '../providers/game_preview_provider.dart';
import '../models/player_state.dart';
import '../models/player_round_status.dart';
import '../models/playing_card.dart';
import '../state/game_table_state.dart';
import '../../app/app_bootstrap.dart';

/// 演示用牌桌页面，展示当前局面及玩家座位。
class GameTablePage extends ConsumerWidget {
  const GameTablePage({super.key});

  /// 应用路由路径。
  static const String routePath = '/table';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GameTableState state = ref.watch(gamePreviewProvider);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('演示牌桌'),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, _) {
              final bool isProd = ref.watch(appConfigProvider).isProd;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    isProd ? '正式环境' : '开发环境',
                    style: textTheme.labelLarge,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF0B1F3A), Color(0xFF14294C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _PotInfoBanner(state: state),
              const SizedBox(height: 24),
              Expanded(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double tableSize = constraints.maxWidth * 0.72;
                    return Center(
                      child: SizedBox(
                        width: tableSize,
                        child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 2,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _CommunityInfo(state: state),
                                  const SizedBox(height: 28),
                                  Wrap(
                                    spacing: 18,
                                    runSpacing: 18,
                                    alignment: WrapAlignment.center,
                                    children: state.players
                                        .map(
                                          (PlayerState player) => _PlayerSeatCard(
                                            player: player,
                                            isActive: player.id ==
                                                state.activePlayer.id,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PotInfoBanner extends StatelessWidget {
  const _PotInfoBanner({required this.state});

  final GameTableState state;

  String _stageLabel() {
    switch (state.stage) {
      case RoundStage.waitingPlayers:
        return '等待玩家';
      case RoundStage.collectingAnte:
        return '收取底注';
      case RoundStage.dealing:
        return '发牌中';
      case RoundStage.betting:
        return '下注阶段';
      case RoundStage.showdown:
        return '摊牌';
      case RoundStage.settlement:
        return '结算中';
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('当前阶段：${_stageLabel()}', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('底池筹码：${state.potAmount}',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('当前注额：${state.currentBet}', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('庄家座位：${state.dealerIndex + 1}',
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityInfo extends StatelessWidget {
  const _CommunityInfo({required this.state});

  final GameTableState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '第 ${state.roundIndex} 局',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          '轮到：${state.activePlayer.name}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _PlayerSeatCard extends StatelessWidget {
  const _PlayerSeatCard({
    required this.player,
    required this.isActive,
  });

  final PlayerState player;
  final bool isActive;

  String _statusLabel() {
    switch (player.roundStatus) {
      case PlayerRoundStatus.waiting:
        return '等待中';
      case PlayerRoundStatus.active:
        return '行动中';
      case PlayerRoundStatus.folded:
        return '已弃牌';
      case PlayerRoundStatus.allIn:
        return '全压';
      case PlayerRoundStatus.eliminated:
        return '已出局';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isActive
        ? const Color(0xFFD97706)
        : Colors.white.withOpacity(0.12);
    final TextTheme textTheme = Theme.of(context).textTheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 18,
                backgroundColor: isActive ? borderColor : Colors.white,
                child: Text(
                  player.name.characters.first,
                  style: TextStyle(
                    color: isActive ? Colors.black : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(player.name, style: textTheme.titleMedium),
                  Text(
                    _statusLabel(),
                    style:
                        textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('筹码：${player.stack}', style: textTheme.bodyMedium),
          Text('已入池：${player.chipsInPot}', style: textTheme.bodySmall),
          if (player.hasSeenCards) ...<Widget>[
            const SizedBox(height: 10),
            Text('已看牌', style: textTheme.bodySmall),
          ],
          if (player.hand.isNotEmpty) ...<Widget>[
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: player.hand
                  .map((PlayingCard card) => _CardChip(card: card))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _CardChip extends StatelessWidget {
  const _CardChip({required this.card});

  final PlayingCard card;

  @override
  Widget build(BuildContext context) {
    final bool isRed =
        card.suit == CardSuit.hearts || card.suit == CardSuit.diamonds;
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        '${card.rank.value}${card.suit.symbol}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isRed ? const Color(0xFFFFA8A8) : Colors.white,
            ),
      ),
    );
  }
}
