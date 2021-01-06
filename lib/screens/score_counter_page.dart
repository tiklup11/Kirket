import 'package:flutter/material.dart';

class ScoreCounterPage extends StatefulWidget {
  @override
  _ScoreCounterPageState createState() => _ScoreCounterPageState();
}

class _ScoreCounterPageState extends State<ScoreCounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter"),
      ),
    );
  }
}
