import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'encryption.dart';
import 'registration.dart';
import 'home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  final Encryption encryption = Encryption();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {

      final email = _emailController.text.trim();
      final passCheck = _passwordController.text.trim();



      if (email.toLowerCase() == 'admin@gmail.com') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Admins must log in from the admin page.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {

        setState(() => _loading = true);

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: passCheck);

        if (userCredential.user != null) {
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address';
        } else if (e.code == 'too-many-requests') {
          errorMessage = 'Too many attempts. Please try again later.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } finally {
        setState(() => _loading = false);
      }
    }
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
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

                const Spacer(),

                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Please log in to your account',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                        const SizedBox(height: 32),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Email is required'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Password is required'
                              : null,
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Forgot Password
                            },
                            child: const Text(
                              'Forgot your password?',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        _loading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8DAF85),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
