import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _birthdayController = TextEditingController();
  bool _termsAccepted = false;
  bool _loading = false;

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2005),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _birthdayController.text = pickedDate.toIso8601String().split('T').first;
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate() && _termsAccepted) {
      try {
        setState(() => _loading = true);
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      } finally {
        setState(() => _loading = false);
      }
    } else if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the terms and conditions')),
      );
    }
  }

  InputDecoration _greenBorderInput(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.green, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'EcoBite',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            "Create Account!",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Georgia',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Username
                          TextFormField(
                            controller: _usernameController,
                            decoration: _greenBorderInput('Enter your username'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                                return 'Username must be letters and numbers only';
                              } else if (RegExp(r'^\d+$').hasMatch(value)) {
                                return 'Username cannot be numbers only';
                              } else if (value.length <= 5) {
                                return 'Username must be more than 5 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Email
                          TextFormField(
                            controller: _emailController,
                            decoration: _greenBorderInput('Enter your Email'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Birthday
                          GestureDetector(
                            onTap: _selectDate,
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _birthdayController,
                                decoration: _greenBorderInput('Select your birthdate'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Birthdate is required';
                                  }
                                  try {
                                    final inputDate = DateTime.parse(value);
                                    final cutoffDate = DateTime(2013, 1, 1);
                                    if (inputDate.isAfter(cutoffDate)) {
                                      return 'You must be at least 13 years old';
                                    }
                                  } catch (_) {
                                    return 'Invalid date';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: _greenBorderInput('Enter your password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters';
                              }
                              if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                                return 'You should use a special character';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          // Confirm Password
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: _greenBorderInput('Confirm your password'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Confirm Password is required';
                              } else if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Terms checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _termsAccepted,
                                onChanged: (value) {
                                  setState(() => _termsAccepted = value ?? false);
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "I accept the terms & conditions",
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Sign Up button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8DAF85),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _loading ? null : _register,
                              child: _loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Navigate to login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const LoginPage()),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


