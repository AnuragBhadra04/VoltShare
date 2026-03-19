import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// ============================================
  /// LISTEN FOR GOOGLE LOGIN SUCCESS
  /// ============================================
  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((data) async {
      final session = data.session;

      if (session != null && mounted) {
        await _createUserProfile(session.user);

        Navigator.pop(context);
      }
    });
  }

  /// ============================================
  /// DISPOSE CONTROLLERS
  /// ============================================
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  /// ============================================
  /// CREATE USER PROFILE
  /// ============================================
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

  /// ============================================
  /// EMAIL SIGNUP
  /// ============================================
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created successfully")),
          );

          Navigator.pop(context);
        }
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    if (mounted) setState(() => loading = false);
  }

  /// ============================================
  /// GOOGLE LOGIN
  /// ============================================
  Future<void> signInWithGoogle() async {
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Google login error: $e")));
    }
  }

  /// ============================================
  /// UI
  /// ============================================
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

                  /// NAME
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

                  /// EMAIL
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

                  /// PASSWORD
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
                          setState(() {
                            hidePassword = !hidePassword;
                          });
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

                  /// SIGNUP BUTTON
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

                  /// GOOGLE BUTTON
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
