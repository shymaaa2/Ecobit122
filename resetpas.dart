import 'package:flutter/material.dart';
import 'ResetPasswordPage.dart';

class ResetPasPage extends StatefulWidget {
  const ResetPasPage({super.key});

  @override
  State<ResetPasPage> createState() => _ResetPasPageState();
}

class _ResetPasPageState extends State<ResetPasPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool otpSent = false;

  void _sendOtpToEmail() {
    if (_emailController.text.isNotEmpty && _emailController.text.contains('@')) {
      setState(() {
        otpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN sent to your email.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid email address.')),
      );
    }
  }

  void _verifyOtp() {
    if (_otpController.text.length == 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN Verified. You may now reset your password.')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a 4-digit PIN.')),
      );
    }
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        const SizedBox(height: 32),
        const Text(
          "Reset Password",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text("Enter your email address below.", style: TextStyle(color: Colors.grey[800])),
        Text("We'll send you a 4-digit PIN.", style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 28),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[400],
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _sendOtpToEmail,
            child: const Text(
              'Send PIN',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpForm() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("PIN Verification", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text("Please enter the 4-digit PIN sent to", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800])),
        const SizedBox(height: 8),
        Text(_emailController.text, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),

        // Use a single TextField for PIN input
        TextField(
          controller: _otpController,
          maxLength: 4,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: 'Enter 4-digit PIN',
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Didn't receive PIN?"),
            TextButton(
              onPressed: _sendOtpToEmail,
              child: const Text("Resend"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _verifyOtp,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[400],
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text("Verify", style: TextStyle(color: Colors.white)),
        ),
      ],
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (otpSent) {
                            setState(() {
                              otpSent = false;
                              _otpController.clear();
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "EcoBite",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      child: otpSent ? _buildOtpForm() : _buildEmailForm(),
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
