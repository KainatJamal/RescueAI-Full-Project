import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int selectedIndex = 3;
  bool notificationsEnabled = true;
  String selectedLanguage = "English";
  String selectedTheme = "Dark";

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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildSettingsCard(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 1.5,
            ),
            color: const Color(0xFF1A1F24),
          ),
          child: ClipOval(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A3036), Color(0xFF12161A)],
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white70,
                size: 48,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Shahzaib Khan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Team Leader",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.72),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "shahzaib.khan@pakrescue.ai",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF101418),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _settingsTile(
            icon: Icons.person_rounded,
            title: "Profile Information",
            onTap: () {},
          ),
          _divider(),
          _settingsTile(
            icon: Icons.lock_outline_rounded,
            title: "Change Password",
            onTap: () {},
          ),
          _divider(),
          _switchTile(),
          _divider(),
          _settingsTile(
            icon: Icons.language_rounded,
            title: "Language",
            trailingText: selectedLanguage,
            onTap: () {},
          ),
          _divider(),
          _settingsTile(
            icon: Icons.brightness_6_outlined,
            title: "Theme",
            trailingText: selectedTheme,
            onTap: () {},
          ),
          _divider(),
          _settingsTile(
            icon: Icons.info_outline_rounded,
            title: "About PakRescue AI",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    String? trailingText,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.88), size: 22),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
              ),
              if (trailingText != null)
                Text(
                  trailingText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.62),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.55),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: Colors.white.withOpacity(0.88),
            size: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "Notifications",
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
              ),
            ),
          ),
          Switch(
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
            activeColor: const Color(0xFF43B663),
            activeTrackColor: const Color(0xFF43B663),
            inactiveThumbColor: Colors.white70,
            inactiveTrackColor: const Color(0xFF2B3137),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.05),
      indent: 0,
      endIndent: 0,
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 22),
        label: const Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD62828),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF050607),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(index: 0, icon: Icons.home_rounded, label: "Home"),
              _navItem(
                index: 1,
                icon: Icons.shield_outlined,
                label: "Missions",
              ),
              _navItem(index: 2, icon: Icons.group_outlined, label: "Team"),
              _navItem(
                index: 3,
                icon: Icons.settings_outlined,
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
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
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: selected ? const Color(0xFFD62828) : Colors.white54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFFD62828) : Colors.white54,
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
