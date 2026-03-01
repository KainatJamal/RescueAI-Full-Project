import 'package:flutter/material.dart';

class PayloadDropScreen extends StatelessWidget {
  const PayloadDropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D37),

      // 🔝 App Bar
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D37),
        title: const Text(
          'Payload Control',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold, // Optional: bold text
            fontSize: 20, // Optional: font size
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),

              // 📊 Status Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Drone Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),

                    Text('🚁 Drone Height: 12m'),
                    SizedBox(height: 8),
                    Text(
                      '🟢 Drop Zone Status: Safe',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 🔴 DROP PAYLOAD BUTTON
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    _confirmDrop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'DROP PAYLOAD',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ⚠ Safety Note
              const Text(
                '⚠ Safety Note: Confirm before dropping.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🔐 Confirmation Dialog
  void _confirmDrop(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Payload Drop'),
        content: const Text(
          'Are you sure you want to drop the payload?\nEnsure the zone is safe.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // TODO: Send drop command to drone
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payload dropped successfully')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
