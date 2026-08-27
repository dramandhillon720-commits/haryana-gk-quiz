import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: SubtopicScreen(), debugShowCheckedModeBanner: false));

class SubtopicScreen extends StatelessWidget {
  Future<Map<String, dynamic>> loadData() async {
    String data = await rootBundle.loadString('assets/questions.json');
    return json.decode(data);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Haryana GK Quiz"), backgroundColor: Colors.green),
      body: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          var subtopics = snapshot.data!['subtopics'];
          return ListView.builder(
            itemCount: subtopics.length,
            itemBuilder: (context, i) => Card(
              child: ListTile(
                title: Text(subtopics[i]['name']),
                subtitle: Text("10 Tests"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(subtopic: subtopics[i]))),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TestListScreen extends StatelessWidget {
  final Map subtopic;
  TestListScreen({required this.subtopic});
  @override
  Widget build(BuildContext context) {
    var tests = subtopic['tests'];
    return Scaffold(
      appBar: AppBar(title: Text(subtopic['name'])),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: tests.length,
        itemBuilder: (context, i) => Card(
          child: InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(testData: tests[i]))),
            child: Center(child: Text("Test ${tests[i]['test_no']}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final Map testData;
  QuizScreen({required this.testData});
  @override _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0;
  Map<int, String> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    var questions = widget.testData['questions'] as List;
    var q = questions[currentIndex];
    return Scaffold(
      appBar: AppBar(title: Text("Q ${currentIndex+1}/${questions.length}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(q['question'], style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
           ...List.generate(q['options'].length, (optIndex) {
              String opt = q['options'][optIndex];
              return RadioListTile(
                title: Text(opt),
                value: opt,
                groupValue: selectedAnswers[currentIndex],
                onChanged: (val) => setState(() => selectedAnswers[currentIndex] = val.toString()),
              );
            }),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: currentIndex > 0? () => setState(() => currentIndex--) : null, child: Text("Previous")),
                ElevatedButton(
                  onPressed: () {
                    if (currentIndex < questions.length - 1) {
                      setState(() => currentIndex++);
                    } else {
                      // Result
                      int score = 0;
                      for(int i=0; i<questions.length; i++){
                        if(selectedAnswers[i] == questions[i]['answer']) score++;
                      }
                      showDialog(context: context, builder: (_) => AlertDialog(
                        title: Text("Result"),
                        content: Text("Score: $score / ${questions.length}"),
                        actions: [TextButton(onPressed: (){Navigator.pop(context); Navigator.pop(context);}, child: Text("OK"))],
                      ));
                    }
                  },
                  child: Text(currentIndex == questions.length - 1? "Submit" : "Next"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
