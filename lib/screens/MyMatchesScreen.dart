import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/fill_new_match_details_screen.dart';
import 'package:umiperer/screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';

///MQD

final usersRef = FirebaseFirestore.instance.collection('users');


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
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _modalBottomSheetMenu(context);
             print("FAB pressed");
            },
            child: Icon(Icons.add),
          ),
          body: matchListView(context),
        ),
    );
  }

  Widget matchListView(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef.doc(widget.user.uid).collection('createdMatches').orderBy('timeStamp',descending: true).snapshots(),
        builder: (context, snapshot){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          } else{
            final List<MatchCardForCounting> matchCards = [];
            final matchesData = snapshot.data.docs;

            if(matchesData.isEmpty){
              return ZeroDocScreen(textMsg: "Tab + to create your own match to count runs and that will be live",iconData: Icons.calculate_outlined,);
            }

            for(var matchData in matchesData){

              final CricketMatch match = CricketMatch();

              final team1Name = matchData.data()['team1name'];
              final team2Name = matchData.data()['team2name'];
              final oversCount = matchData.data()['overCount'];
              final matchId = matchData.data()['matchId'];
              final playerCount = matchData.data()['playerCount'];
              final tossWinner = matchData.data()['tossWinner'];
              final batOrBall = matchData.data()['whatChoose'];
              final location = matchData.data()['matchLocation'];
              final isMatchStarted = matchData.data()['isMatchStarted'];
              final currentOverNumber = matchData.data()['currentOverNumber'];

              final firstBattingTeam = matchData.data()['firstBattingTeam'];
              final firstBowlingTeam = matchData.data()['firstBowlingTeam'];
              final secondBattingTeam = matchData.data()['secondBattingTeam'];
              final secondBowlingTeam = matchData.data()['secondBowlingTeam'];


              match.firstBattingTeam=firstBattingTeam;
              match.firstBowlingTeam=firstBowlingTeam;
              match.secondBattingTeam=secondBattingTeam;
              match.secondBowlingTeam=secondBowlingTeam;

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

  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: (120*SizeConfig.oneH).roundToDouble(),
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
                    FlatButton(
                      minWidth: double.infinity,
                        child: Text("Create match"),
                        onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return FillNewMatchDetailsPage(user: widget.user);
                        }));
                      print("pressed");
                    }),
                    FlatButton(
                        minWidth: double.infinity,
                        child: Text("Create Tournament"),
                        onPressed: (){
                          Navigator.pop(context);
                          showAlertDialog(context: context);
                          // print("pressed");
                        }),
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
