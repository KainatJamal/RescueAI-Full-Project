import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PakRescueApp());
}

class PakRescueApp extends StatelessWidget {
  const PakRescueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PakRescue Camera',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050607),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2ECC71),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const LiveMonitorScreen(),
    );
  }
}

class LiveMonitorScreen extends StatefulWidget {
  const LiveMonitorScreen({super.key});

  @override
  State<LiveMonitorScreen> createState() => _LiveMonitorScreenState();
}

class _LiveMonitorScreenState extends State<LiveMonitorScreen> {
  static const Color bg = Color(0xFF050607);
  static const Color panel = Color(0xFF11151B);
  static const Color border = Color(0xFF23292D);
  static const Color green = Color(0xFF2ECC71);
  static const Color red = Color(0xFFE53935);

  final TextEditingController _baseUrlController = TextEditingController(
    text: 'http://192.168.80.1:8080',
  );
  final TextEditingController _pathController = TextEditingController(
    text: '/video',
  );

  final List<String> _commonPaths = const [
    '/video',
    '/',
    '/mjpeg',
    '/stream',
    '/camera',
    '/cam',
  ];

  int _reloadToken = 0;
  bool _loading = true;
  String? _error;

  String get _cameraUrl {
    final base = _baseUrlController.text.trim().replaceAll(RegExp(r'/+$'), '');
    var path = _pathController.text.trim();
    if (path.isEmpty) path = '/';
    if (!path.startsWith('/')) path = '/$path';
    return '$base$path';
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _pathController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _loading = true;
      _error = null;
      _reloadToken++;
    });
  }

  void _setPath(String path) {
    setState(() {
      _pathController.text = path;
      _loading = true;
      _error = null;
      _reloadToken++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: bg,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      color: Colors.white,
                    ),
                    const Spacer(),
                    const Text(
                      'Live View',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _reload,
                      icon: const Icon(Icons.refresh_rounded),
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: panel,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Base URL',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _baseUrlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'http://192.168.80.1:8080',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0C0F14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (_) => _reload(),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Path',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _pathController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '/video',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.35),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF0C0F14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: border),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (_) => _reload(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 38,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _commonPaths.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final path = _commonPaths[index];
                            return ChoiceChip(
                              label: Text(path),
                              selected: _pathController.text.trim() == path,
                              onSelected: (_) => _setPath(path),
                              selectedColor: green.withOpacity(0.25),
                              backgroundColor: const Color(0xFF0C0F14),
                              labelStyle: TextStyle(
                                color: _pathController.text.trim() == path
                                    ? green
                                    : Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              shape: StadiumBorder(
                                side: BorderSide(color: border),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Current URL: $_cameraUrl',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: panel,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: border),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            '$_cameraUrl?token=$_reloadToken',
                            key: ValueKey('$_cameraUrl-$_reloadToken'),
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                if (_loading) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (mounted) {
                                      setState(() {
                                        _loading = false;
                                        _error = null;
                                      });
                                    }
                                  });
                                }
                                return child;
                              }

                              return _loadingView();
                            },
                            errorBuilder: (context, error, stackTrace) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    _loading = false;
                                    _error = error.toString();
                                  });
                                }
                              });
                              return _errorView(error.toString());
                            },
                          ),
                          if (_loading) _loadingView(),
                          Positioned(top: 12, left: 12, child: _statusBadge()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                _infoCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadingView() {
    return Container(
      color: panel,
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(green),
              ),
            ),
            SizedBox(height: 16),
            Icon(Icons.videocam_rounded, color: Colors.white38, size: 40),
            SizedBox(height: 12),
            Text(
              'Loading camera stream...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorView(String error) {
    return Container(
      color: panel,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, color: red, size: 46),
              const SizedBox(height: 14),
              Text(
                'Camera did not load.\n$error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _reload,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: green,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge() {
    final live = !_loading && _error == null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: live ? green : red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            live ? 'LIVE' : 'NO SIGNAL',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: .4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'HTTP camera view',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _cameraUrl,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
