// auth_state.dart
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AppAuthState {} // Diubah dari AuthState menjadi AppAuthState

class AuthInitial extends AppAuthState {}

class AuthLoading extends AppAuthState {}

class AuthAuthenticated extends AppAuthState {}

class AuthUnauthenticated extends AppAuthState {}

class AuthSuccess extends AppAuthState {
  final User user;

  AuthSuccess({required this.user});
}

class AuthError extends AppAuthState {
  final String message;

  AuthError({required this.message});
}
