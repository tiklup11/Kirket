import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/LiveMatchesScreen.dart';
import 'package:umiperer/screens/live_scores_directory/ended_match_screen.dart';


final usersRef = FirebaseFirestore.instance.collection('users');

///this is home screen for live matches
///this has two tabs - 1. LIVE   2. ENDED

class LiveScreenHome extends StatelessWidget {

  LiveScreenHome({this.user});

  // final CricketMatch match;
  final User user;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Live",
      "Ended"
    ];

    final tabBarView = [
      LiveMatchesScreen(),
      EndMatchesScreen(),
      // TeamDetails(match: match,),
      // ScoreCountingPage(user: user,match: match,),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: (50*SizeConfig.oneH).roundToDouble(),
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

}