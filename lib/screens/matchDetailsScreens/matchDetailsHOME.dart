import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/full_score_card_for_audience.dart';
import 'package:umiperer/screens/matchDetailsScreens/score_counting_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';


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
      // "BallByBall"
      // "Overs"
    ];

    final tabBarView = [
      TeamDetails(match: match,),
      ScoreCountingPage(user: user,match: match,),
      ScoreCard(creatorUID: user.uid,match2: match,),
      // BallByBallPage()
      // Overs(),
    ];

    return DefaultTabController(
      initialIndex: 0,
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
                  case "Share match":
                    _shareMatch(context);
                    break;
                }
              },
              itemBuilder: (context){
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: "Delete Match",
                    child: Text("Delete Match"),),

                  PopupMenuItem<String>(
                    value: "Share match",
                    child: Text("Share match"),),
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

    Navigator.pop(context);
    // print("deleting the docs");

    final batsmen1Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("1InningBattingData").get();
    for(var docs in batsmen1Ref.docs){
      await docs.reference.delete();
    }

    final batsmen2Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("2InningBattingData").get();
    for(var docs in batsmen2Ref.docs){
      await docs.reference.delete();
    }

    final bowler1Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("1InningBowlingData").get();
    for(var docs in bowler1Ref.docs){
      await docs.reference.delete();
    }

    final bowler2Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("2InningBowlingData").get();
    for(var docs in bowler2Ref.docs){
      await docs.reference.delete();
    }

    await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("FirstInning").doc("scoreBoardData").delete();

    await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("SecondInning").doc("scoreBoardData").delete();

    final overs1Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("inning1overs").get();
    for(var docs in overs1Ref.docs){
      await docs.reference.delete();
    }

    final overs2Ref = await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).collection("inning2overs").get();
    for(var docs in overs2Ref.docs){
      await docs.reference.delete();
    }

    await usersRef.doc(user.uid).collection("createdMatches").doc(match.getMatchId()).delete();

  }

  _shareMatch(BuildContext context) {

    final String playStoreUrl = "https://play.google.com/store/apps/details?id=com.okays.umiperer";
    final String msg = "Watch live cricket score of Match between ${match.getTeam1Name()} vs ${match.getTeam2Name()} on Kirket app. $playStoreUrl";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }



}