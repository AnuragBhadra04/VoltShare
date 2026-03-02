class BookingModel {
  final String? id;
  final String userId;
  final String itemId;
  final String itemType; // 'ev' or 'charger'
  final double amount;
  final String status;
  final DateTime createdAt;

  const BookingModel({
    this.id,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  /// ✅ FROM SUPABASE JSON → BookingModel
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id']?.toString(),
      userId: json['user_id'] ?? '',
      itemId: json['item_id'] ?? '',
      itemType: json['item_type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// ✅ TO SUPABASE JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'item_id': itemId,
      'item_type': itemType,
      'amount': amount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// ✅ COPY WITH (useful for updates)
  BookingModel copyWith({
    String? id,
    String? userId,
    String? itemId,
    String? itemType,
    double? amount,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      itemType: itemType ?? this.itemType,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// ✅ EMPTY MODEL (optional but useful)
  factory BookingModel.empty() {
    return BookingModel(
      id: null,
      userId: '',
      itemId: '',
      itemType: '',
      amount: 0,
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  /// ✅ DEBUG PRINT
  @override
  String toString() {
    return 'BookingModel(id: $id, userId: $userId, itemId: $itemId, itemType: $itemType, amount: $amount, status: $status, createdAt: $createdAt)';
  }
}
