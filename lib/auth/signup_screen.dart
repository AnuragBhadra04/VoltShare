import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import '../permissions/permission_screen.dart';
import '../role/role_selection_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  bool hidePassword = true;
  bool loading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _listenForGoogleCallback();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ===============================
  // ✅ GOOGLE OAUTH DEEP LINK HANDLER
  // ===============================
  void _listenForGoogleCallback() {
    AppLinks().uriLinkStream.listen((uri) async {
      if (!mounted) return;
      if (uri.scheme == 'com.example.ev_community_app' &&
          uri.queryParameters.containsKey('code')) {
        try {
          await supabase.auth.getSessionFromUrl(uri);
          await _createUserProfile(supabase.auth.currentUser!);
          await _goToNext();
        } catch (e) {
          debugPrint('OAuth error: $e');
        }
      }
    });
  }

  // ===============================
  // CREATE PROFILE IF NOT EXISTS
  // ===============================
  Future<void> _createUserProfile(User user) async {
    final existing = await supabase
        .from("users")
        .select()
        .eq("id", user.id)
        .maybeSingle();

    if (existing != null) return;

    try {
      await supabase.from("users").insert({
        "id": user.id,
        "name": user.userMetadata?["name"] ?? nameController.text.trim(),
        "email": user.email,
        "phone": user.phone,
        "photo_url": user.userMetadata?["avatar_url"],
        "role": null,
        "created_at": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint("Profile insert error: $e");
    }
  }

  // ===============================
  // ✅ NAVIGATE AFTER LOGIN
  // ===============================
  Future<void> _goToNext() async {
    if (!mounted) return;

    final session = supabase.auth.currentSession;
    if (session == null) return;

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
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PermissionScreen()),
      );
    }
  }

  // ===============================
  // EMAIL SIGNUP
  // ===============================
  Future<void> signUpUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    try {
      setState(() => loading = true);

      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      if (response.user != null) {
        await _createUserProfile(response.user!);

        if (!mounted) return;

        // ✅ Go directly to role selection after signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (mounted) setState(() => loading = false);
  }

  // ===============================
  // GOOGLE SIGNUP
  // ===============================
  Future<void> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'com.example.ev_community_app://login-callback', // ✅ fixed
      );
      // ✅ Navigation handled by _listenForGoogleCallback
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google login error: $e")));
    }
  }

  // ===============================
  // UI — UNCHANGED
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/app_logo2.png",
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => hidePassword = !hidePassword);
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: loading ? null : signUpUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2ECC71),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Center(child: Text("OR")),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: signInWithGoogle,
                    child: Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.08),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata, size: 28),
                          SizedBox(width: 10),
                          Text(
                            "Continue with Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
