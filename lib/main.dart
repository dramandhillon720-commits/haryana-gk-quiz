import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'HSSC MCQ Quiz', theme: ThemeData(primarySwatch: Colors.blue), home: SubjectScreen());
  }
}

// 1. SUBJECT SCREEN
class SubjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subjects"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
        builder: (c, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          return ListView(children: snap.data!.docs.map((doc) => Card(child: ListTile(title: Text(doc['name']), trailing: Icon(Icons.arrow_forward), onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => TopicScreen(subjectId: doc.id, subjectName: doc['name'])))))).toList());
        },
      ),
    );
  }
}

// 2. TOPIC SCREEN
class TopicScreen extends StatelessWidget {
  final String subjectId, subjectName;
  TopicScreen({required this.subjectId, required this.subjectName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').doc(subjectId).collection('topics').snapshots(),
        builder: (c, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          return ListView(children: snap.data!.docs.map((doc) => Card(child: ListTile(title: Text(doc['name']), onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => TestListScreen(subjectId: subjectId, topicId: doc.id, topicName: doc['name'])))))).toList());
        },
      ),
    );
  }
}

// 3. TEST LIST SCREEN
class TestListScreen extends StatelessWidget {
  final String subjectId, topicId, topicName;
  TestListScreen({required this.subjectId, required this.topicId, required this.topicName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topicName)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').doc(subjectId).collection('topics').doc(topicId).collection('tests').snapshots(),
        builder: (c, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          return ListView(children: snap.data!.docs.map((doc) => Card(child: ListTile(title: Text(doc['name']), subtitle: Text("${doc['questionCount'] ?? 0} Questions"), onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => QuizScreen(subjectId: subjectId, topicId: topicId, testId: doc.id)))))).toList());
        },
      ),
    );
  }
}

// 4. QUIZ SCREEN WITH ADS
class QuizScreen extends StatefulWidget {
  final String subjectId, topicId, testId;
  QuizScreen({required this.subjectId, required this.topicId, required this.testId});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentIndex = 0, score = 0;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;

  @override
  void initState() {
    super.initState();
    bannerAd = BannerAd(adUnitId: 'ca-app-pub-2827563304186980/1234567890', size: AdSize.banner, request: AdRequest(), listener: BannerAdListener())..load();
    InterstitialAd.load(adUnitId: 'ca-app-pub-2827563304186980/0987654321', request: AdRequest(), adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) => interstitialAd = ad, onAdFailedToLoad: (e) => print(e)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      bottomNavigationBar: bannerAd != null ? Container(height: 50, child: AdWidget(ad: bannerAd!)) : null,
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('subjects').doc(widget.subjectId).collection('topics').doc(widget.topicId).collection('tests').doc(widget.testId).collection('questions').get(),
        builder: (c, snap) {
          if (!snap.hasData) return Center(child: CircularProgressIndicator());
          var questions = snap.data!.docs;
          if (questions.isEmpty) return Center(child: Text("No Questions Added Yet"));
          var q = questions[currentIndex];
  var opts = [q['option1'], q['option2'], q['option3'], q['option4']];
  return Column(children: [
    LinearProgressIndicator(value: (currentIndex+1)/questions.length),
    Padding(padding: EdgeInsets.all(16), child: Text(q['question']?? '', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
   ...List.generate(4, (i) => Card(child: ListTile(title: Text(opts[i]?? ''), onTap: () {
      if (opts[i] == q['correctAnswer']) score++;
      if ((currentIndex+1) % 4 == 0) interstitialAd?.show();
      if (currentIndex < questions.length-1) setState(() => currentIndex++); else showDialog(context: context, builder: (_) => AlertDialog(title: Text("Score: $score/${questions.length}"), actions: [TextButton(onPressed: () => Navigator.popUntil(context, (r) => r.isFirst), child: Text("OK"))]));
    }))),
  ]);
          return Column(children: [
            LinearProgressIndicator(value: (currentIndex+1)/questions.length),
            Padding(padding: EdgeInsets.all(16), child: Text(q['question'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ...List.generate(4, (i) => Card(child: ListTile(title: Text(q['options'][i]), onTap: () {
              if (q['options'][i] == q['answer']) score++;
              if ((currentIndex+1) % 4 == 0) interstitialAd?.show();
              if (currentIndex < questions.length-1) setState(() => currentIndex++); else showDialog(context: c, builder: (_) => AlertDialog(title: Text("Score: $score/${questions.length}"), actions: [TextButton(onPressed: () => Navigator.popUntil(c, (r) => r.isFirst), child: Text("OK"))]));
            }))),
          ]);
        },
      ),
    );
  }
}
