import 'package:coba_lagi/presentation/screens/add_transaction_screen.dart';
import 'package:coba_lagi/presentation/screens/home_tab.dart';
import 'package:coba_lagi/presentation/screens/loans_payments_screen.dart';
import 'package:coba_lagi/presentation/screens/profile_screen.dart';
import 'package:coba_lagi/presentation/screens/statistic.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screen = [
    const HomeTab(),
    const LoansPaymentsScreen(),
    const AddTransactionScreen(),
    const Statistic(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Highlight selected tab
        onTap: _onItemTapped, // Handle tab selection
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2C8C7B),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.payments), label: 'Finance'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add), label: 'Add Transaction'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Statistics'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
