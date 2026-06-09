import 'dart:async';
import 'package:flutter/material.dart';
// ✅ IMPORT YOUR LOGIN SCREEN
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  final List<String> images = [
    'assets/images/welcome_bg.png',
    'assets/images/welcome_bg4.png',
    'assets/images/welcome_bg2.png',
    'assets/images/welcome_bg3.png',
  ];

  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = currentPage + 1;

        if (nextPage >= images.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050607),
      body: Stack(
        children: [
          // 🔥 BACKGROUND SLIDER
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.asset(images[index], fit: BoxFit.cover);
            },
          ),

          // DARK OVERLAY
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xAA000000),
                    Color(0x77000000),
                    Color(0xE6000000),
                  ],
                ),
              ),
            ),
          ),

          // VIGNETTE
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.1, -0.2),
                  radius: 1.2,
                  colors: [
                    Color(0x00000000),
                    Color(0x3A000000),
                    Color(0xB0000000),
                  ],
                ),
              ),
            ),
          ),

          // UI CONTENT
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 34),

                  Text(
                    'Welcome to',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: size.width * 0.075,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'PakRescue ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.088,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: 'AI',
                          style: TextStyle(
                            color: const Color(0xFFF03A2E),
                            fontSize: size.width * 0.088,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: size.width * 0.76,
                    child: Text(
                      'AI-powered robotics and analytics\nfor faster search, smarter decisions,\nand more lives saved.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: size.width * 0.042,
                        height: 1.42,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 🔵 DOTS (FIXED)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: currentPage == index ? 22 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: currentPage == index
                                ? const Color(0xFFD9302B)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 22),

                  // BUTTON (WHITE TEXT FIXED)
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: const Duration(
                              milliseconds: 700,
                            ),
                            pageBuilder: (_, animation, __) =>
                                const LoginScreen(),
                            transitionsBuilder: (_, animation, __, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(
                                  position:
                                      Tween<Offset>(
                                        begin: const Offset(0.08, 0),
                                        end: Offset.zero,
                                      ).animate(
                                        CurvedAnimation(
                                          parent: animation,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                  child: child,
                                ),
                              );
                            },
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD9302B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white, // ✅ FIXED
                            ),
                          ),
                          SizedBox(width: 12),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 22,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
