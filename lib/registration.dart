import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Data/Database.dart';
import 'login.dart';
import 'encryption.dart';
import 'package:encrypt/encrypt.dart';

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
  String errMsg = '';

  final Encryption encryption = Encryption();
  
  
  //Removal of malicious input
  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r'[<>{};$]'), '').trim();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      calculateAge(pickedDate);
    }
  }

    calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    if(years >= 13){
      setState(() {
        _birthdayController.text = birth.toIso8601String().split('T').first;
      });
  }else{
      setState(() {
        errMsg = 'You must be 13 years or older to sign up';
      });
    }
}

  Future<void> _register() async {
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the terms and conditions')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
      setState(() => _loading = true);
      // Password Encryption
      final password = sanitizeInput(_passwordController.text);
      Encrypted cryptPassword = encryption.encrypted(password.trim());

      final email = sanitizeInput(_emailController.text);
      
      final confirmPassword = sanitizeInput(_confirmPasswordController.text);
      final username = sanitizeInput(_usernameController.text);
      final birthday = sanitizeInput(_birthdayController.text);

      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user!;

        await user.updateDisplayName(_usernameController.text.trim());
        await user.reload();

        await DatabaseService().addUser({
          'email': email.trim(),
          'uname': username.trim(),
          'pass':  cryptPassword.base64,
          'dob': birthday.trim(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      } finally {
        setState(() => _loading = false);
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
                            "Create a new account!",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Georgia',
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 30),

                          TextFormField(
                            controller: _usernameController,
                            decoration: _greenBorderInput('Username'),
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Enter username' : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _emailController,
                            decoration: _greenBorderInput('Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value == null || !value.contains('@')
                                ? 'Enter valid email'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _passwordController,
                            decoration: _greenBorderInput('Password'),
                            obscureText: true,
                            validator: (value) => value == null || value.length < 6
                                ? 'Password too short'
                                : null,
                          ),
                          const SizedBox(height: 12),

                          TextFormField(
                            controller: _confirmPasswordController,
                            decoration: _greenBorderInput('Confirm Password'),
                            obscureText: true,
                            validator: (value) => value != _passwordController.text
                                ? 'Passwords do not match'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _birthdayController,
                            decoration: _greenBorderInput('Birthday'),
                            readOnly: true,
                            onTap: _selectDate,
                            validator: (value) =>
                            value == null || value.isEmpty ? 'Select birthday' : null,
                          ),
                          const SizedBox(height: 12),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Checkbox(
                                value: _termsAccepted,
                                onChanged: (val) =>
                                    setState(() => _termsAccepted = val ?? false),
                              ),
                              const Flexible(child: Text('I accept terms and conditions')),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                            onPressed: _register,
                            child: const Text('Register'),
                          ),
                          const SizedBox(height: 40),
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
