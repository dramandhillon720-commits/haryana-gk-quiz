import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const String bannerAdId = 'ca-app-pub-2827494424235072/9251633542';
const String interstitialAdId = 'ca-app-pub-2827494424235072/1580640700';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(HaryanaGKApp());
}

class HaryanaGKApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haryana GK Quiz',
      theme: ThemeData(primarySwatch: Colors.blue),
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
  int _qCountForAd = 0;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  List<Map<String, dynamic>> questions = [
    {
      "q": "Haryana ka gathan kab hua tha?",
      "options": ["1 Nov 1966", "15 Aug 1947", "26 Jan 1950", "1 Nov 1956"],
      "ans": 0
    },
    {
      "q": "Haryana ki rajdhani kya hai?",
      "options": ["Chandigarh", "Hisar", "Rohtak", "Gurgaon"],
      "ans": 0
    },
    // Yaha tere baaki ke saare questions automatic aa jayenge, tu bas isi list me add karta rehna
  ];

  @override
  void initState() {
    super.initState();
    _loadBanner();
    _loadInterstitial();
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: bannerAdId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) { ad.dispose(); },
      ),
    )..load();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
      ),
    );
  }

  void _nextQuestion(int selected) {
    if (selected == questions[qIndex]['ans']) score++;
    _qCountForAd++;

    if (_qCountForAd % 4 == 0) {
      _interstitialAd?.show();
      _loadInterstitial();
    }

    if (qIndex < questions.length - 1) {
      setState(() { qIndex++; });
    } else {
      showDialog(context: context, builder: (_) => AlertDialog(
        title: Text("Quiz Khatam!"),
        content: Text("Tera Score: $score / ${questions.length}"),
        actions: [TextButton(onPressed: (){ setState((){ qIndex=0; score=0; }); Navigator.pop(context); }, child: Text("Restart"))],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Haryana GK Quiz")),
      bottomNavigationBar: _bannerAd!= null? Container(height: 50, child: AdWidget(ad: _bannerAd!)) : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(questions[qIndex]['q'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
           ...List.generate(questions[qIndex]['options'].length, (i) {
              return Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () => _nextQuestion(i),
                  child: Text(questions[qIndex]['options'][i]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
