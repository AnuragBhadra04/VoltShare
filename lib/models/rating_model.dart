class RatingModel {
  final String? id;
  final String userId;
  final String itemId;
  final String itemType; // ev or charger
  final double rating;
  final String? review;
  final DateTime? createdAt;

  const RatingModel({
    this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.rating,
    this.review,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      itemId: json['item_id'] ?? '',
      itemType: json['item_type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      review: json['review'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'item_id': itemId,
      'item_type': itemType,
      'rating': rating,
      'review': review,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
