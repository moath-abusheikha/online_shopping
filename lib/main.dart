import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_event.dart';
import 'package:online_shopping/repository/auth_repository.dart'; // Import your repository
import 'package:online_shopping/screens/auth_gate.dart';
import 'package:online_shopping/theme_global.dart';

void main() {
  // 1. Initialize the repository outside the build method
  final authRepository = AuthRepository();

  runApp(OnlineShopping(authRepository: authRepository));
}

class OnlineShopping extends StatelessWidget {
  final AuthRepository authRepository;

  // 2. Pass the repository through the constructor
  const OnlineShopping({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // 3. Provide the repository to the AuthBloc
      create: (context) => AuthBloc(authRepository: authRepository)..add(AuthCheckRequested()),
      child: MaterialApp(
        title: "Online Shopping",
        debugShowCheckedModeBanner: false,
        theme: MyAppTheme.myTheme,
        home: const AuthGate(),
      ),
    );
  }
}