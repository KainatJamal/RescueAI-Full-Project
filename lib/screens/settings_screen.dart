import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),

      // 🔝 App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D37),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white, // Back arrow color
        ),
        centerTitle: true,
      ),

      // 📱 Body
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _settingsTile(
            icon: Icons.person,
            title: 'Profile',
            onTap: () {
              // TODO: Open profile screen
            },
          ),

          _settingsTile(
            icon: Icons.wifi_tethering,
            title: 'Drone Connectivity',
            onTap: () {
              // TODO: Drone connectivity status
            },
          ),

          _settingsTile(
            icon: Icons.battery_full,
            title: 'Battery Status',
            onTap: () {
              // TODO: Battery details
            },
          ),

          _settingsTile(
            icon: Icons.history,
            title: 'Data Logs',
            onTap: () {
              // TODO: Show flight & rescue logs
            },
          ),

          _settingsTile(
            icon: Icons.info_outline,
            title: 'About App',
            onTap: () {
              _showAboutDialog(context);
            },
          ),

          const SizedBox(height: 20),

          // 🚪 LOGOUT
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              _confirmLogout(context);
            },
          ),
        ],
      ),
    );
  }

  // 🔘 Settings Tile Widget
  Widget _settingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0A1D37)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  // ℹ️ About Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('About PakRescue AI'),
        content: const Text(
          'PakRescue AI is a smart disaster rescue and relief drone system.\n\n'
          'Version: 1.0.0\n'
          'Developed for Final Year Project.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // 🚪 Logout Confirmation
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
