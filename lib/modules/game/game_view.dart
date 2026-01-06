import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

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
                  _TopBar(mode: mode),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Row(
                      children: [
                        _SidePanel(
                          title: '玩家列表',
                          child: Column(
                            children: const [
                              _PlayerTile(name: '你', chips: 1200, isDealer: true),
                              SizedBox(height: 6),
                              _PlayerTile(name: '玩家A', chips: 980),
                              SizedBox(height: 6),
                              _PlayerTile(name: '玩家B', chips: 1050),
                              SizedBox(height: 6),
                              _PlayerTile(name: '玩家C', chips: 760),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _TableArea(mode: mode),
                        ),
                        const SizedBox(width: 10),
                        _SidePanel(
                          title: '操作区',
                          child: Column(
                            children: const [
                              _ActionButton(label: '跟注', accent: Color(0xFF4DA680)),
                              SizedBox(height: 6),
                              _ActionButton(label: '加注', accent: Color(0xFFB08D32)),
                              SizedBox(height: 6),
                              _ActionButton(label: '看牌', accent: Color(0xFF5B77DB)),
                              SizedBox(height: 6),
                              _ActionButton(label: '比牌', accent: Color(0xFF8E5BAF)),
                              SizedBox(height: 6),
                              _ActionButton(label: '弃牌', accent: Color(0xFFB0444B)),
                            ],
                          ),
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

  const _TableArea({
    required this.mode,
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
          Row(
            children: [
              _StatusChip(label: mode),
              const SizedBox(width: 8),
              const _StatusChip(label: '回合 1/10'),
              const Spacer(),
              const _StatusChip(label: '底池 1200'),
            ],
          ),
          const SizedBox(height: 8),
          const Expanded(
            child: _TableSurface(),
          ),
          const SizedBox(height: 2),
          const _TableSeatCompact(name: '你', chips: 1200, isActive: true),
          const SizedBox(height: 2),
          const SizedBox(
            height: 90,
            child: _HandCardRow(owner: '你的手牌'),
          ),
        ],
      ),
    );
  }
}

class _TableSurface extends StatelessWidget {
  const _TableSurface();

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
        children: const [
          _FeltTexture(),
          Positioned.fill(
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
          Positioned.fill(child: _TableRim()),
          Center(child: _TableCore()),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: _TableSeat(name: '玩家A', chips: 980),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: _TableSeat(name: '玩家B', chips: 1050),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: _TableSeat(name: '玩家C', chips: 760),
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

  const _TopBar({required this.mode});

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
      child: Row(
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
          const Spacer(),
          const Text(
            '基础场',
            style: TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
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

class _PlayerTile extends StatelessWidget {
  final String name;
  final int chips;
  final bool isDealer;

  const _PlayerTile({
    required this.name,
    required this.chips,
    this.isDealer = false,
  });

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: Colors.white10),
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

  const _ActionButton({
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
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
        onPressed: () {},
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accent.withOpacity(0.85),
                accent.withOpacity(0.95),
                accent,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white24),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.35),
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

  const _TableSeat({
    required this.name,
    required this.chips,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive ? const Color(0xFFB08D32) : Colors.white24;
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
                style: const TextStyle(color: Colors.white, fontSize: 9),
              ),
              Text(
                '筹码 $chips',
                style: const TextStyle(color: Colors.white54, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
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
  const _PotWidget();

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
        children: const [
          Text(
            '底池',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
          SizedBox(height: 4),
          Text(
            '1200',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _HandCardRow extends StatelessWidget {
  final String owner;

  const _HandCardRow({
    required this.owner,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            owner,
            style: const TextStyle(color: Colors.white70, fontSize: 8),
          ),
          const SizedBox(height: 3),
          Row(
            children: const [
              _CardPlaceholder(),
              SizedBox(width: 4),
              _CardPlaceholder(),
              SizedBox(width: 4),
              _CardPlaceholder(),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardPlaceholder extends StatelessWidget {
  const _CardPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF2F2F2),
            Color(0xFFD9DDE2),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
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
              width: 10,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFB08D32),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              width: 10,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF2B5A46),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 26,
              height: 34,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white70),
              ),
            ),
          ),
        ],
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
