import 'dart:io';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VictimScanScreen extends StatefulWidget {
  const VictimScanScreen({super.key});

  @override
  State<VictimScanScreen> createState() => _VictimScanScreenState();
}

class _VictimScanScreenState extends State<VictimScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late WebSocketChannel _channel;

  bool victimsDetected = false;
  int detectedCount = 0;
  bool scanning = false;

  String? latestRequestId;

  final picker = ImagePicker();
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  List<Map<String, dynamic>> detectedVictims = [];
  Uint8List? imageWithBoxes;

  final String wsUrl = 'ws://192.168.100.24:8000/ws/detect';
  final String httpUrl = 'http://192.168.100.24:8000/detect';

  @override
  void initState() {
    super.initState();

    // 🔔 Initialize notifications
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);
    notifications.initialize(initSettings);

    // 🔄 Radar animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // 🔌 WebSocket connection
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

    _channel.stream.listen((message) async {
      final data = jsonDecode(message);

      if (data['request_id'] != latestRequestId) return;

      setState(() {
        scanning = false;
        detectedCount = data['count'] ?? 0;
        victimsDetected = detectedCount > 0;

        detectedVictims =
            (data['victims'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            [];
      });

      // ✅ DECODE ANNOTATED IMAGE FROM BACKEND
      if (data['image'] != null) {
        final decoded = base64Decode(data['image']);
        setState(() {
          imageWithBoxes = decoded;
        });
      }

      if (victimsDetected) {
        _showNotification(detectedCount);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }

  Future<void> pickAndSendImage() async {
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() {
      scanning = true;
      victimsDetected = false;
      detectedCount = 0;
      detectedVictims = [];
      imageWithBoxes = null;
    });

    await sendImage(File(picked.path));
  }

  Future<void> sendImage(File image) async {
    try {
      final requestId = DateTime.now().millisecondsSinceEpoch.toString();
      latestRequestId = requestId;

      final request = http.MultipartRequest('POST', Uri.parse(httpUrl));

      request.fields['request_id'] = requestId;
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      await request.send();
    } catch (e) {
      debugPrint('Upload error: $e');
      setState(() {
        scanning = false;
      });
    }
  }

  Future<void> _showNotification(int count) async {
    const androidDetails = AndroidNotificationDetails(
      'victim_channel',
      'Victim Alerts',
      channelDescription: 'Detected victims',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await notifications.show(
      0,
      'Victims Detected!',
      '$count victim(s) detected by AI',
      details,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D37),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D37),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'PakRescue AI – Victim Scan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // 🔄 Radar Animation
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 1; i <= 3; i++)
                    Container(
                      width: 60.0 * i,
                      height: 60.0 * i,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3 / i),
                          width: 2,
                        ),
                      ),
                    ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: scanning
                                  ? Colors.greenAccent
                                  : victimsDetected
                                  ? Colors.red
                                  : Colors.white30,
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 2,
                              height: 100,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 📊 Status Card
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        scanning
                            ? 'Scanning...'
                            : victimsDetected
                            ? 'Victims Detected: $detectedCount'
                            : 'No Victims Found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: scanning
                              ? Colors.green
                              : victimsDetected
                              ? Colors.redAccent
                              : Colors.black54,
                        ),
                      ),
                    ),
                    if (scanning)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🖼️ Annotated Image Display
          if (imageWithBoxes != null)
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.memory(
                    imageWithBoxes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 20),

          // 📤 Upload Button
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  'Multi-Model AI Detection Active',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: pickAndSendImage,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.greenAccent, Colors.green],
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Pick Disaster Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
