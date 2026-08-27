import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen(), theme: ThemeData(fontFamily: 'Roboto')));

class HomeScreen extends StatefulWidget {
  @override _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? data;
  @override
  void initState() { super.initState(); load(); }
  load() async {
    String s = await rootBundle.loadString('assets/questions.json');
    setState(() => data = json.decode(s));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FB),
      body: data == null ? Center(child: CircularProgressIndicator()) : SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  CircleAvatar(backgroundImage: AssetImage('assets/user.png'), backgroundColor: Colors.grey, radius: 20, child: Icon(Icons.person)),
                  SizedBox(width: 8),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Haryana GK", style: TextStyle(fontWeight: FontWeight.bold)), Text("ID-1966", style: TextStyle(fontSize: 10))]),
                ]),
                Container(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: Color(0xFFD6E8FF), borderRadius: BorderRadius.circular(8)), child: Row(children: [Icon(Icons.diamond, size: 14, color: Colors.blue), SizedBox(width: 4), Text("160", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))])),
              ]),
              SizedBox(height: 16),
              // Banner
              Container(
                width: double.infinity, padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Color(0xFF1A365D), borderRadius: BorderRadius.circular(12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Test Your Knowledge with\nQuizzes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(height: 8),
                  ElevatedButton(onPressed: (){}, child: Text("Play Now", style: TextStyle(fontSize: 10)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: Size(60, 25))),
                ]),
              ),
              SizedBox(height: 16),
              // Search
              Row(children: [
                Expanded(child: TextField(decoration: InputDecoration(hintText: "Search", prefixIcon: Icon(Icons.search, size: 18), filled: true, fillColor: Colors.white, contentPadding: EdgeInsets.zero, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
                SizedBox(width: 8), Container(padding: EdgeInsets.all(8), color: Colors.white, child: Icon(Icons.tune, size: 18)),
              ]),
              SizedBox(height: 16),
              Text("
