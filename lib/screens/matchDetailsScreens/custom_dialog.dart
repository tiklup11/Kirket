
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umiperer/modals/dataStreams.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class CustomDialog extends StatefulWidget {

  CustomDialog({this.match,this.user});

  final User user;
  final CricketMatch match;
  // final Function scrollListAnimationFunction;
  // final Function isFirstOverStarted;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {

  bool isLoadingData = false;
  DataStreams _dataStreams;
  int globalInningNo;

  String selectedBowler = "Select";
  String selectedBatsmen1 = "Select";
  String selectedBatsmen2 = "Select";

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _dataStreams=DataStreams(matchId: widget.match.getMatchId(),userUID: widget.user.uid);
      print("initState called");

    }

    @override
    Widget build(BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child:
        isLoadingData?
        Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            height: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white),
            child: Center(child: CircularProgressIndicator())):
          dialogContent(context)
      );
    }

    final space = SizedBox(width: 10,);

    Widget dialogContent(BuildContext context) {
      return StreamBuilder<DocumentSnapshot>(
        stream: _dataStreams.getGeneralMatchDataStream(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          else{
            final matchData=snapshot.data.data();

            List<String> teamAPlayers = matchData['teamAPlayers'].cast<String>();
            List<String> teamBPlayers = matchData['teamBPlayers'].cast<String>();

            final firstBattingTeam = matchData["firstBattingTeam"];
            final secondBattingTeam = matchData["secondBattingTeam"];
            final globalInningNo = matchData['inningNumber'];

            List<String> bowlingTeamPlayers = ["Select"];
            List<String> battingTeamPlayers = ["Select"];

            if(globalInningNo==1){
              if (firstBattingTeam == widget.match.getTeam1Name()) {
                teamAPlayers.forEach((playerName) {
                  battingTeamPlayers.add(playerName);
                });
                teamBPlayers.forEach((playerName) {
                  bowlingTeamPlayers.add(playerName);
                });
              } else {
                teamAPlayers.forEach((playerName) {
                  bowlingTeamPlayers.add(playerName);
                });
                teamBPlayers.forEach((playerName) {
                  battingTeamPlayers.add(playerName);
                });
              }
            } else{
              if (secondBattingTeam == widget.match.getTeam2Name()) {
                teamBPlayers.forEach((playerName) {
                  battingTeamPlayers.add(playerName);
                });
                teamAPlayers.forEach((playerName) {
                  bowlingTeamPlayers.add(playerName);
                });
              } else {
                teamBPlayers.forEach((playerName) {
                  bowlingTeamPlayers.add(playerName);
                });
                teamAPlayers.forEach((playerName) {
                  battingTeamPlayers.add(playerName);
                });
              }

            }

            return Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 350,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("SELECT FOR NEW OVER",
                      style: TextStyle(fontWeight: FontWeight.bold,),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Bowler:"),
                      // space,
                      dropDownWidgetForBowler(itemList: bowlingTeamPlayers),
                      // dropDownWidget(itemList: widget.match.team2List),
                    ],
                  ),
                  // space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Batsmen1:"),
                      dropDownWidgetForBatsmen1(itemList: battingTeamPlayers),
                      // dropDownWidget(itemList: widget.match.team2List),
                    ],
                  ),
                  // space,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Select Batsmen2:"),
                      // space,
                      dropDownWidgetForBatsmen2(itemList: battingTeamPlayers),
                      // dropDownWidget(itemList: widget.match.team2List),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      FlatButton(
                        color: Colors.blue.shade500,
                        child: Text("Start Over"),
                        onPressed: () {
                          onStartOverBtnPressed();
                        },
                      ),
                    ],
                  )
                ],
              ),
            );
          }

        }
      );
    }

    onStartOverBtnPressed() async{

      setState(() {
        isLoadingData=true;
      });

      //TODO: 1. increase OverNo on cloud and all players data // 2.set essentials on class

      //matchDoc > FirstInning OR SecondInning Collection > ScoreboardData > updatingTheField
      updatingTheOverCountInScoreBoardOnCloud();

      await usersRef.doc(widget.user.uid)
          .collection("createdMatches")
          .doc(widget.match.getMatchId())
          .update(
          {
            "currentOverNumber": FieldValue.increment(1),
            "currentBatsmen1": selectedBatsmen1,
            "currentBatsmen2": selectedBatsmen2,
            "currentBowler": selectedBowler,
            "currentOver": widget.match.currentOver.getCurrentOverNo(),
          });


      ///here when Batsmen and bowlers are selected,
      ///their data is updating on cloud based on InningNo.
      if(globalInningNo==1){

        print("INNING NO-- $globalInningNo || SELECTED-BATSMEN-- $selectedBatsmen1 || USER-ID ${widget.user.uid} || MATCH-ID ${widget.match.getMatchId()}");

        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection('Players')
            .doc(selectedBatsmen1).update({
          "isBatting": true,
          "isOnStrike": true,
          // "balls": FieldValue.increment(1),
        });

        //playerCollection
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection("Players")
            .doc(
            selectedBatsmen2
        ).update({
          // "balls": FieldValue.increment(1),
          "isBatting": true,
          "isOnStrike": false,
        });

        //bowlersRef
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('FirstInning')
            .doc("BowlingTeam")
            .collection("Players").doc(
            selectedBowler
        ).update({
          "isBowling": true,
        });

      } else{

        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('SecondInning')
            .doc("BattingTeam")
            .collection('Players')
            .doc(selectedBatsmen1).update({


          "isBatting": true,
          "isOnStrike": true,
        });

        //playerCollection
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('SecondInning')
            .doc("BattingTeam")
            .collection("Players")
            .doc(
            selectedBatsmen2
        ).update({
          "isBatting": true,
          "isOnStrike": false,
        });

        //bowlersRef
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('SecondInning')
            .doc("BowlingTeam")
            .collection("Players").doc(
            selectedBowler
        ).update({
          "isBowling": true,
        });

      }
      Navigator.pop(context);
      ///animation of horizontal list view
      // widget.scrollListAnimationFunction();

    }

    void updatingTheOverCountInScoreBoardOnCloud() async{
      if(globalInningNo==1){
        ///increasing over no
        ///
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId()).collection('FirstInning')
            .doc("scoreBoardData").update({
          "currentOverNo": FieldValue.increment(1)
        });


      } else{
        ///increasing over no
        await usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId()).collection('SecondInning')
            .doc("scoreBoardData").update({
          "currentOverNo": FieldValue.increment(1)
        });
      }

      ///setting isCurrentOverToTrue
      await usersRef.doc(widget.user.uid)
          .collection("createdMatches")
          .doc(widget.match.getMatchId()).collection('inning${globalInningNo}overs')
          .doc("over${globalInningNo+1}").update({
        "isThisCurrentOver":true

          });

    }

    dropDownWidgetForBowler({List<String> itemList}) {
      return DropdownButton<String>(
        value: selectedBowler,
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            selectedBowler = value;
          });
        },
      );
    }

    dropDownWidgetForBatsmen1({List<String> itemList}) {
      return DropdownButton<String>(
        value: selectedBatsmen1,
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            selectedBatsmen1 = value;
          });
        },
      );
    }

    dropDownWidgetForBatsmen2({List<String> itemList}) {
      return DropdownButton<String>(
        value: selectedBatsmen2,
        items: itemList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String value) {
          setState(() {
            selectedBatsmen2 = value;
          });
        },
      );
    }
  }

