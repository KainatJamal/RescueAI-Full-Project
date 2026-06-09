import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertItem> alerts = [
    AlertItem(
      icon: Icons.groups_rounded,
      iconBg: const Color(0xFFD63A3A),
      title: "Victim Detected",
      subtitle: "Near Building A",
      time: "2 min ago",
      type: "New victim detected",
      severity: "High",
      isRead: false,
    ),
    AlertItem(
      icon: Icons.warning_amber_rounded,
      iconBg: const Color(0xFFFFA726),
      title: "Obstacle Detected",
      subtitle: "Front Sensor - Robot 2",
      time: "3 min ago",
      type: "Obstacle detected",
      severity: "Medium",
      isRead: false,
    ),
    AlertItem(
      icon: Icons.battery_1_bar_rounded,
      iconBg: const Color(0xFFFFB020),
      title: "Low Battery Warning",
      subtitle: "Robot 2 - 18%",
      time: "5 min ago",
      type: "Low battery",
      severity: "Medium",
      isRead: true,
    ),
    AlertItem(
      icon: Icons.wifi_tethering_rounded,
      iconBg: const Color(0xFF7B5CF0),
      title: "GPS Signal Lost",
      subtitle: "Robot 3",
      time: "7 min ago",
      type: "GPS lost",
      severity: "High",
      isRead: true,
    ),
    AlertItem(
      icon: Icons.wifi_off_rounded,
      iconBg: const Color(0xFF3D7DDB),
      title: "Network Disconnected",
      subtitle: "Check Connection",
      time: "8 min ago",
      type: "Network disconnected",
      severity: "High",
      isRead: true,
    ),
  ];

  static const Color bg = Color(0xFF050607);
  static const Color cardBg = Color(0xFF101418);
  static const Color red = Color(0xFFD63A3A);
  static const Color green = Color(0xFF2ECC71);

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Alerts",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _markAllAsRead,
                      child: const Text(
                        "Mark all as read",
                        style: TextStyle(
                          color: red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == alerts.length - 1 ? 0 : 12,
                      ),
                      child: _buildAlertCard(alert),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertCard(AlertItem alert) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: cardBg,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: alert.iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(alert.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: alert.isRead
                              ? Colors.white.withOpacity(0.86)
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      alert.time,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        alert.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: alert.isRead
                            ? Colors.white.withOpacity(0.14)
                            : red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _chip(
                      text: alert.type,
                      bg: Colors.white.withOpacity(0.06),
                      textColor: Colors.white.withOpacity(0.78),
                    ),
                    const SizedBox(width: 8),
                    _chip(
                      text: alert.severity,
                      bg: alert.severity == "High"
                          ? red.withOpacity(0.15)
                          : green.withOpacity(0.15),
                      textColor: alert.severity == "High" ? red : green,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String text,
    required Color bg,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < alerts.length; i++) {
        alerts[i].isRead = true;
      }
    });
  }
}

class AlertItem {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String time;
  final String type;
  final String severity;
  bool isRead;

  AlertItem({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    required this.severity,
    required this.isRead,
  });
}
