import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../role/role_selection_screen.dart';
import '../services/role_service.dart';
import '../auth/signin_screen.dart';

import '../consumer/consumer_home_screen.dart';
import '../provider/provider_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _screenController;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late AnimationController _handController;
  late Animation<double> _handWave;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    /// Screen animation
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fade = CurvedAnimation(parent: _screenController, curve: Curves.easeIn);

    _slide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _screenController, curve: Curves.easeOut),
        );

    _screenController.forward();

    /// Hand wave animation
    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _handWave = Tween<double>(begin: -0.25, end: 0.25).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );

    _handController.repeat(reverse: true);

    /// Start routing after delay
    Future.delayed(const Duration(seconds: 2), _goNext);
  }

  @override
  void dispose() {
    _screenController.dispose();
    _handController.dispose();
    super.dispose();
  }

  /// ROUTING LOGIC
  Future<void> _goNext() async {
    final session = supabase.auth.currentSession;
    final role = await RoleService.getRole();

    if (!mounted) return;

    /// ROLE NOT CHOSEN
    if (role == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
      return;
    }

    /// ROLE CHOSEN BUT USER NOT LOGGED IN
    if (session == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      );
      return;
    }

    /// ROLE + LOGIN OK
    if (role == "consumer") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ConsumerHomeScreen()),
      );
    } else if (role == "provider") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProviderHomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF7A74D8),
              Color(0xFF5E8DAA),
              Color(0xFF5BC97C),
              Color(0xFF2F4F4F),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
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
                      /// LOGO
                      Container(
                        height: 220,
                        width: 220,

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),

                        child: Center(
                          child: Image.asset(
                            "assets/images/app_logo.png",
                            width: 160,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// Greeting
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Hi ",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),

                          AnimatedBuilder(
                            animation: _handWave,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _handWave.value,
                                child: const Text(
                                  "👋",
                                  style: TextStyle(fontSize: 34),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Welcome to VoltShare",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
