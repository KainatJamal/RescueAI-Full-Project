import 'package:flutter/material.dart';

class DroneScreen extends StatelessWidget {
  const DroneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Drone Control',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF0A1D37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white, // Back icon color
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drone Status Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Drone Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text('🚁 Connection: Active'),
                  Text('🔋 Battery: 85%'),
                  Text('📍 GPS: Enabled'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Drone Controls Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _controlButton(label: 'Take Off', color: Colors.green),
                  _controlButton(label: 'Land', color: Colors.red),
                  _controlButton(label: 'Hover', color: Colors.orange),
                  _controlButton(
                    label: 'Return',
                    color: Colors.red,
                    icon: Icons.home,
                    onPressed: () {
                      Navigator.pop(context); // Go back to previous screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Control Button Widget
  static Widget _controlButton({
    required String label,
    required Color color,
    IconData? icon,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed ?? () {},
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(label, style: const TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
