import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final String userId;
  final String? email;

  const Authenticated({required this.token, required this.userId, this.email});

  @override
  List<Object?> get props => [token, userId, email];
}

class UnAuthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
