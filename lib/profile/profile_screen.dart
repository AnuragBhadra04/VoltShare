import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/role_service.dart';
import '../models/user_model.dart';
import '../auth/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? user;
  String? role;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final profile = await AuthService.getCurrentUserProfile();
    final r = await RoleService.getRole();

    setState(() {
      user = profile;
      role = r;
      loading = false;
    });
  }

  Future<void> logout() async {
    await AuthService.logout();
    await RoleService.clearRole();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PhoneAuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isProvider = role == "provider";

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            /// PROFILE IMAGE
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoUrl != null
                  ? NetworkImage(user!.photoUrl!)
                  : null,
              child: user?.photoUrl == null
                  ? const Icon(Icons.person, size: 40)
                  : null,
            ),

            const SizedBox(height: 20),

            /// NAME
            Text(
              user?.name ?? "User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// EMAIL
            Text(user?.email ?? "", style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            /// ROLE BADGE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isProvider ? Colors.orange : Colors.green,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isProvider ? "EV Provider" : "Service User",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// PROVIDER EXTRA INFO
            if (isProvider)
              ListTile(
                leading: const Icon(Icons.ev_station),
                title: const Text("Provider Dashboard"),
                subtitle: const Text("Manage your EV / Chargers"),
              ),

            /// CONSUMER INFO
            if (!isProvider)
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Ride History"),
                subtitle: const Text("View previous bookings"),
              ),

            const Spacer(),

            /// LOGOUT
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                child: const Text("Logout", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
