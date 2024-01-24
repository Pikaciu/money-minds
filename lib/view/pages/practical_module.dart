import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_minds/view/pages/quiz_attempt_page.dart';

class PracticalModule extends StatefulWidget {
  const PracticalModule({Key? key}) : super(key: key);

  @override
  _PracticalModuleState createState() => _PracticalModuleState();
}

class _PracticalModuleState extends State<PracticalModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Quiz Level'),
      ),
body: FutureBuilder(
  future: getUserData(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else {
      Map<String, dynamic> userQuizzes = snapshot.data as Map<String, dynamic>;

      return ListView.builder(
        itemCount: userQuizzes.length,
        itemBuilder: (context, index) {
          String level = userQuizzes.keys.elementAt(index);
          List<Map<String, dynamic>> questions = userQuizzes[level];

          return Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('Quiz $level'),
                  onTap: () {
                    // Navigate to the quiz attempt page for the selected level
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizAttemptPage(
                          level: level,
                          questions: questions,
                        ),
                      ),
                    );
                  },
                ),
                // ... other details for the quiz level
              ],
            ),
          );
        },
      );
    }
  },
),
);
  }

Future<Map<String, dynamic>> getUserData() async {
  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> quizzesData = userData['quizzes'] ?? {};

      // Filter quizzes with status true
      Map<String, dynamic> filteredQuizzes = {};
quizzesData.forEach((level, quizDetails) {
  bool status = quizDetails['status'] == true;
  bool progress = quizDetails['progress'] == "Pending";
  if (status && progress) {
    List<dynamic> questions = quizDetails['questions'];
    if (questions is List && questions.isNotEmpty) {
      // Ensure questions have the correct data type (List<Map<String, dynamic>>)
      List<Map<String, dynamic>> typedQuestions =
          questions.cast<Map<String, dynamic>>().toList();
      filteredQuizzes[level] = typedQuestions;
    }
  }
});
      // Map<String, dynamic> filteredQuizzes = {};
      // quizzesData.forEach((level, quizDetails) {
      //   bool status = quizDetails['status'] == true;
      //   if (status) {
      //     List<dynamic> questions = quizDetails['questions'];
      //     if (questions is List && questions.isNotEmpty) {
      //       filteredQuizzes[level] = questions;
      //     }
      //   }
      // });
      print(filteredQuizzes);
      return filteredQuizzes;
    }

    return {};
  } on FirebaseAuthException catch (e) {
    print(e.message);
    return {};
  } catch (e) {
    print(e);
    return {};
  }
}

}
