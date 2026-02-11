import 'package:flutter/material.dart';
import '../role/role_selection_screen.dart';
import '../services/role_service.dart';
import '../auth/auth_screen.dart'; // contains PhoneAuthScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Screen animation
  late AnimationController _screenController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  // Hand wave animation
  late AnimationController _handController;
  late Animation<double> _handWave;

  // 🎨 Colors
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color offWhite = Color(0xFFF8F9FA);

  @override
  void initState() {
    super.initState();

    // Screen fade + slide (once)
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade = CurvedAnimation(parent: _screenController, curve: Curves.easeIn);

    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _screenController, curve: Curves.easeOut),
        );

    _screenController.forward();

    // Hand wave animation (only hand loops)
    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _handWave = Tween<double>(begin: -0.25, end: 0.25).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );

    _handController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _screenController.dispose();
    _handController.dispose();
    super.dispose();
  }

  // ✅ FINAL CORRECT NAVIGATION
  Future<void> _goNext() async {
    final role = await RoleService.getRole();

    if (!mounted) return;

    if (role != null) {
      // Returning user → Phone Auth
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      );
    } else {
      // First time user → Role Selection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 🌟 APP LOGO
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryBlue.withOpacity(0.25),
                            blurRadius: 28,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/app_logo.png',
                        height: 190,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 👋 Hand wave only
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hi ',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: primaryBlue,
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _handWave,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _handWave.value,
                              child: const Text(
                                '👋',
                                style: TextStyle(fontSize: 38),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Welcome to VoltShare',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),

                    const SizedBox(height: 40),

                    // ▶ CONTINUE
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _goNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
