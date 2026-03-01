import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:permission_handler/permission_handler.dart' as perm;

import 'live_map_screen.dart';
import 'live_camera_screen.dart';
import 'victim_scan_screen.dart';
import 'payload_drop_screen.dart';
import 'settings_screen.dart';
import 'map_screen.dart';
import 'drone_screen.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final Battery _battery = Battery();
  int _batteryLevel = 0;
  bool _gpsActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay to ensure platform channels are ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndUpdate();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkPermissionsAndUpdate();
    }
  }

  /// Check permissions and update battery & GPS
  Future<void> _checkPermissionsAndUpdate() async {
    await _requestLocationPermission();
    await _updateBatteryLevel();
    await _checkGpsStatus();
  }

  /// Request location permission at runtime
  Future<void> _requestLocationPermission() async {
    var status = await perm.Permission.location.status;
    if (!status.isGranted) {
      status = await perm.Permission.location.request();
    }
  }

  /// Update battery level
  Future<void> _updateBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      if (!mounted) return;
      setState(() {
        _batteryLevel = level;
      });

      // Listen to battery state changes
      _battery.onBatteryStateChanged.listen((_) async {
        final level = await _battery.batteryLevel;
        if (!mounted) return;
        setState(() {
          _batteryLevel = level;
        });
      });
    } catch (e) {
      debugPrint('Battery error: $e');
    }
  }

  /// Check GPS status
  Future<void> _checkGpsStatus() async {
    try {
      final serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!mounted) return;
      setState(() {
        _gpsActive = serviceEnabled;
      });

      // Listen to GPS service changes
      geo.Geolocator.getServiceStatusStream().listen((
        geo.ServiceStatus status,
      ) {
        if (!mounted) return;
        setState(() {
          _gpsActive = status == geo.ServiceStatus.enabled;
        });
      });
    } catch (e) {
      debugPrint('GPS error: $e');
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DroneScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D37),
        title: const Text('PakRescue AI'),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Live Status
            Container(
              width: double.infinity,
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
                children: [
                  const Text(
                    'Live Status',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  const Text(
                    '🚁 Drone: Connected',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '🔋 Battery: $_batteryLevel%',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    '📍 GPS: ${_gpsActive ? "Active" : "Inactive"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _gpsActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Dashboard Buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _dashboardButton(
                    icon: Icons.map,
                    label: 'Live Map',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveMapScreen(),
                        ),
                      );
                    },
                  ),
                  _dashboardButton(
                    icon: Icons.videocam,
                    label: 'Live Camera',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LiveCameraScreen(),
                        ),
                      );
                    },
                  ),
                  _dashboardButton(
                    icon: Icons.person_search,
                    label: 'Victim Scan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VictimScanScreen(),
                        ),
                      );
                    },
                  ),
                  _dashboardButton(
                    icon: Icons.inventory_2,
                    label: 'Payload Drop',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PayloadDropScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0A1D37),
        unselectedItemColor: Colors.grey,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplanemode_active),
            label: 'Drone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  static Widget _dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color(0xFF0A1D37)),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
