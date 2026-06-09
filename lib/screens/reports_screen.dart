import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedPeriod = "Weekly";

  final List<_MetricItem> metrics = const [
    _MetricItem("Missions", "6"),
    _MetricItem("Victims Found", "24"),
    _MetricItem("Area Scanned", "3.8 km²"),
    _MetricItem("Avg. Response Time", "6m 24s"),
    _MetricItem("Robots Used", "4"),
    _MetricItem("Distance Traveled", "18.6 km"),
  ];

  final List<_MissionLog> logs = const [
    _MissionLog(
      title: "May 24, 2025 - Mission Alpha",
      time: "2:30 PM - 4:45 PM",
    ),
    _MissionLog(
      title: "May 23, 2025 - Mission Bravo",
      time: "10:15 AM - 12:05 PM",
    ),
  ];

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                Row(
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
                          "Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 22),
                  ],
                ),

                const SizedBox(height: 18),

                _buildDateSelector(),

                const SizedBox(height: 12),

                _buildPeriodTabs(),

                const SizedBox(height: 20),

                GridView.builder(
                  itemCount: metrics.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.98,
                  ),
                  itemBuilder: (context, index) {
                    final item = metrics[index];
                    return _buildMetricCard(item);
                  },
                ),

                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Mission Logs",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      "View All",
                      style: TextStyle(
                        color: Color(0xFFD62828),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                ...logs.map(
                  (log) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildLogCard(log),
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD62828),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Export PDF",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF11151B),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.06),
                              ),
                            ),
                          ),
                          child: const Text(
                            "Export CSV",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Center(
              child: Icon(
                Icons.chevron_left,
                color: Colors.white.withOpacity(0.7),
                size: 28,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "May 18 - May 24, 2025",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 26,
            color: Colors.white.withOpacity(0.08),
          ),
          SizedBox(
            width: 54,
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withOpacity(0.75),
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTabs() {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          _buildPeriodTab("Daily"),
          _buildPeriodTab("Weekly"),
          _buildPeriodTab("Monthly"),
        ],
      ),
    );
  }

  Widget _buildPeriodTab(String title) {
    final selected = title == selectedPeriod;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedPeriod = title;
          });
        },
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFD62828) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white.withOpacity(0.72),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(_MetricItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.62),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(_MissionLog log) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  log.time,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.62),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.55),
            size: 28,
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  final String label;
  final String value;

  const _MetricItem(this.label, this.value);
}

class _MissionLog {
  final String title;
  final String time;

  const _MissionLog({required this.title, required this.time});
}
