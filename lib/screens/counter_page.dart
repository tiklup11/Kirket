
import 'package:flutter/material.dart';

class MatchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Teams",
      "Counting",
      "ScoreCard",
      "Overs"
    ];

    final tabBarView = [
      TeamDetails(),
      CounterPage(),
      ScoreCard(),
      Overs(),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          // actions: [
          //   PopupMenuItem(
          //     value: 1,
          //     child: Text("First"),),
          //   PopupMenuItem(
          //     value: 2,
          //     child: Text("Second"),),
          // ],
          // automaticallyImplyLeading: false,
          title: Text("Match Details"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabBarView)
              Center(
                child: tab,
              ),
          ],
        ),
      ),
    );
  }

  TeamDetails(){
    return Container(
      child: Text("Team Details"),
    );
  }

  CounterPage(){
    return Container(
      child: Text("Counting"),
    );
  }
  ScoreCard(){
    return Container(
      child: Text('ScoreCard'),
    );
  }
  Overs(){
    return Container(
      child: Text('Overs'),
    );
  }

}