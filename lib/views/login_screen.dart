import 'package:flutter/material.dart';
import 'main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static final Map<String, String> users = {};

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscure = true;

  void login() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (!LoginScreen.users.containsKey(email)) {
       ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      'User is not registered',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
        return;
      }

      if (LoginScreen.users[email] != password) {
       ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    backgroundColor: Colors.red,
    content: Text(
      'Incorrect password',
      style: TextStyle(color: Colors.white),
    ),
  ),
);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Password must contain letters';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain numbers';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(Icons.school_rounded, size: 90),
                const SizedBox(height: 20),
                const Text('Login',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter email';
                    if (!value.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: passwordController,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() => obscure = !obscure);
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: validatePassword,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    child: const Text('Login'),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}