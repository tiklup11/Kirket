
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/matchDetailsScreens/ball_by_ball_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/score_counting_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';


final usersRef = FirebaseFirestore.instance.collection('users');

class MatchDetails extends StatelessWidget {

  MatchDetails({this.match,this.user});

  final CricketMatch match;
  final User user;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Details",
      "Counting",
      "ScoreCard",
      "BallByBall"
      // "Overs"
    ];

    final tabBarView = [
      TeamDetails(match: match,),
      ScoreCountingPage(user: user,match: match,),
      ScoreCard(),
      BallByBallPage()
      // Overs(),
    ];

    return DefaultTabController(
      initialIndex: 1,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (value){
                //TODO: make switch cases
                switch (value){
                  case "Delete Match":
                    deleteTheMatchFromCloud(context);
                    break;
                }
              },
              itemBuilder: (context){
                return <PopupMenuItem<String>>[

                  PopupMenuItem<String>(
                    value: "Restart Match",
                    child: Text("Restart Match"),),

                  PopupMenuItem<String>(
                    value: "Delete Match",
                    child: Text("Delete Match"),),
                ];
              },
              ),
          ],
          automaticallyImplyLeading: false,
          title: Text("${match.getTeam1Name().toUpperCase()} v ${match.getTeam2Name().toUpperCase()}"),
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


  deleteTheMatchFromCloud(BuildContext context) async{
    ///when we delete a collection,
    ///inner collections are not deleted, so we have to delete inner collections also

    print("deleting the docs");

    final team1BatsmenRef = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection(match.getTeam1Name()).doc(match.getTeam1Name()).collection('batsmen').get();
    for(var docs in team1BatsmenRef.docs){
      await docs.reference.delete();
    }

    final team1BowlerRef = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection(match.getTeam1Name()).doc(match.getTeam1Name()).collection('bowlers').get();
    for(var docs in team1BowlerRef.docs){
      await docs.reference.delete();
    }

    final team1Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection(match.getTeam1Name()).get();
    for(var docs in team1Ref.docs){
      await docs.reference.delete();
    }

    final team2Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection(match.getTeam2Name()).get();
    for(var docs in team2Ref.docs){
      await docs.reference.delete();
    }

    await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).delete();

    Navigator.pop(context);

  }

  Widget ScoreCard(){
    return Container();
  }



}