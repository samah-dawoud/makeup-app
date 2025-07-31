import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        await AuthService().signUpWithEmailAndPassword(email, password);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        print('Registration failed: $e');
        // Optionally show an error message to the user
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'lib/assets/images/sign_background.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(width * 0.05),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.15),
                    CustomTextField(
                      icon: Icons.email,
                      hintText: 'Email',
                      controller: _emailController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      icon: Icons.lock,
                      hintText: 'Password',
                      isPassword: true,
                      controller: _passwordController,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Password must not be empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: height * 0.05),
                    CustomButton(
                      text: 'Sign Up',
                      onPressed: _register,
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: height * 0.02,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/sign_in');
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.pinkAccent,
                              fontSize: height * 0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.15),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
