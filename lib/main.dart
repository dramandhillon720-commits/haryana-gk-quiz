import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? appData;

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    String s = await rootBundle.loadString('assets/questions.json');
    setState(() {
      appData = json.decode(s);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (appData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    var subtopics = appData!['subtopics'] as List;

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Icon(Icons.person)),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Haryana GK", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("ID-1966", style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(8)),
                    child: Text("160"),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Color(0xFF1A365D), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Test Your Knowledge with\nQuizzes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: () {}, child: Text("Play Now", style: TextStyle(fontSize: 12))),
                  ],
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
              SizedBox(height: 16),
              Text("Categories", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemCount: subtopics.length,
                itemBuilder: (context, i) {
                  var sub = subtopics[i];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => TestListScreen(subtopic: sub)));
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.menu_book, color: Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(sub['name'].toString().split(' ').first, style: TextStyle(fontSize: 10), textAlign: TextAlign.center),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 10),
              Text("Recent Activity", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: subtopics.length,
                itemBuilder: (context, i) {
                  var sub = subtopics[i];
                  int qCount = sub['tests'][0]['questions'].length;
                  return Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(Icons.book),
                        SizedBox(width: 10),
                        Expanded(child: Text(sub['name'])),
                        Text("$qCount Q"),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}

class TestListScreen extends StatelessWidget {
  final Map subtopic;
  TestListScreen({required this.subtopic});

  @override
  Widget build(BuildContext context) {
    var tests = subtopic['tests'] as List;
    return Scaffold(
      appBar: AppBar(title: Text(subtopic['name'])),
      body: GridView.builder(
        padding: EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: tests.length,
        itemBuilder: (context, i) {
          return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(testData: tests[i], title: subtopic['name'])));
              },
              child: Center(child: Text("Test ${tests[i]['test_no']}", style: TextStyle(fontWeight: FontWeight.bold))),
            ),
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final Map testData;
  final String title;
  QuizScreen({required this.testData, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int current = 0;
  Map<int, String> selected = {};

  @override
  Widget build(BuildContext context) {
    var questions = widget.testData['questions'] as List;
    var q = questions[current];

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Question: ${current + 1}/${questions.length}", style: TextStyle(color: Colors.blue, fontSize: 12)),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(color: Color(0xFFF9FBFF), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(q['question'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  SizedBox(height: 16),
                 ...List.generate(q['options'].length, (i) {
                    String opt = q['options'][i];
                    bool isSel = selected[current] == opt;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selected[current] = opt;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSel? Color(0xFF1A4B8A) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(opt, style: TextStyle(color: isSel? Colors.white : Colors.black)),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: current > 0? () { setState(() { current--; }); } : null,
                  child: Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (current < questions.length - 1) {
                      setState(() { current++; });
                    } else {
                      int score = 0;
                      for (int i = 0; i < questions.length; i++) {
                        if (selected[i] == questions[i]['answer']) score++;
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ResultScreen(score: score, total: questions.length)));
                    }
                  },
                  child: Text(current == questions.length - 1? "Submit" : "Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  ResultScreen({required this.score, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              SizedBox(height: 60),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(color: Color(0xFF1A4B8A), shape: BoxShape.circle, border: Border.all(color: Color(0xFF6FA8DC), width: 6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Your Score", style: TextStyle(color: Colors.white)),
                    Text("$score/$total", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Congratulation", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A4B8A))),
              Text("Great job! You Did It", style: TextStyle(color: Color(0xFF1A4B8A))),
              Spacer(),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {}, child: Text("Share"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A4B8A)))),
              SizedBox(height: 10),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => HomeScreen()), (r) => false); }, child: Text("Back to Home"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1A4B8A)))),
            ],
          ),
        ),
      ),
    );
  }
}
