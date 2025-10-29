import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Data/Database.dart';
import 'home.dart';
import 'dart:async';
import 'package:eco/feedback_validators.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0;
  double q1 = 0;
  double q2 = 0;
  double q3 = 0;
  double q4 = 0;
  String uid = '';

  Future<void> saveRating() async{
    FeedbackValidators.validateRating({
          'q1': q1,
          'q2': q2,
          'q3': q3,
          'q4': q4,
          'dateTaken': DateTime.now().toIso8601String(),
          'uid': uid
    });

    await DatabaseService().addRating({
          'q1': q1,
          'q2': q2,
          'q3': q3,
          'q4': q4,
          'dateTaken': DateTime.now().toIso8601String(),
          'uid': uid
        });

        Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context) => 
                      const HomePage())
                      );
  }

   Future<void> _loadUserData() async{
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        uid = user.uid;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // صورة الخلفية تغطي كامل الشاشة
          Positioned.fill(
            child: Image.asset(
              'assets/image.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 130),
                  const Text(
                    "         Tell Us What You Think!",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w800),

                  ),
                  const SizedBox(height: 20),

                  const Text(
                    "Was the edibility result accurate?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    minRating: 1,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) => setState(() {
                      q1 = rating;
                    }),
                    itemSize: 19,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "How easy was it to use the app to check a fruit's edibility?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    minRating: 1,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) => setState(() {
                      q2 = rating;
                    }),
                    itemSize: 19,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "How likely are you to recommend this app to a friend?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    minRating: 1,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) => setState(() {
                      q3 = rating;
                    }),
                    itemSize: 19,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "How clear was the information provided about the fruit?",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  RatingBar.builder(
                    minRating: 1,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.5),
                    itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                    onRatingUpdate: (rating) => setState(() {
                      q4 = rating;
                    }),
                    itemSize: 19,
                  ),
                  const SizedBox(height: 26),
                  TextButton(onPressed:()=>{
                  if (q1 == 0 || q2 == 0 || q3 == 0 || q4 == 0){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              ),
                          backgroundColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                          content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                              const SizedBox(height: 8),
                              const Text(
                                    'Please fill in all the fields ',
                                      style: TextStyle(fontSize: 15, color: Colors.black87),
                                      textAlign: TextAlign.center,
                                      ),
                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  // OK Button
                                  OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.green, width: 1),
                                        padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 25),
                                      ),
                                      onPressed: () {
                                          Navigator.pop(context); // close popup
                                      },
                                      child: const Text(
                                      'OK',
                                      style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        )
                  }
                  else{
                    saveRating()
                  }
                  },
                    style: TextButton.styleFrom( backgroundColor: Colors.lightGreen, foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // زوايا مدورة
                       ),
                       ),
                    child: const Text('Submit' ,style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
                  ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:  SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(image: AssetImage("assets/heart.gif")),
                  ),
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}