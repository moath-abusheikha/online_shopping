import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_state.dart';
import 'package:online_shopping/screens/sign_screen.dart';
import 'home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomeScreen();
        }
        if (state is UnAuthenticated || state is AuthFailure) {
          return const SignScreen();
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 15),
                Text("Checking Session...", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        );
      },
    );
  }
}
