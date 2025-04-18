import 'package:coba_lagi/data/models/transaction_model.dart';
import 'package:coba_lagi/data/repositories/transaction_repository.dart';
// import 'package:kaluna/data/models/transaction_model.dart';
// import 'package:kaluna/data/repositories/transaction_repository.dart';

abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionModel> transactions;

  TransactionLoaded(this.transactions);
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}

class MonthlyStatsLoaded extends TransactionState {
  final List<MonthlyStat> monthlyStats;

  MonthlyStatsLoaded(this.monthlyStats);
}
