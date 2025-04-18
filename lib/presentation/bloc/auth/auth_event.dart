// auth_event.dart
abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  SignUpRequested(
      {required this.email, required this.password, required this.name});
}

class CheckAuthStatus extends AuthEvent {}

class LogoutRequested extends AuthEvent {}
