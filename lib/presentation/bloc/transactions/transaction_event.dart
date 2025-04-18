abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class LoadMonthlyStats extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final double amount;
  final String description;
  final String type;
  final String categoryId;

  AddTransaction(
      {required this.amount,
      required this.description,
      required this.type,
      required this.categoryId});
}

class UpdateTransaction extends TransactionEvent {
  final String id;
  final double amount;
  final String description;
  final String type;
  final String categoryId;

  UpdateTransaction(
      {required this.id,
      required this.amount,
      required this.description,
      required this.type,
      required this.categoryId});
}

class DeleteTransaction extends TransactionEvent {
  final String id;

  DeleteTransaction({required this.id});
}
