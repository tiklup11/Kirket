import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/first_in_sc.dart';
import 'package:umiperer/screens/full_score_card_for_audience.dart';
import 'package:umiperer/screens/matchDetailsScreens/score_counting_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';
import 'package:umiperer/screens/second_inn_sc.dart';

class MatchDetails extends StatelessWidget {

  MatchDetails({this.match,this.user});

  final CricketMatch match;
  final User user;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Details",
      "Counting",
      "1st Inning",
      "2nd Inning"
      // "BallByBall"
      // "Overs"
    ];

    final tabBarView = [
      TeamDetails(match: match,),
      ScoreCountingPage(user: user,match: match,),
      FirstInningScoreCard(creatorUID: user.uid, match: match),
      match.getInningNo()==1?
      Container(
        color: Colors.white,
        child: Center(child: zeroData(msg: "2nd Inning not started yet",iconData: Icons.sports_cricket_outlined),),):
      SecondInningScoreCard(creatorUID: user.uid, match: match)
      // BallByBallPage()
      // Overs(),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
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
                    value: "Share match",
                    child: Text("Share match"),),
                  PopupMenuItem<String>(
                    value: "Delete Match",
                    child: Text("Delete Match"),),
                ];
              },
              ),
          ],
          automaticallyImplyLeading: false,
          title: Text(
              "${match.getTeam1Name().toUpperCase()} v ${match.getTeam2Name().toUpperCase()}",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabBarView)
              tab,
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

    final batsmen1Ref = await matchesRef.doc(match.getMatchId()).collection("1InningBattingData").get();
    for(var docs in batsmen1Ref.docs){
      docs.reference.delete();
    }

    final batsmen2Ref = await matchesRef.doc(match.getMatchId()).collection("2InningBattingData").get();
    for(var docs in batsmen2Ref.docs){
      docs.reference.delete();
    }

    final bowler1Ref = await matchesRef.doc(match.getMatchId()).collection("1InningBowlingData").get();
    for(var docs in bowler1Ref.docs){
      docs.reference.delete();
    }

    final bowler2Ref = await matchesRef.doc(match.getMatchId()).collection("2InningBowlingData").get();
    for(var docs in bowler2Ref.docs){
      docs.reference.delete();
    }

    matchesRef.doc(match.getMatchId()).collection("FirstInning").doc("scoreBoardData").delete();

    matchesRef.doc(match.getMatchId()).collection("SecondInning").doc("scoreBoardData").delete();

    final overs1Ref = await matchesRef.doc(match.getMatchId()).collection("inning1overs").get();
    for(var docs in overs1Ref.docs){
      docs.reference.delete();
    }

    final overs2Ref = await matchesRef.doc(match.getMatchId()).collection("inning2overs").get();
    for(var docs in overs2Ref.docs){
       docs.reference.delete();
    }

    final chatCollection = await matchesRef.doc(match.getMatchId()).collection("chatData").get();
    for(var docs in chatCollection.docs){
      docs.reference.delete();
    }

    matchesRef.doc(match.getMatchId()).delete();

  }

  _shareMatch(BuildContext context) {

    final String playStoreUrl = "https://play.google.com/store/apps/details?id=com.okays.umiperer";
    final String msg = "Watch live score of Cricket Match between ${match.getTeam1Name()} vs ${match.getTeam2Name()} on Kirket app. $playStoreUrl";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }


  zeroData({String msg, IconData iconData}){
    return Container(
      height: (80*SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(width: (4*SizeConfig.oneW).roundToDouble(),),
          Text(msg),
        ],
      ),
    );
  }



}