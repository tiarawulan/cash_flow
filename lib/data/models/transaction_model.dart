import 'package:uuid/uuid.dart';

class TransactionModel {
  final String id;
  final String userId;
  final double amount;
  final String? description;
  final String type; // 'income' or 'expense'
  final String categoryId;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    this.description,
    required this.type,
    required this.categoryId,
    required this.createdAt,
  });

  // Factory constructor untuk membuat TransactionModel dari map Supabase
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ??
          Uuid().v4(), // Menggunakan UUID yang dihasilkan jika tidak ada
      userId: map['user_id'],
      amount: (map['amount'] is int)
          ? (map['amount'] as int)
              .toDouble() // Mengonversi ke double jika diperlukan
          : map['amount'],
      description: map['description'],
      type: map['type'],
      categoryId: map['category_id'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // Mengonversi TransactionModel ke map untuk dikirim ke Supabase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'description': description,
      'type': type,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
