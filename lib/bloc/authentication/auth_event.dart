import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginWithEmailSubmitted extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailSubmitted({required this.email,required this.password});
}

class LoginWithGoogleSubmitted extends AuthEvent {}

class SignupSubmitted extends AuthEvent {
  final String email;
  final String password;
  final String userName;


  SignupSubmitted({required this.email, required this.password, required this.userName});

  @override
  List<Object?> get props => [email, password, userName];
}
class LogoutRequested extends AuthEvent {}


