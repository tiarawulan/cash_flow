// Implementasi lengkap auth_bloc.dart
import 'package:coba_lagi/presentation/bloc/auth/auth_event.dart';
import 'package:coba_lagi/presentation/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthBloc extends Bloc<AuthEvent, AppAuthState> {
  final SupabaseClient _supabase = Supabase.instance.client;

  AuthBloc() : super(AuthInitial()) {
    // Sign In
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _supabase.auth.signInWithPassword(
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess(user: response.user!));
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    // Sign Up
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await _supabase.auth.signUp(
          email: event.email,
          password: event.password,
          data: {'name': event.name},
        );
        if (response.user != null) {
          emit(AuthSuccess(user: response.user!));
        } else {
          emit(AuthError(message: 'Sign up failed'));
        }
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    // Sign Out
    on<LogoutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _supabase.auth.signOut();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(message: e.toString()));
      }
    });

    // Check Auth Status
    on<CheckAuthStatus>((event, emit) async {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });
  }
}
