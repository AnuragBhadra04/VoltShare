import 'package:supabase_flutter/supabase_flutter.dart';

class MapService {
  final supabase = Supabase.instance.client;

  /// Fetch EV locations
  Future<List<Map<String, dynamic>>> fetchEVs() async {
    final response = await supabase
        .from('evs')
        .select('id,name,latitude,longitude,is_available');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch charger locations
  Future<List<Map<String, dynamic>>> fetchChargers() async {
    final response = await supabase
        .from('chargers')
        .select('id,brand,model,latitude,longitude,is_available');

    return List<Map<String, dynamic>>.from(response);
  }
}
