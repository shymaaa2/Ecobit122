import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  double rating = 0;

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
                      this.rating = rating;
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
                      this.rating = rating;
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
                      this.rating = rating;
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
                      this.rating = rating;
                    }),
                    itemSize: 19,
                  ),
                  const SizedBox(height: 26),


                  TextButton(onPressed:()=>Navigator.pop(context),
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

