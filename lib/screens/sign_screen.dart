import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_bloc.dart';
import 'package:online_shopping/bloc/authentication/auth_event.dart';
import 'package:online_shopping/bloc/authentication/auth_state.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  bool isLoginMode = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (isLoginMode) {
      // Note: Positional arguments must match your LoginWithEmailSubmitted definition
      context.read<AuthBloc>().add(
        LoginWithEmailSubmitted(email: email, password: password),
      );
    } else {
      final userName = _userNameController.text.trim();
      context.read<AuthBloc>().add(
        SignupSubmitted(email: email, password: password, userName: userName),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLoginMode ? "Welcome Back" : "Create Account"),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Email Field ---
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value!.isEmpty ? "Enter email" : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Password Field ---
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) => value!.length < 6 ? "Min 6 characters" : null,
                  ),
                  const SizedBox(height: 16),

                  // --- User Name Field (Only visible in Sign Up Mode) ---
                  if (!isLoginMode) ...[
                    TextFormField(
                      controller: _userNameController,
                      decoration: const InputDecoration(
                        labelText: "User Name",
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      !isLoginMode && value!.isEmpty ? "Enter name" : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // --- Action Button ---
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(isLoginMode ? "Login" : "Sign Up"),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR")),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Google Button ---
                  OutlinedButton.icon(
                    onPressed: () => context.read<AuthBloc>().add(LoginWithGoogleSubmitted()),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                    label: const Text("Continue with Google"),
                  ),

                  // --- Toggle Mode Button ---
                  TextButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      setState(() => isLoginMode = !isLoginMode);
                    },
                    child: Text(isLoginMode
                        ? "Don't have an account? Sign Up"
                        : "Already have an account? Login"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}