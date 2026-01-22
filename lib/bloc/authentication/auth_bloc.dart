import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginWithEmailSubmitted>(_onLoginSubmitted);
    on<SignupSubmitted>(_onSignupSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      final token = await authRepository.getToken();
      if (token == null) {
        emit(UnAuthenticated());
        return;
      }

      final isValid = await authRepository.verifyToken(token);
      if (isValid) {
        emit(Authenticated(token: token, userId: "from_token"));
      } else {
        await authRepository.logout();
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(UnAuthenticated());
    }
  }

  Future<void> _onLoginSubmitted(LoginWithEmailSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.login(event.email, event.password);

      // Access Map values using square brackets ['key']
      if (response != null && response.containsKey('token')) {
        final token = response['token'] as String;
        final userId = response['userId'] as String; // Corrected bracket notation

        await authRepository.saveToken(token);
        emit(Authenticated(token: token, userId: userId));
      } else {
        emit(AuthFailure("Invalid email or password"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onSignupSubmitted(SignupSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await authRepository.register(event.email, event.password,event.userName);

      // Access Map values using square brackets ['key']
      if (response != null && response.containsKey('token')) {
        final token = response['token'] as String;
        final userId = response['userId'] as String; // Corrected bracket notation

        await authRepository.saveToken(token);
        emit(Authenticated(token: token, userId: userId));
      } else {
        emit(AuthFailure("Registration failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(UnAuthenticated());
  }
}