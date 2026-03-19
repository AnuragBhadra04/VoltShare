import 'dart:math';
import '../models/charger_model.dart';

class RecommendationService {
  /// ===============================
  /// GET TOP RECOMMENDED CHARGERS
  /// ===============================
  static List<ChargerModel> recommendChargers({
    required List<ChargerModel> chargers,
    required double userLat,
    required double userLng,
    int limit = 5,
  }) {
    final scored = chargers.map((charger) {
      final distance = _calculateDistance(
        userLat,
        userLng,
        charger.latitude,
        charger.longitude,
      );

      /// Normalize values
      final distanceScore = 1 / (distance + 1);
      final priceScore = 1 / (charger.pricePerUnit + 1);
      final availabilityScore = charger.isAvailable ? 1 : 0;

      /// Placeholder rating (can connect rating table later)
      final ratingScore = 0.8;

      /// Weighted score
      final totalScore =
          (0.4 * distanceScore) +
          (0.3 * priceScore) +
          (0.2 * ratingScore) +
          (0.1 * availabilityScore);

      return {"charger": charger, "score": totalScore};
    }).toList();

    /// Sort by highest score
    scored.sort(
      (a, b) => (b["score"] as double).compareTo(a["score"] as double),
    );

    /// Return top chargers
    return scored.take(limit).map((e) => e["charger"] as ChargerModel).toList();
  }

  /// ===============================
  /// DISTANCE CALCULATION
  /// ===============================
  static double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const R = 6371;

    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }

  static double _toRad(double degree) {
    return degree * pi / 180;
  }
}
