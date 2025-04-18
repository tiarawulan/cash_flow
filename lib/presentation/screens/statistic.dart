import 'package:coba_lagi/data/repositories/transaction_repository.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_bloc.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_event.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistic extends StatefulWidget {
  const Statistic({super.key});

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadMonthlyStats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: const Color(0xFF2C8C7B),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TransactionError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is MonthlyStatsLoaded) {
              // Menggunakan widget grafik statistik yang telah dibuat
              return Column(
                children: [
                  Expanded(
                    child: MonthlyStatsChart(monthlyStats: state.monthlyStats),
                  ),
                ],
              );
            }
            return Center(child: Text('No data found'));
          },
        ),
      ),
    );
  }
}

class MonthlyStatsChart extends StatelessWidget {
  final List<MonthlyStat> monthlyStats;

  const MonthlyStatsChart({super.key, required this.monthlyStats});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      title: ChartTitle(text: 'Monthly Stats'),
      legend: Legend(isVisible: true),
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'Amount (IDR)'),
      ),
      series: <CartesianSeries<MonthlyStat, String>>[
        ColumnSeries<MonthlyStat, String>(
          name: 'Income',
          dataSource: monthlyStats,
          xValueMapper: (MonthlyStat stat, _) => stat.month,
          yValueMapper: (MonthlyStat stat, _) => stat.income,
          color: Colors.green,
        ),
        ColumnSeries<MonthlyStat, String>(
          name: 'Expense',
          dataSource: monthlyStats,
          xValueMapper: (MonthlyStat stat, _) => stat.month,
          yValueMapper: (MonthlyStat stat, _) => stat.expense,
          color: Colors.red,
        ),
      ],
    );
  }
}
