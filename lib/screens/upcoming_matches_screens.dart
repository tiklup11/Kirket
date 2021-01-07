import 'package:flutter/material.dart';

class UpcomingMatchesScreen extends StatefulWidget {
  @override
  _UpcomingMatchesScreenState createState() => _UpcomingMatchesScreenState();
}

class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          //TODO: add btm sheet...to create future tournament and add details about tournament
        },
      ),
      body: Container(),
    );
  }
}
