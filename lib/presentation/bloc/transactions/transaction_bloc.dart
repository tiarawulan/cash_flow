import 'package:coba_lagi/data/models/transaction_model.dart';
import 'package:coba_lagi/data/repositories/transaction_repository.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_event.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kaluna/data/models/transaction_model.dart';
// import 'package:kaluna/data/repositories/transaction_repository.dart';
// import 'package:kaluna/presentation/blocs/transaction/transaction_event.dart';
// import 'package:kaluna/presentation/blocs/transaction/transaction_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TransactionRepository transactionRepository = TransactionRepository();

  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        final response = await supabase
            .from('transactions')
            .select()
            .eq('user_id', supabase.auth.currentUser!.id)
            .order('created_at', ascending: false);
        print(response);
        // Check if the response has data and cast it to List<TransactionModel>
        emit(TransactionLoaded(response
            .map((transaction) => TransactionModel.fromMap(transaction))
            .toList()));
      } catch (error) {
        emit(TransactionError(error.toString()));
      }
    });

    on<AddTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        await supabase.from('transactions').insert({
          'user_id': supabase.auth.currentUser?.id,
          'amount': event.amount,
          'description': event.description,
          'type': event.type,
          'category_id': event.categoryId,
        });
        add(LoadTransactions());
      } catch (error) {
        emit(TransactionError(error.toString()));
      }
    });

    on<UpdateTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        await supabase.from('transactions').update({
          'amount': event.amount,
          'description': event.description,
          'type': event.type,
          'category_id': event.categoryId,
        }).eq('id', event.id);
        add(LoadTransactions());
      } catch (error) {
        emit(TransactionError(error.toString()));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        await supabase.from('transactions').delete().eq('id', event.id);
        add(LoadTransactions());
      } catch (error) {
        emit(TransactionError(error.toString()));
      }
    });

    // Event baru untuk memuat statistik bulanan
    on<LoadMonthlyStats>((event, emit) async {
      emit(TransactionLoading());
      try {
        // Ambil transaksi pengguna
        final transactions = await transactionRepository
            .fetchTransactions(supabase.auth.currentUser!.id);

        // Hitung statistik bulanan
        final monthlyStats =
            transactionRepository.calculateMonthlyStats(transactions);

        emit(MonthlyStatsLoaded(monthlyStats));
      } catch (error) {
        emit(TransactionError(error.toString()));
      }
    });
  }
}
