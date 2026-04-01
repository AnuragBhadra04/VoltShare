import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class ProviderListingsScreen extends StatefulWidget {
  const ProviderListingsScreen({super.key});

  @override
  State<ProviderListingsScreen> createState() => _ProviderListingsScreenState();
}

class _ProviderListingsScreenState extends State<ProviderListingsScreen> {
  List evs = [];
  List chargers = [];
  bool loading = true;

  final supabase = ApiService.supabase;

  @override
  void initState() {
    super.initState();
    loadListings();
  }

  Future<void> loadListings() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final evData = await supabase
          .from("evs")
          .select()
          .eq("provider_id", userId);

      final chargerData = await supabase
          .from("chargers")
          .select()
          .eq("provider_id", userId);

      setState(() {
        evs = evData;
        chargers = chargerData;
        loading = false;
      });
    } catch (e) {
      debugPrint("Load listings error: $e");
      setState(() => loading = false);
    }
  }

  /// ================= DELETE =================
  Future<void> deleteItem(String table, String id) async {
    await supabase.from(table).delete().eq("id", id);
    loadListings();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Deleted successfully")));
  }

  /// ================= EDIT DIALOG =================
  void showEditDialog(String table, Map item, bool isEV) {
    final priceController = TextEditingController(
      text: (item["price_per_hour"] ?? item["price_per_unit"]).toString(),
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Price"),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "New Price"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await supabase
                  .from(table)
                  .update(
                    isEV
                        ? {"price_per_hour": double.parse(priceController.text)}
                        : {
                            "price_per_unit": double.parse(
                              priceController.text,
                            ),
                          },
                  )
                  .eq("id", item["id"]);

              Navigator.pop(context);
              loadListings();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget buildCard(Map item, bool isEV) {
    final title = isEV ? item["name"] : "${item["brand"]} ${item["model"]}";

    final price = isEV ? item["price_per_hour"] : item["price_per_unit"];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title ?? ""),
        subtitle: Text("₹$price"),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// EDIT
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () =>
                  showEditDialog(isEV ? "evs" : "chargers", item, isEV),
            ),

            /// DELETE
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () =>
                  deleteItem(isEV ? "evs" : "chargers", item["id"]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("My Listings"),
        backgroundColor: AppColors.primaryPurple,
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// EV SECTION
                  const Text(
                    "My EVs",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...evs.map((e) => buildCard(e, true)),

                  const SizedBox(height: 20),

                  /// CHARGER SECTION
                  const Text(
                    "My Chargers",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...chargers.map((c) => buildCard(c, false)),
                ],
              ),
            ),
    );
  }
}
