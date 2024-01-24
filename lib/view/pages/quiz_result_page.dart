// import 'package:flutter/material.dart';

// class QuizResultPage extends StatelessWidget {
//   final int correctAnswers;

//   QuizResultPage({required this.correctAnswers});

//   @override
//   Widget build(BuildContext context) {
//     // Save the user's marks to Firestore here

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Quiz Result'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Quiz Completed!',
//               style: TextStyle(fontSize: 24),
//             ),
//             SizedBox(height: 20),
//             // Text(
//             //   'Your Score: $correctAnswers/${widget.questions.length}',
//             //   style: TextStyle(fontSize: 20),
//             // ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Navigate back to the home page or any other page
//                 Navigator.pop(context);
//               },
//               child: Text('Back to Home'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_minds/view/pages/bottom_navigation_bar.dart';

class QuizResultPage extends StatelessWidget {
  final int correctAnswers;
  final String quizLevel; // Add the quiz level parameter

  QuizResultPage({required this.correctAnswers, required this.quizLevel});

  @override
  Widget build(BuildContext context) {
    // Save the user's marks and update quiz progress to Firestore here
    updateQuizProgressAndMarks(correctAnswers, quizLevel);

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Your Score: $correctAnswers', // Update the text as needed
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home page or any other page
                // Navigator.pop(context);
                // onTap: () =>
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BottomNavigationBarScreen()),
                );
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  void updateQuizProgressAndMarks(int correctAnswers, String quizLevel) {
    int marks = correctAnswers; // You can customize how marks are calculated
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'quizzes.$quizLevel.progress': 'Completed',
      'quizzes.$quizLevel.marks': marks,
      'coins': FieldValue.increment(marks),
    });
  }
}
