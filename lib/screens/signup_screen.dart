import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'role_selection_screen.dart';
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool obscurePassword = true;
  bool agree = false;

  String? selectedRole;

  final List<String> roles = ["Rescuer", "Volunteer", "Admin", "Other"];

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Join PakRescue AI",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 30),

                _label("Full Name"),
                const SizedBox(height: 8),
                _field("Enter your full name"),

                const SizedBox(height: 18),

                _label("Email"),
                const SizedBox(height: 8),
                _field("youremail@example.com"),

                const SizedBox(height: 18),

                _label("Password"),
                const SizedBox(height: 8),
                _passwordField(),

                const SizedBox(height: 18),

                _label("Role"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF11151B),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: const Color(0xFF11151B),
                      hint: Text(
                        "Select your role",
                        style: TextStyle(color: Colors.white.withOpacity(0.4)),
                      ),
                      value: selectedRole,
                      isExpanded: true,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      items: roles.map((role) {
                        return DropdownMenuItem(
                          value: role,
                          child: Text(
                            role,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: agree,
                      activeColor: const Color(0xFFE53935),
                      onChanged: (val) {
                        setState(() {
                          agree = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Wrap(
                        children: const [
                          Text(
                            "I agree to the ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Terms & Conditions",
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            " and ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionScreen(),
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
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _field(String hint) {
    return Container(
      height: 55,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(left: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF11151B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: TextField(
        obscureText: obscurePassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Create a strong password",
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
