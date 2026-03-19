class PricingService {
  static double calculateDynamicPrice({
    required double basePrice,
    required int activeBookings,
    required int nearbyUsers,
    required int availableChargers,
  }) {
    double demandScore =
        (activeBookings * 0.5) +
        (nearbyUsers * 0.3) -
        (availableChargers * 0.2);

    double multiplier;

    if (demandScore < 3) {
      multiplier = 1.0;
    } else if (demandScore < 6) {
      multiplier = 1.3;
    } else if (demandScore < 10) {
      multiplier = 1.6;
    } else {
      multiplier = 2.0;
    }

    return basePrice * multiplier;
  }
}
