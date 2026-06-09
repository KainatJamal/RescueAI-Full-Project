import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'live_monitor.dart';
import 'robot_control_screen.dart';
import 'live_map_screen.dart';
import 'alerts_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'victim_detect_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  int selectedIndex = 0;

  static const Color bg = Color(0xFF050607);
  static const Color cardBg = Color(0xFF11151B);
  static const Color cardBg2 = Color(0xFF151A21);
  static const Color red = Color(0xFFE53935);
  static const Color green = Color(0xFF2ECC71);
  static const Color blue = Color(0xFF2E6BE6);
  static const Color teal = Color(0xFF2FB7A0);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color yellow = Color(0xFFFFB84D);
  static const Color purple = Color(0xFF6D5BD0);

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
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(),
                const SizedBox(height: 18),
                _buildMissionStatus(),
                const SizedBox(height: 14),
                _buildStatsRow(),
                const SizedBox(height: 18),
                _buildLiveAlertsHeader(),
                const SizedBox(height: 10),
                _buildAlertsCard(),
                const SizedBox(height: 16),
                _buildGpsStatusCard(),
                const SizedBox(height: 18),
                _buildLargeActionsRow(),
                const SizedBox(height: 12),
                _buildSmallActionsRow(),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'PakRescue ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              TextSpan(
                text: 'AI',
                style: TextStyle(
                  color: red,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildMissionStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mission Status',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            'Active Mission',
            style: TextStyle(
              color: green,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(title: 'Victims Found', value: '12'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(title: 'Devices Online', value: '4/5'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(title: 'Team Members', value: '18'),
        ),
      ],
    );
  }

  Widget _statCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.62),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveAlertsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Live Alerts',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Text(
          'View All',
          style: TextStyle(
            color: red,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildAlertsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          _alertTile(
            icon: Icons.sos_rounded,
            iconBg: red,
            title: 'Victim Detected',
            subtitle: 'Near Building A',
            time: '2 min ago',
          ),
          _divider(),
          _alertTile(
            icon: Icons.battery_alert_rounded,
            iconBg: orange,
            title: 'Low Battery Warning',
            subtitle: 'Robot 2 - 18%',
            time: '5 min ago',
          ),
          _divider(),
          _alertTile(
            icon: Icons.location_on_rounded,
            iconBg: yellow,
            title: 'GPS Signal Weak',
            subtitle: 'Robot 3',
            time: '7 min ago',
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.06),
      ),
    );
  }

  Widget _alertTile({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.58),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          time,
          style: TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGpsStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GPS Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Strong',
                style: TextStyle(
                  color: green,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Ongoing',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Accuracy: 2.1 m',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLargeActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            label: 'Live View',
            icon: Icons.videocam_rounded,
            background: blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LiveMonitorScreen(),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            label: 'Controls',
            icon: Icons.gamepad_rounded,
            background: teal,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RobotControlScreen(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSmallActionsRow() {
    return Row(
      children: [
        Expanded(
          child: _smallActionButton(
            label: 'Map',
            icon: Icons.map_outlined,
            background: const Color(0xFF2B7A4B),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LiveMapScreen()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: _smallActionButton(
            label: 'Alerts',
            icon: Icons.notifications_active_rounded,
            background: red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlertsScreen()),
              );
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _smallActionButton(
            label: 'Reports',
            icon: Icons.description_outlined,
            background: purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color background,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallActionButton({
    required String label,
    required IconData icon,
    required Color background,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF07090B),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _bottomNavItem(index: 0, icon: Icons.home_rounded, label: 'Home'),
              _bottomNavItem(
                index: 1,
                icon: Icons.person_search_rounded,
                label: 'Victim',
              ),
              _bottomNavItem(
                index: 2,
                icon: Icons.people_alt_outlined,
                label: 'Team',
              ),
              _bottomNavItem(
                index: 3,
                icon: Icons.settings_outlined,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VictimDetectionScreen(),
            ),
          );
        }

        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: selected ? red : Colors.white54),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: selected ? red : Colors.white54,
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
