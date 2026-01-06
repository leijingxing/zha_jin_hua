import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'game_controller.dart';

class GameView extends StatelessWidget {
  GameView({super.key});

  final GameController controller = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final mode = (args?['mode'] as String?) ?? '经典模式';
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E12),
      body: SafeArea(
        child: Stack(
          children: [
            const _BackgroundLayer(),
            Positioned(
              top: -120,
              right: -80,
              child: _GlowCircle(
                size: 260,
                color: const Color(0xFFB08D32).withOpacity(0.18),
              ),
            ),
            Positioned(
              bottom: -140,
              left: -60,
              child: _GlowCircle(
                size: 300,
                color: const Color(0xFF1E6A5A).withOpacity(0.18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  _TopBar(mode: mode, controller: controller),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        _SidePanel(
                          title: '玩家列表',
                          child: _PlayerList(controller: controller),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TableArea(
                            mode: mode,
                            controller: controller,
                          ),
                        ),
                        const SizedBox(width: 10),
                        _SidePanel(
                          title: '操作区',
                          child: _ActionPanel(controller: controller),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableArea extends StatelessWidget {
  final String mode;
  final GameController controller;

  const _TableArea({
    required this.mode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1B2028),
            Color(0xFF12161C),
            Color(0xFF151A22),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0x26FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
          BoxShadow(
            color: Color(0x331B1F27),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(
            () => Row(
              children: [
                _StatusChip(label: mode),
                const SizedBox(width: 8),
                _StatusChip(
                  label: '回合 ${controller.round.value}/${controller.maxRound}',
                ),
                const SizedBox(width: 8),
                _StatusChip(label: '底注 ${controller.baseBet}'),
                const SizedBox(width: 8),
                _StatusChip(label: '当前注 ${controller.currentBet.value}'),
                const Spacer(),
                _StatusChip(label: '底池 ${controller.pot.value}'),
                const SizedBox(width: 8),
                _StatusChip(label: '倒计时 ${controller.countdown.value}s'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _TableSurface(controller: controller),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 110,
            child: _HandCardRow(
              owner: '你的手牌',
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

class _TableSurface extends StatelessWidget {
  final GameController controller;

  const _TableSurface({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A5A45),
            Color(0xFF0F3F31),
            Color(0xFF0B2F24),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2B5A46)),
      ),
      child: Stack(
        children: [
          const _FeltTexture(),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.0,
                  colors: [
                    Color(0x001D6A52),
                    Color(0x9910251D),
                  ],
                ),
              ),
            ),
          ),
          const Positioned.fill(child: _TableRim()),
          const Center(child: _TableCore()),
          Obx(
            () => Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _SeatWithCards(
                  player: controller.players[1],
                  isActive: controller.isActivePlayer(1),
                  showFace: controller.inGame.value || controller.revealAll.value,
                  cardWidth: 32,
                  cardHeight: 44,
                ),
              ),
            ),
          ),
          Obx(
            () => Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _SeatWithCards(
                  player: controller.players[2],
                  isActive: controller.isActivePlayer(2),
                  showFace: controller.inGame.value || controller.revealAll.value,
                  cardWidth: 30,
                  cardHeight: 42,
                ),
              ),
            ),
          ),
          Obx(
            () => Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _SeatWithCards(
                  player: controller.players[3],
                  isActive: controller.isActivePlayer(3),
                  showFace: controller.inGame.value || controller.revealAll.value,
                  cardWidth: 30,
                  cardHeight: 42,
                ),
              ),
            ),
          ),
          Obx(
            () => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _PotWidget(amount: controller.pot.value),
                  const SizedBox(height: 6),
                  _StatusChip(label: controller.statusText.value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableRim extends StatelessWidget {
  const _TableRim();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF3A6B56).withOpacity(0.6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _TableCore extends StatelessWidget {
  const _TableCore();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: 160,
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFF0B2B21),
          borderRadius: BorderRadius.circular(48),
          border: Border.all(color: const Color(0xFF3E7A62)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 120,
            height: 66,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF145845),
                  Color(0xFF0E3B2F),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color(0xFF2B5A46)),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String mode;
  final GameController controller;

  const _TopBar({
    required this.mode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF1A1F26),
            Color(0xFF14181E),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Obx(
        () => Row(
          children: [
            const Text(
              '牌桌',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
            _StatusChip(label: mode),
            const SizedBox(width: 8),
            _StatusChip(
              label: controller.inGame.value ? '进行中' : '未开始',
            ),
            const Spacer(),
            _MiniButton(
              label: controller.inGame.value ? '重新开局' : '开始发牌',
              onPressed: controller.startGame,
            ),
          ],
        ),
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final String title;
  final Widget child;

  const _SidePanel({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF171B22),
            Color(0xFF12161C),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerList extends StatelessWidget {
  final GameController controller;

  const _PlayerList({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: List.generate(
          controller.players.length,
          (index) {
            final player = controller.players[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PlayerTile(
                name: player.name,
                chips: player.chips,
                isDealer: player.isDealer,
                isActive: controller.isActivePlayer(index),
                isFolded: player.isFolded,
                hasSeen: player.hasSeen,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionPanel extends StatelessWidget {
  final GameController controller;

  const _ActionPanel({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final player = controller.players.first;
        final canAct = controller.canAct;
        final canFollow = canAct && controller.canFollow(player);
        final canRaise = canAct && controller.canRaise(player);
        final canPeek = canAct && !player.hasSeen && controller.canPeek;
        final canCompare =
            canAct && controller.activePlayerCount > 1 && controller.canCompare;
        return Column(
          children: [
            _ActionButton(
              label: controller.inGame.value ? '重新开局' : '开始发牌',
              accent: const Color(0xFF4DA680),
              enabled: true,
              onPressed: controller.startGame,
            ),
            const SizedBox(height: 6),
            _ActionButton(
              label: '跟注',
              accent: const Color(0xFF4DA680),
              enabled: canFollow,
              onPressed: controller.onFollow,
            ),
            const SizedBox(height: 6),
            _ActionButton(
              label: '加注',
              accent: const Color(0xFFB08D32),
              enabled: canRaise,
              onPressed: controller.onRaise,
            ),
            const SizedBox(height: 6),
            _ActionButton(
              label: '看牌',
              accent: const Color(0xFF5B77DB),
              enabled: canPeek,
              onPressed: controller.onPeek,
            ),
            const SizedBox(height: 6),
            _ActionButton(
              label: '比牌',
              accent: const Color(0xFF8E5BAF),
              enabled: canCompare,
              onPressed: controller.onCompare,
            ),
            const SizedBox(height: 6),
            _ActionButton(
              label: '弃牌',
              accent: const Color(0xFFB0444B),
              enabled: canAct,
              onPressed: controller.onFold,
            ),
          ],
        );
      },
    );
  }
}

class _PlayerTile extends StatelessWidget {
  final String name;
  final int chips;
  final bool isDealer;
  final bool isActive;
  final bool isFolded;
  final bool hasSeen;

  const _PlayerTile({
    required this.name,
    required this.chips,
    this.isDealer = false,
    this.isActive = false,
    this.isFolded = false,
    this.hasSeen = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? const Color(0xFFB08D32) : Colors.white10;
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF161B22),
            Color(0xFF0F1318),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: const Color(0xFF2B313B),
            child: Text(
              name.characters.first,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    if (isDealer)
                      Container(
                        margin: const EdgeInsets.only(left: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB08D32),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '庄',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '筹码 $chips',
                  style: const TextStyle(color: Colors.white70, fontSize: 9),
                ),
                const SizedBox(height: 2),
                Text(
                  isFolded ? '已弃牌' : (hasSeen ? '已看牌' : '未看牌'),
                  style: TextStyle(
                    color: isFolded ? Colors.redAccent : Colors.white38,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color accent;
  final VoidCallback? onPressed;
  final bool enabled;

  const _ActionButton({
    required this.label,
    required this.accent,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = enabled ? accent : accent.withOpacity(0.35);
    return SizedBox(
      height: 38,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: enabled ? onPressed : null,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                displayColor.withOpacity(0.85),
                displayColor.withOpacity(0.95),
                displayColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: displayColor.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 6,
                right: 6,
                top: 4,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _MiniButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor: const Color(0xFF2B313B),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2028),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 10),
      ),
    );
  }
}

class _TableSeat extends StatelessWidget {
  final String name;
  final int chips;
  final bool isActive;
  final bool isFolded;

  const _TableSeat({
    required this.name,
    required this.chips,
    this.isActive = false,
    this.isFolded = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? const Color(0xFFB08D32) : Colors.white24;
    final nameColor = isFolded ? Colors.white38 : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 8,
            backgroundColor: const Color(0xFF2B313B),
            child: Text(
              name.characters.first,
              style: const TextStyle(color: Colors.white, fontSize: 9),
            ),
          ),
          const SizedBox(width: 3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(color: nameColor, fontSize: 9),
              ),
              Text(
                isFolded ? '已弃牌' : '筹码 $chips',
                style: const TextStyle(color: Colors.white54, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatWithCards extends StatelessWidget {
  final PlayerModel player;
  final bool isActive;
  final bool showFace;
  final double cardWidth;
  final double cardHeight;

  const _SeatWithCards({
    required this.player,
    required this.isActive,
    required this.showFace,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TableSeat(
          name: player.name,
          chips: player.chips,
          isActive: isActive,
          isFolded: player.isFolded,
        ),
        const SizedBox(height: 4),
        _SeatCards(
          cards: player.cards,
          showFace: showFace,
          cardWidth: cardWidth,
          cardHeight: cardHeight,
        ),
      ],
    );
  }
}

class _SeatCards extends StatelessWidget {
  final List<CardModel> cards;
  final bool showFace;
  final double cardWidth;
  final double cardHeight;

  const _SeatCards({
    required this.cards,
    required this.showFace,
    required this.cardWidth,
    required this.cardHeight,
  });

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var index = 0; index < 3; index++) {
      if (index > 0) {
        items.add(const SizedBox(width: 3));
      }
      if (cards.length <= index) {
        items.add(_CardBack(width: cardWidth, height: cardHeight));
      } else if (showFace) {
        items.add(
          _CardFace(
            card: cards[index],
            width: cardWidth,
            height: cardHeight,
          ),
        );
      } else {
        items.add(_CardBack(width: cardWidth, height: cardHeight));
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }
}

class _TableSeatCompact extends StatelessWidget {
  final String name;
  final int chips;
  final bool isActive;

  const _TableSeatCompact({
    required this.name,
    required this.chips,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? const Color(0xFFB08D32) : Colors.white24;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0F141B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.18),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFF2B313B),
            child: Text(
              name.characters.first,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              Text(
                '筹码 $chips',
                style: const TextStyle(color: Colors.white54, fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PotWidget extends StatelessWidget {
  final int amount;

  const _PotWidget({
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF212A33),
            Color(0xFF182028),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '底池',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
          const SizedBox(height: 4),
          Text(
            '$amount',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _HandCardRow extends StatelessWidget {
  final String owner;
  final GameController controller;

  const _HandCardRow({
    required this.owner,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF141A22),
            Color(0xFF0F141B),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Obx(
        () {
          final player = controller.players.first;
          final showFace = player.hasSeen || controller.revealAll.value;
          final cards = player.cards;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                owner,
                style: const TextStyle(color: Colors.white70, fontSize: 8),
              ),
              const SizedBox(height: 3),
              Row(
                children: () {
                  final items = <Widget>[];
                  for (var index = 0; index < 3; index++) {
                    Widget cardWidget;
                    if (cards.length <= index) {
                      cardWidget = const _CardBack();
                    } else if (!showFace) {
                      cardWidget = const _CardBack();
                    } else {
                      cardWidget = _CardFace(card: cards[index]);
                    }
                    items.add(cardWidget);
                    if (index < 2) {
                      items.add(const SizedBox(width: 4));
                    }
                  }
                  return items;
                }(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  final double width;
  final double height;

  const _CardBack({
    this.width = 50,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final radius = width * 0.2;
    final cornerWidth = width * 0.18;
    final cornerHeight = height * 0.12;
    final centerWidth = width * 0.52;
    final centerHeight = height * 0.5;
    final textSize = height * 0.2;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B313B),
            Color(0xFF1A1F26),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFB9BEC6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              width: cornerWidth,
              height: cornerHeight,
              decoration: BoxDecoration(
                color: const Color(0xFFB08D32),
                borderRadius: BorderRadius.circular(radius * 0.4),
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: cornerWidth,
              height: cornerHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF5B77DB),
                borderRadius: BorderRadius.circular(radius * 0.4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: centerWidth,
              height: centerHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF1D2430),
                borderRadius: BorderRadius.circular(radius * 0.8),
                border: Border.all(color: Colors.white24),
              ),
              child: Center(
                child: Text(
                  'ZJH',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: textSize,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final CardModel card;
  final double width;
  final double height;

  const _CardFace({
    required this.card,
    this.width = 50,
    this.height = 70,
  });

  @override
  Widget build(BuildContext context) {
    final radius = width * 0.2;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: const Color(0xFFB9BEC6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 8,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        card.assetPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _CardBack(width: width, height: height);
        },
      ),
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  const _BackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0B0E12),
                  Color(0xFF0E1117),
                  Color(0xFF0B0F14),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(child: _NoiseTexture()),
      ],
    );
  }
}

class _NoiseTexture extends StatelessWidget {
  const _NoiseTexture();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.08,
      child: CustomPaint(
        painter: _NoisePainter(),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFFFFFF);
    const step = 18.0;
    for (double y = 8; y < size.height; y += step) {
      for (double x = 8; x < size.width; x += step) {
        final radius = ((x + y) % 6) / 6 + 0.4;
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FeltTexture extends StatelessWidget {
  const _FeltTexture();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: _FeltPainter(),
      ),
    );
  }
}

class _FeltPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1B5A44).withOpacity(0.28);
    const step = 14.0;
    for (double y = 6; y < size.height; y += step) {
      for (double x = 6; x < size.width; x += step) {
        if (((x + y) % 3).floor() == 0) {
          canvas.drawCircle(Offset(x, y), 1.2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}

