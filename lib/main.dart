
import 'package:flutter/material.dart';

void main() {
  runApp(HaryanaGKApp());
}

class HaryanaGKApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haryana GK Quiz',
      theme: ThemeData(primarySwatch: Colors.green),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int qIndex = 0;
  int score = 0;

  List<Map<String, dynamic>> questions = [
    {
      "q": "Haryana ka gathan kab hua tha?",
      "options": ["1 Nov 1966", "15 Aug 1947", "26 Jan 1950", "1 Nov 1968"],
      "answer": 0
    },
    {
      "q": "Haryana ki Rajdhani kya hai?",
      "options": ["Hisar", "Karnal", "Chandigarh", "Rohtak"],
      "answer": 2
    },
    {
      "q": "Haryana ka Rajya Khel kaunsa hai?",
      "options": ["Cricket", "Kushti", "Kabaddi", "Hockey"],
      "answer": 1
    },
    {
      "q": "Panipat ka pehla yudh kab hua?",
      "options": ["1526", "1556", "1761", "1857"],
      "answer": 0
    },
    {
      "q": "Kurukshetra kis liye prasidh hai?",
      "options": ["Mahabharat", "Ramayan", "Vedas", "Purana"],
      "answer": 0
    },
  ];

  void checkAnswer(int selected) {
    if (selected == questions[qIndex]["answer"]) {
      score++;
    }
    if (qIndex < questions.length - 1) {
      setState(() {
        qIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Result"),
          content: Text("Aapka Score: $score / ${questions.length}"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  qIndex = 0;
                  score = 0;
                });
                Navigator.pop(context);
              },
              child: Text("Restart"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var q = questions[qIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Haryana GK Quiz - ${qIndex + 1}/${questions.length}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(q["q"], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            for (int i = 0; i < 4; i++)
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => checkAnswer(i),
                  child: Text(q["options"][i]),
                ),
              ),
            SizedBox(height: 20),
            Text("Score: $score", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
