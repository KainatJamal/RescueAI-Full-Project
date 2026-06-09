import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VictimDetectionScreen extends StatefulWidget {
  const VictimDetectionScreen({super.key});

  @override
  State<VictimDetectionScreen> createState() => _VictimDetectionScreenState();
}

class _VictimDetectionScreenState extends State<VictimDetectionScreen> {
  int selectedTab = 0;

  final List<String> tabs = const [
    "All (8)",
    "People (6)",
    "Animals (2)",
    "Objects (1)",
  ];

  final List<DetectedEntity> entities = [
    DetectedEntity(
      title: "Person",
      priority: Priority.high,
      timeLocation: "2 min ago • Building A",
      confidence: "90%",
      imagePath: "assets/images/detected_person_1.jpg",
    ),
    DetectedEntity(
      title: "Person",
      priority: Priority.high,
      timeLocation: "4 min ago • Building A",
      confidence: "87%",
      imagePath: "assets/images/detected_person_2.jpg",
    ),
    DetectedEntity(
      title: "Dog",
      priority: Priority.medium,
      timeLocation: "5 min ago • Sector B",
      confidence: "82%",
      imagePath: "assets/images/detected_dog.jpg",
    ),
    DetectedEntity(
      title: "Backpack",
      priority: Priority.low,
      timeLocation: "7 min ago • Building C",
      confidence: "60%",
      imagePath: "assets/images/detected_backpack.jpg",
    ),
  ];

  static const Color bg = Color(0xFF050607);

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 34,
                      ),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Expanded(
                      child: Center(
                        child: Text(
                          "Detected Entities",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 34),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: tabs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final selected = selectedTab == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFD62828)
                                : const Color(0xFF11151B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFFD62828)
                                  : Colors.white.withOpacity(0.04),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tabs[index],
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.68),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: ListView.separated(
                    itemCount: entities.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = entities[index];
                      return _DetectedEntityCard(
                        entity: item,
                        onMarkRescued: () {
                          setState(() {
                            item.isRescued = true;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetectedEntityCard extends StatelessWidget {
  final DetectedEntity entity;
  final VoidCallback onMarkRescued;

  const _DetectedEntityCard({
    required this.entity,
    required this.onMarkRescued,
  });

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFE53935);
      case Priority.medium:
        return const Color(0xFFF2B01E);
      case Priority.low:
        return const Color(0xFF37B24D);
    }
  }

  String getPriorityLabel(Priority priority) {
    switch (priority) {
      case Priority.high:
        return "High Priority";
      case Priority.medium:
        return "Medium Priority";
      case Priority.low:
        return "Low Priority";
    }
  }

  @override
  Widget build(BuildContext context) {
    final priorityColor = getPriorityColor(entity.priority);

    return Container(
      padding: const EdgeInsets.all(10),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 84,
              height: 120,
              child: Image.asset(
                entity.imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF1A1F24),
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.white54,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        entity.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entity.confidence,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  getPriorityLabel(entity.priority),
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  entity.timeLocation,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.58),
                    fontSize: 13.2,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: OutlinedButton(
                    onPressed: entity.isRescued ? null : onMarkRescued,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFF151A1F),
                      side: BorderSide(color: Colors.white.withOpacity(0.06)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Text(
                      entity.isRescued ? "Rescued" : "Mark as Rescued",
                      style: TextStyle(
                        color: entity.isRescued
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetectedEntity {
  final String title;
  final Priority priority;
  final String timeLocation;
  final String confidence;
  final String imagePath;
  bool isRescued;

  DetectedEntity({
    required this.title,
    required this.priority,
    required this.timeLocation,
    required this.confidence,
    required this.imagePath,
    this.isRescued = false,
  });
}

enum Priority { high, medium, low }
