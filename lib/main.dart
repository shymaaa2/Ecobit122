import 'package:eco/welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // Will come back for navigation later
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomePage(),
    );
  }
}

