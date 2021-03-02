import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/fill_new_match_details_screen.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';

///MQD

class MyMatchesScreen extends StatefulWidget {
  MyMatchesScreen({this.user});
  final User user;

  @override
  _MyMatchesScreenState createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // backgroundColor: Colors.black12,
          floatingActionButton: Bounce(
            duration: Duration(milliseconds: 120),
            onPressed: (){
              _modalBottomSheetMenu(context);
            },
            child: FloatingActionButton(
              // backgroundColor: Colors.blueGrey.shade400,
              child: Icon(Icons.add),
            ),
          ),
          body: matchListView(context),
        ),
    );
  }

  Widget matchListView(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
        stream: matchesRef.where('creatorUid',isEqualTo: widget.user.uid).orderBy('timeStamp',descending: true).snapshots(),
        builder: (context, snapshot){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else{
            final List<MatchCardForCounting> matchCards = [];
            final matchesData = snapshot.data.docs;

            if(matchesData.isEmpty){
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZeroDocScreen(
                    showLearnMore: true,
                    dialogText: "Currently matches created by you will not be LIVE. In a week with the new update you will get this feature.",
                    textMsg: "Tab + to create your own match to count runs. Live feature is coming soon.",iconData: Icons.calculate_outlined,),
                ],
              );
            }

            for(var matchData in matchesData){

              final CricketMatch match = CricketMatch();

              final team1Name = matchData.data()['team1name'];
              final team2Name = matchData.data()['team2name'];

              final oversCount = matchData.data()['overCount'];

              final matchId = matchData.data()['matchId'];
              final creatorUid = matchData.data()['creatorUid'];
              final playerCount = matchData.data()['playerCount'];
              final tossWinner = matchData.data()['tossWinner'];
              final batOrBall = matchData.data()['whatChoose'];
              final location = matchData.data()['matchLocation'];
              final isMatchStarted = matchData.data()['isMatchStarted'];
              final currentOverNumber = matchData.data()['currentOverNumber'];
              final isSecondInningEnd = matchData.data()['isSecondInningEnd'];

              final firstBattingTeam = matchData.data()['firstBattingTeam'];
              final firstBowlingTeam = matchData.data()['firstBowlingTeam'];
              final secondBattingTeam = matchData.data()['secondBattingTeam'];
              final secondBowlingTeam = matchData.data()['secondBowlingTeam'];

              match.isMatchLive = matchData.data()['isLive'];
              match.isLiveChatOn = matchData.data()['isLiveChatOn'];


              match.firstBattingTeam=firstBattingTeam;
              match.firstBowlingTeam=firstBowlingTeam;
              match.creatorUid = creatorUid;
              match.secondBattingTeam=secondBattingTeam;
              match.secondBowlingTeam=secondBowlingTeam;
              match.isSecondInningEnd =isSecondInningEnd;

              if(firstBattingTeam!=null && firstBowlingTeam!=null && secondBattingTeam!=null && secondBowlingTeam!=null)
              {
                match.setFirstInnings();
              }


              if(matchData.data()['teamAPlayers'] != null){
                final teamAPlayers = matchData.data()['teamAPlayers'].cast<String>();
                final teamBPlayers = matchData.data()['teamBPlayers'].cast<String>();

                match.team1List=teamAPlayers;
                match.team2List=teamBPlayers;
              }

              match.currentOver.setCurrentOverNo(currentOverNumber);
              match.setTeam1Name(team1Name);
              match.setTeam2Name(team2Name);
              match.setMatchId(matchId);
              match.setPlayerCount(playerCount);
              match.setLocation(location);
              match.setTossWinner(tossWinner);
              match.setBatOrBall(batOrBall);
              match.setOverCount(oversCount);
              match.setIsMatchStarted(isMatchStarted);

              matchCards.add(MatchCardForCounting(match: match,user: widget.user,));
            }

            return ListView.builder(
              // physics: BouncingScrollPhysics(),
                itemCount: matchCards.length,
                itemBuilder: (context, int){
              return matchCards[int];
            }
            );
          }
        });
  }

  fabBtn({Function onPressed, String btnText}){
    return Bounce(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueGrey
        ),
        margin: EdgeInsets.only(left: 30,right:30,top: 10),
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
        width: double.infinity,
        child: Center(child: Text(btnText)),
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: (140*SizeConfig.oneH).roundToDouble(),
            color: Color(0xFF737373),
            // color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular((8*SizeConfig.oneW).roundToDouble()),
                        topRight: Radius.circular((8*SizeConfig.oneW).roundToDouble()))),
                child: Column(
                  children: [
                    fabBtn(
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return FillNewMatchDetailsPage(user: widget.user,);
                        }));
                      },
                      btnText: "CREATE MATCH"
                    ),
                    fabBtn(
                      onPressed: (){
                        Navigator.pop(context);
                        showAlertDialog(context: context);
                        // print("pressed");
                      },
                      btnText: "CREATE TOURNAMENT"
                    )
                  ],
                )),
          );
        }
    );
  }

  showAlertDialog({BuildContext context}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Okays"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coming soon"),
      content: Text("This feature is coming soon.."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
