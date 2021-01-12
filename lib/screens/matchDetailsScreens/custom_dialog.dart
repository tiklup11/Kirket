
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  List<String> bowlingTeamPlayers = ["Select"];
  List<String> battingTeamPlayers = ["Select"];

  String selectedBowler = "Select";
  String selectedBatsmen1 = "Select";
  String selectedBatsmen2 = "Select";

  putPlayersInList() {
    for (int i = 0; i < widget.match.getPlayerCount(); i++) {

      if(widget.match.getInningNo()==1){

        print("WWWWWWWWWWWWWWW: ${widget.match.firstBattingTeam}");
        //for first inning
        battingTeamPlayers.add(widget.match.getTeamListByTeamName(widget.match.firstBattingTeam)[i]);
        bowlingTeamPlayers.add(widget.match.getTeamListByTeamName(widget.match.firstBowlingTeam)[i]);
      } else{
        //this is for second inning
        battingTeamPlayers.add(widget.match.getTeamListByTeamName(widget.match.secondBattingTeam)[i]);
        bowlingTeamPlayers.add(widget.match.getTeamListByTeamName(widget.match.secondBowlingTeam)[i]);
      }
    }
  }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      putPlayersInList();
    }

    @override
    Widget build(BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      );
    }

    final space = SizedBox(width: 10,);

    Container dialogContent(BuildContext context) {
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
                    //TODO: 1. increase OverNo on cloud and all players data // 2.set essentials on class
                    usersRef.doc(widget.user.uid)
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

                    //newCollection in the name of team of 1st Inning
                    usersRef.doc(widget.user.uid)
                        .collection("createdMatches")
                        .doc(widget.match.getMatchId())
                        .collection('firstInning').doc("BattingTeam").collection('Players').doc(selectedBatsmen1).set({
                      "runs":0,
                      "balls":0,
                      "noOf4s":0,
                      "noOf6s":0,
                      "name":selectedBatsmen1,
                      "isBatting": true,
                      "isOnStrike": true,
                    });

                    //playerCollection
                    usersRef.doc(widget.user.uid)
                        .collection("createdMatches")
                        .doc(widget.match.getMatchId())
                        .collection('firstInning').doc("BattingTeam").collection("Players").doc(
                      selectedBatsmen2
                    ).set({
                      "runs":0,
                      "balls":0,
                      "noOf4s":0,
                      "noOf6s":0,
                      "name":selectedBatsmen2,
                      "isBatting": true,
                      "isOnStrike": false,
                    });

                    //bowlersRef
                    usersRef.doc(widget.user.uid)
                        .collection("createdMatches")
                        .doc(widget.match.getMatchId())
                        .collection('firstInning').doc("BowlingTeam").collection("Players").doc(
                        selectedBowler
                    ).set({
                      "overs":0,
                      "ballOfTheOver":0,
                      "maidans":0,
                      "runs":0,
                      "wickets":0,
                      "name":selectedBowler,
                      "isBowling": true,
                    });

                    Navigator.pop(context);


                    print("WWWWWWWWWWW: OVER COUNT ${widget.match.currentOver.getCurrentOverNo()}");

                    final currentOver = widget.match.currentOver.getCurrentOverNo();

                    widget.match.currentOver.setCurrentOverNo(currentOver+1);

                    print("WWWWWWWWWWW: OVER COUNT ${widget.match.currentOver.getCurrentOverNo()}");

                    ///animation of horizontal list view
                    // widget.scrollListAnimationFunction();

                    },
                ),
              ],
            )
          ],
        ),
      );
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

