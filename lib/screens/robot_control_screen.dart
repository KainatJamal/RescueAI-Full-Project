import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RobotControlScreen extends StatefulWidget {
  const RobotControlScreen({super.key});

  @override
  State<RobotControlScreen> createState() => _RobotControlScreenState();
}

class _RobotControlScreenState extends State<RobotControlScreen> {
  bool manualMode = true;
  double speed = 0.50;

  static const Color bg = Color(0xFF050607);
  static const Color panel = Color(0xFF11151B);
  static const Color panel2 = Color(0xFF161B1F);
  static const Color border = Color(0xFF23292D);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color green = Color(0xFF2ECC71);
  static const Color red = Color(0xFFE53935);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: bg,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTopBar(context),
                const SizedBox(height: 16),
                _buildRobotInfoRow(),
                const SizedBox(height: 16),
                _buildManualAutoToggle(),
                const SizedBox(height: 14),
                _buildObstacleWarning(),
                const SizedBox(height: 18),
                _buildDirectionalControls(),
                const SizedBox(height: 18),
                _buildSpeedCard(),
                const SizedBox(height: 12),
                _buildBottomStatusCards(),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.maybePop(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
        const Spacer(),
        const Text(
          'Controls',
          style: TextStyle(
            color: textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 32),
      ],
    );
  }

  Widget _buildRobotInfoRow() {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: panel2,
            border: Border.all(color: border, width: 1),
          ),
          child: const Icon(
            Icons.car_rental_outlined,
            size: 17,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Robot 1',
          style: TextStyle(
            color: textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.15,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF13381F),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            'Connected',
            style: TextStyle(
              color: green,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualAutoToggle() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: panel2,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border, width: 1),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: manualMode
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: red,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => manualMode = true),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Manual',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => manualMode = false),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_outlined,
                          color: manualMode ? Colors.white70 : Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Auto',
                          style: TextStyle(
                            color: manualMode ? Colors.white70 : Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildObstacleWarning() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: red.withOpacity(0.9), width: 1),
      ),
      child: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: red, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obstacle Warning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Obstacle detected ahead at 1.5 m',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionalControls() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundControlButton(
          size: 88,
          background: panel2,
          icon: Icons.keyboard_arrow_up_rounded,
          iconSize: 36,
          label: 'Forward',
          labelColor: textSecondary,
          onTap: () {},
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _RoundControlButton(
              size: 88,
              background: panel2,
              icon: Icons.keyboard_arrow_left_rounded,
              iconSize: 36,
              label: 'Left',
              labelColor: textSecondary,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _RoundControlButton(
              size: 88,
              background: red,
              icon: Icons.stop_rounded,
              iconSize: 32,
              label: 'Stop',
              labelColor: Colors.white,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _RoundControlButton(
              size: 88,
              background: panel2,
              icon: Icons.keyboard_arrow_right_rounded,
              iconSize: 36,
              label: 'Right',
              labelColor: textSecondary,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 10),
        _RoundControlButton(
          size: 88,
          background: panel2,
          icon: Icons.keyboard_arrow_down_rounded,
          iconSize: 36,
          label: 'Backward',
          labelColor: textSecondary,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSpeedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Speed',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(speed * 100).round()}%',
                style: const TextStyle(
                  color: textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              activeTrackColor: red,
              inactiveTrackColor: const Color(0xFF3A4045),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.08),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 11),
              trackShape: const _RoundedTrackShape(),
            ),
            child: Slider(
              value: speed,
              min: 0,
              max: 1,
              onChanged: (value) {
                setState(() => speed = value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomStatusCards() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Battery',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '78%',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B3034),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.78,
                    child: Container(
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: panel,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Signal Strength',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Strong',
                  style: TextStyle(
                    color: green,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _signalBar(12),
                      const SizedBox(width: 4),
                      _signalBar(18),
                      const SizedBox(width: 4),
                      _signalBar(24),
                      const SizedBox(width: 4),
                      _signalBar(30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _signalBar(double height) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: green,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  final double size;
  final Color background;
  final IconData icon;
  final double iconSize;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _RoundControlButton({
    required this.size,
    required this.background,
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.labelColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: iconSize),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundedTrackShape extends SliderTrackShape {
  const _RoundedTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight ?? 4;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final Canvas canvas = context.canvas;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final bgPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor ?? const Color(0xFF3A4045);

    final activePaint = Paint()
      ..color = sliderTheme.activeTrackColor ?? const Color(0xFFD62828);
    final rrect = RRect.fromRectAndRadius(
      trackRect,
      const Radius.circular(999),
    );

    canvas.drawRRect(rrect, bgPaint);

    final activeRect = Rect.fromLTRB(
      trackRect.left,
      trackRect.top,
      thumbCenter.dx,
      trackRect.bottom,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(activeRect, const Radius.circular(999)),
      activePaint,
    );
  }
}
