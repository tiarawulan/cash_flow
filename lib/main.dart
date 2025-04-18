import 'package:coba_lagi/presentation/bloc/auth/auth_bloc.dart';
import 'package:coba_lagi/presentation/bloc/auth/auth_event.dart';
import 'package:coba_lagi/presentation/bloc/auth/auth_state.dart';
import 'package:coba_lagi/presentation/bloc/transactions/transaction_bloc.dart';
import 'package:coba_lagi/presentation/screens/add_transaction_screen.dart';
import 'package:coba_lagi/presentation/screens/home_screen.dart';
import 'package:coba_lagi/presentation/screens/login_screen.dart';
import 'package:coba_lagi/presentation/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://jkgdfqjcfruykvgsbkxu.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImprZ2RmcWpjZnJ1eWt2Z3Nia3h1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkzMjY1NTMsImV4cCI6MjA1NDkwMjU1M30.YXY4oQ8T537ExPpLvQ03SQa0L359V62kVN5sfUUu4_U');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc()..add(CheckAuthStatus()),
          ),
          BlocProvider<TransactionBloc>(
            create: (context) =>
                TransactionBloc(), // Initialize TransactionBloc here
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: const Color(0xFF68B984),
            useMaterial3: true,
          ),
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginSreen(),
            '/transaction': (context) => const AddTransactionScreen(),
          },
          home: BlocBuilder<AuthBloc, AppAuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AuthAuthenticated) {
                return const HomeScreen();
              } else {
                return const SplashScreen();
              }
            },
          ),
        ));
  }
}
