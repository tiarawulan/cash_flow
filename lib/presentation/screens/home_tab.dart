import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_bloc.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_state.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_event.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final User? _user;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
    _user = Supabase.instance.client.auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER (HIJAU)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C8C7B),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header atas (Nama dan Icon Notifikasi)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hai',
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              _user?.userMetadata?['name'] ?? 'Tiara Wulandari',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined,
                              color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // TOTAL BALANCE
                    BlocBuilder<TransactionBloc, TransactionState>(
                      builder: (context, state) {
                        double totalIncome = 0;
                        double totalExpense = 0;

                        if (state is TransactionLoaded) {
                          for (var transaction in state.transactions) {
                            if (transaction.type == 'income') {
                              totalIncome += transaction.amount;
                            } else {
                              totalExpense += transaction.amount;
                            }
                          }
                        }
                        double totalBalance = totalIncome - totalExpense;
                        Color balanceColor =
                            totalBalance < 0 ? Colors.red : Colors.white;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Balance',
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  NumberFormat.simpleCurrency(
                                    locale: 'id_ID',
                                    name: 'Rp',
                                  ).format(totalBalance),
                                  style: TextStyle(
                                    color: balanceColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_horiz,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Kotak Income & Expense
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.arrow_downward,
                                                color: Colors.white, size: 20),
                                            const SizedBox(width: 5),
                                            const Text('Income',
                                                style: TextStyle(
                                                    color: Colors.white70)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.simpleCurrency(
                                            locale: 'id_ID',
                                            name: 'Rp',
                                          ).format(totalIncome),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.arrow_upward,
                                                color: Colors.white, size: 20),
                                            const SizedBox(width: 5),
                                            const Text('Expenses',
                                                style: TextStyle(
                                                    color: Colors.white70)),
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.simpleCurrency(
                                            locale: 'id_ID',
                                            name: 'Rp',
                                          ).format(totalExpense),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                        // ignore: dead_code
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction History',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {}, child: const Text('See all'))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 400,
                      child: BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          if (state is TransactionLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is TransactionLoaded) {
                            final transactions = state.transactions;

                            return ListView.builder(
                              itemCount: transactions.take(5).length,
                              itemBuilder: (context, index) {
                                final transaction = transactions[index];
                                final amountColor = transaction.type == 'income'
                                    ? Colors.green
                                    : Colors.red;

                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Container(
                                    width: 48,
                                    height: 48,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      transaction.type == 'income'
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color:
                                          amountColor, // Menyesuaikan warna ikon sesuai jenis transaksi
                                    ),
                                  ),
                                  title: Text(
                                    transaction
                                        .description!, // Assuming you fetched category name
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(DateFormat('yyyy-MM-dd')
                                      .format(transaction
                                          .createdAt)), // Format as needed
                                  trailing: Text(
                                    NumberFormat.simpleCurrency(
                                      locale: 'id_ID',
                                      name: 'Rp',
                                    ).format(transaction.amount),
                                    style: TextStyle(
                                      color: amountColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    // Navigate to edit page or show transaction details
                                  },
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}