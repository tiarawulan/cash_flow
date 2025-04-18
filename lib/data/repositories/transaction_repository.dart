import 'package:coba_lagi/data/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<TransactionModel>> fetchTransactions(String userId) async {
    final response = await _supabaseClient
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (response == null) {
      throw Exception('Failed to fetch transactions');
    }

    return (response as List)
        .map((transaction) => TransactionModel.fromMap(transaction))
        .toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final response = await _supabaseClient
        .from('transactions')
        .insert(transaction.toMap())
        .select();

    if (response == null) {
      throw Exception('Failed to add transaction');
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final response = await _supabaseClient
        .from('transactions')
        .update(transaction.toMap())
        .eq('id', transaction.id)
        .select();

    if (response == null) {
      throw Exception('Failed to update transaction');
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    final response = await _supabaseClient
        .from('transactions')
        .delete()
        .eq('id', transactionId);

    if (response == null) {
      throw Exception('Failed to delete transaction');
    }
  }

  // Fungsi untuk menghitung statistik bulanan
  List<MonthlyStat> calculateMonthlyStats(List<TransactionModel> transactions) {
    Map<String, double> monthlyIncome = {};
    Map<String, double> monthlyExpense = {};

    for (var transaction in transactions) {
      String month = DateFormat('MMM yyyy')
          .format(transaction.createdAt); // Format bulan dan tahun

      if (transaction.type == 'income') {
        monthlyIncome[month] = (monthlyIncome[month] ?? 0) + transaction.amount;
      } else if (transaction.type == 'expense') {
        monthlyExpense[month] =
            (monthlyExpense[month] ?? 0) + transaction.amount;
      }
    }

    List<MonthlyStat> monthlyStats = [];
    for (var month in monthlyIncome.keys) {
      monthlyStats.add(MonthlyStat(
        month: month,
        income: monthlyIncome[month] ?? 0,
        expense: monthlyExpense[month] ?? 0,
      ));
    }

    // Mengurutkan berdasarkan bulan
    monthlyStats.sort((a, b) => DateFormat('MMM yyyy')
        .parse(a.month)
        .compareTo(DateFormat('MMM yyyy').parse(b.month)));

    return monthlyStats;
  }
}

// Kelas model untuk menyimpan statistik bulanan
class MonthlyStat {
  final String month;
  final double income;
  final double expense;

  MonthlyStat(
      {required this.month, required this.income, required this.expense});
}
