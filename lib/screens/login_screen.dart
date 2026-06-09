import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'signup_screen.dart';
import 'home_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.04),

                /// =========================
                /// LOGO
                /// =========================
                Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', width: 150),

                      const SizedBox(height: 12),

                      const Text(
                        'PakRescue AI',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'Smart Rescue. Faster Response.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.70),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// =========================
                /// WELCOME
                /// =========================
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Sign in to continue',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 30),

                /// EMAIL
                const Text(
                  'Email',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 10),

                _buildTextField(hint: 'youremail@example.com'),

                const SizedBox(height: 25),

                /// PASSWORD
                const Text(
                  'Password',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),

                const SizedBox(height: 10),

                _buildPasswordField(),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFFE53935), fontSize: 14),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// =========================
                /// SIGN IN BUTTON → HOME DASHBOARD
                /// =========================
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeDashboardScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD62828),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// =========================
                /// SIGN UP (FIXED CLICKABLE TEXT)
                /// =========================
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.70),
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// =========================
  /// EMAIL FIELD
  /// =========================
  Widget _buildTextField({required String hint}) {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
        ),
      ),
    );
  }

  /// =========================
  /// PASSWORD FIELD
  /// =========================
  Widget _buildPasswordField() {
    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        obscureText: obscurePassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '••••••••••',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: Icon(
              obscurePassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
