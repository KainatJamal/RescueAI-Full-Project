import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_dashboard.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF050607),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF050607),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 62),

                /// =========================
                /// TITLE
                /// =========================
                const Text(
                  'Select Your Role',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Choose the role that best describes you',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.62),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 34),

                /// =========================
                /// ADMIN CARD
                /// =========================
                _roleCard(
                  context: context,
                  title: 'Admin',
                  description: 'Manage system, teams,\nmissions and settings.',
                  icon: Icons.admin_panel_settings_rounded,
                ),

                const SizedBox(height: 18),

                /// =========================
                /// RESCUE TEAM CARD
                /// =========================
                _roleCard(
                  context: context,
                  title: 'Rescue Team',
                  description:
                      'Operate robots, view missions\nand respond in real-time.',
                  icon: Icons.groups_rounded,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// ROLE CARD
  /// =========================
  Widget _roleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        height: 182,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: BoxDecoration(
          color: const Color(0xFF11151B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.03)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Row(
          children: [
            /// RED SHIELD ICON
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: Color(0xFFD62828),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 38),
            ),

            const SizedBox(width: 20),

            /// TEXTS
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.62),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW
            Icon(
              Icons.chevron_right_rounded,
              color: Colors.white.withOpacity(0.32),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
