import 'package:flutter/material.dart';
import 'package:money_minds/view/pages/quiz_result_page.dart';
import 'dart:async';

class QuizAttemptPage extends StatefulWidget {
  final List<Map<String, dynamic>> questions;
  final String level;

  QuizAttemptPage({required this.questions, required this.level});

  @override
  _QuizAttemptPageState createState() => _QuizAttemptPageState();
}

class _QuizAttemptPageState extends State<QuizAttemptPage> {
 int currentIndex = 0;
  int correctAnswers = 0;
  late Map<String, dynamic> currentQuestion;
  late List<String> options;
  late bool isAnswered;
  late String selectedAnswer;
  late Timer questionTimer;
  int timerSeconds = 10;

  @override
  void initState() {
    super.initState();
    loadQuestion();
  }

  void loadQuestion() {
    currentQuestion = widget.questions[currentIndex];
    options = []
      ..add(currentQuestion['correctAnswer'])
      ..addAll(currentQuestion['wrongAnswers'].cast<String>());
    options.shuffle();
    isAnswered = false;

    // Start the timer when a new question is loaded
    startTimer();
  }

  void startTimer() {
    const int questionDuration = 10; // 10 seconds for each question
    questionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          // Handle timeout when the user doesn't answer in time
          timer.cancel();
          if (!isAnswered) {
            selectedAnswer = '';
            moveToNextQuestion();
          }
        }
      });
    });
  }

  void checkAnswer(String answer) {
    if (!isAnswered) {
      questionTimer.cancel(); // Cancel the timer when the user answers
      setState(() {
        isAnswered = true;
        selectedAnswer = answer;
        if (answer == currentQuestion['correctAnswer']) {
          correctAnswers++;
        }
      });

      // Move to the next question after a delay
      Future.delayed(Duration(seconds: 2), () {
        moveToNextQuestion();
      });
    }
  }

  void moveToNextQuestion() {
    // Cancel the timer before moving to the next question
    questionTimer.cancel();
    timerSeconds = 10; // Reset the timer for the next question

    if (currentIndex < widget.questions.length - 1) {
      setState(() {
        currentIndex++;
        loadQuestion();
      });
    } else {
      // Navigate to the result page
      print('result page');
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => QuizResultPage(correctAnswers: correctAnswers),
      //   ),
      // );
      Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => QuizResultPage(
      correctAnswers: correctAnswers,
      quizLevel: widget.level,
    ),
  ),
);
    }
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    questionTimer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Attempt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${currentIndex + 1}/${widget.questions.length}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              currentQuestion['question'],
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Time Remaining: $timerSeconds seconds',
              style: TextStyle(fontSize: 16),
            ),
            Column(
              children: options.map((option) {
                return GestureDetector(
                  onTap: () => checkAnswer(option),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isAnswered
                          ? option == currentQuestion['correctAnswer']
                              ? Colors.green
                              : option == selectedAnswer
                                  ? Colors.red
                                  : Colors.white
                          : Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
