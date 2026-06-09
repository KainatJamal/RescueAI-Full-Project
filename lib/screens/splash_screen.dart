import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'welcome.dart';

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
      title: 'PakRescue AI',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050607),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _fadeIn;
  late final Animation<double> _progress;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _logoScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    _progress = Tween<double>(begin: 0.08, end: 0.78).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    _controller.forward();

    _timer = Timer(const Duration(seconds: 4), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(_createRoute(const WelcomeScreen()));
    });
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 850),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

        final scale = Tween<double>(begin: 0.985, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

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
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/background.png', fit: BoxFit.cover),

            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xB20A0D11),
                    Color(0x7A0A0D11),
                    Color(0xE80A0D11),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final w = constraints.maxWidth;
                  final h = constraints.maxHeight;

                  return Stack(
                    children: [
                      Positioned(
                        top: h * 0.22,
                        left: 0,
                        right: 0,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                width: w * 0.60,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: h * 0.44,
                        left: 0,
                        right: 0,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'PakRescue ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.078,
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'AI',
                                    style: TextStyle(
                                      color: const Color(0xFFE53935),
                                      fontSize: w * 0.078,
                                      fontWeight: FontWeight.w800,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: h * 0.525,
                        left: 0,
                        right: 0,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: Center(
                            child: Text(
                              'Smart Rescue. Faster Response.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.78),
                                fontSize: w * 0.040,
                                fontWeight: FontWeight.w400,
                                height: 1.15,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: w * 0.16,
                        right: w * 0.16,
                        bottom: h * 0.105,
                        child: FadeTransition(
                          opacity: _fadeIn,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2D31),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: AnimatedBuilder(
                                    animation: _progress,
                                    builder: (context, child) {
                                      return FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: _progress.value,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xFFE83D35),
                                                Color(0xFFDD2E2E),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.62),
                                  fontSize: w * 0.034,
                                  fontWeight: FontWeight.w400,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
