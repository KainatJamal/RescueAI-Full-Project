import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:image/image.dart' as img;

class LiveCameraScreen extends StatefulWidget {
  const LiveCameraScreen({super.key});

  @override
  State<LiveCameraScreen> createState() => _LiveCameraScreenState();
}

class _LiveCameraScreenState extends State<LiveCameraScreen> {
  CameraController? _controller;
  WebSocketChannel? channel;

  List<dynamic> detections = [];
  int imageWidth = 0;
  int imageHeight = 0;

  bool isSendingFrame = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initWebSocket();
  }

  void _initWebSocket() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.100.24:8000/ws/detect'),
    );

    channel!.stream.listen((message) {
      final data = json.decode(message);

      if (!mounted) return;

      setState(() {
        detections = data['humans'] ?? [];
        imageWidth = data['image_width'];
        imageHeight = data['image_height'];
      });
    });
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.max, // 🔥 better than low
      enableAudio: false,
    );

    await _controller!.initialize();

    _controller!.startImageStream((CameraImage image) async {
      if (isSendingFrame) return;

      isSendingFrame = true;

      try {
        final bytes = await compute(_convertYUV420ToJpeg, image);
        final base64Frame = base64Encode(bytes);
        channel?.sink.add(base64Frame);
      } catch (_) {
      } finally {
        isSendingFrame = false;
      }
    });

    setState(() {});
  }

  static Uint8List _convertYUV420ToJpeg(CameraImage image) {
    final width = image.width;
    final height = image.height;

    final imgData = img.Image(width: width, height: height);

    final yPlane = image.planes[0];
    final uPlane = image.planes[1];
    final vPlane = image.planes[2];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final yIndex = y * yPlane.bytesPerRow + x;
        final uvIndex = (y ~/ 2) * uPlane.bytesPerRow + (x ~/ 2);

        final Y = yPlane.bytes[yIndex];
        final U = uPlane.bytes[uvIndex];
        final V = vPlane.bytes[uvIndex];

        int r = (Y + 1.402 * (V - 128)).clamp(0, 255).toInt();
        int g = (Y - 0.344136 * (U - 128) - 0.714136 * (V - 128))
            .clamp(0, 255)
            .toInt();
        int b = (Y + 1.772 * (U - 128)).clamp(0, 255).toInt();

        imgData.setPixelRgba(x, y, r, g, b, 255);
      }
    }

    return Uint8List.fromList(img.encodeJpg(imgData, quality: 70));
  }

  @override
  void dispose() {
    _controller?.dispose();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          CustomPaint(
            painter: DetectionPainter(
              detections: detections,
              imageWidth: imageWidth,
              imageHeight: imageHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class DetectionPainter extends CustomPainter {
  final List<dynamic> detections;
  final int imageWidth;
  final int imageHeight;

  DetectionPainter({
    required this.detections,
    required this.imageWidth,
    required this.imageHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (detections.isEmpty) return;

    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final double scaleX = size.width / imageWidth;
    final double scaleY = size.height / imageHeight;

    for (var det in detections) {
      double x1 = det['x1'] * scaleX;
      double y1 = det['y1'] * scaleY;
      double x2 = det['x2'] * scaleX;
      double y2 = det['y2'] * scaleY;

      final rect = Rect.fromLTRB(x1, y1, x2, y2);
      canvas.drawRect(rect, paint);

      final textSpan = TextSpan(
        text:
            "ID ${det['id']} ${(det['confidence'] as double).toStringAsFixed(2)}",
        style: const TextStyle(
          color: Colors.green,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.text = textSpan;
      textPainter.layout();
      textPainter.paint(canvas, Offset(x1, y1 - 22));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
