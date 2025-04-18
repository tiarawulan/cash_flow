import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Timer untuk navigasi setelah 2 detik
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 245, 245),
      body: Center(
          child: Image.asset(
        'assets/login_1.png',
      )),
    );
  }
}
