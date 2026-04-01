import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ev_community_app/role/role_selection_screen.dart';
import '../auth/signin_screen.dart';
import '../permissions/permission_screen.dart';
import '../services/auth_service.dart';

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

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

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

    _handController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _handWave = Tween<double>(begin: -0.25, end: 0.25).animate(
      CurvedAnimation(parent: _handController, curve: Curves.easeInOut),
    );

    _handController.repeat(reverse: true);

    /// ✅ Use post-frame to avoid navigation issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), _goNext);
    });
  }

  @override
  void dispose() {
    _screenController.dispose();
    _handController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    if (!mounted) return;

    final session = supabase.auth.currentSession;

    if (session == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      );
      return;
    }

    AuthService.createUserProfileIfNotExists();

    final row = await supabase
        .from("users")
        .select("role")
        .eq("id", session.user.id)
        .maybeSingle();

    if (!mounted) return;

    final role = row?["role"];

    if (role == null || role == '') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PermissionScreen()),
    );
  }

  void _navigate(Widget screen) {
    if (_navigated) return;
    _navigated = true;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
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
