
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

  int currentOverNo;
  int inningNumber;
  bool isLoadingData = true;

  List<String> bowlingTeamPlayers = ["Select"];
  List<String> battingTeamPlayers = ["Select"];

  String selectedBowler = "Select";
  String selectedBatsmen1 = "Select";
  String selectedBatsmen2 = "Select";

  putPlayersInList() {
    for (int i = 0; i < widget.match.getPlayerCount(); i++) {

      if(inningNumber==1){

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

  getDataFromCloud() async{
    final mRef = await usersRef.doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId()).get();

    inningNumber = mRef.data()['inningNumber'];

    if(mRef.data()['currentBatsmen1'] != null){
      selectedBatsmen1 = mRef.data()['currentBatsmen1'];
    }
    if(mRef.data()['currentBatsmen2'] != null){
    selectedBatsmen2 = mRef.data()['currentBatsmen2'];
    }
    if(mRef.data()['currentBowler'] != null){
      selectedBowler = mRef.data()['currentBowler'];
    }

    if(inningNumber==1) {
      final matchRef = await usersRef.doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('FirstInning')
          .doc("scoreBoardData")
          .get();
      currentOverNo = matchRef.data()['currentOverNo'];
      print("FFFFFFFFFFFFFFF: $currentOverNo");
    } else{
      final matchRef = await usersRef.doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('SecondInning')
          .doc("scoreBoardData")
          .get();
      currentOverNo = matchRef.data()['currentOverNo'];
      print("FFFFFFFFFFFFFFF: $currentOverNo");
    }


    setState(() {
      isLoadingData=false;
    });
  }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      getDataFromCloud();
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
        child:
        isLoadingData?
        CircularProgressIndicator():
        dialogContent(context),
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
                    onStartOverBtnPressed();
                    },
                ),
              ],
            )
          ],
        ),
      );
    }

    onStartOverBtnPressed(){
      //TODO: 1. increase OverNo on cloud and all players data // 2.set essentials on class

      //matchDoc > FirstInning OR SecondInning Collection > ScoreboardData > updatingTheField
      updatingTheOverCountInScoreBoardOnCloud();

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


      ///here when Batsmen and bowlers are selected,
      ///their data is updating on cloud based on InningNo.
      if(inningNumber==1){

        usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection('Players')
            .doc(selectedBatsmen1).update({
          "isBatting": true,
          "isOnStrike": true,
        });

        //playerCollection
        usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection("Players")
            .doc(
            selectedBatsmen2
        ).update({
          "isBatting": true,
          "isOnStrike": false,
        });

        //bowlersRef
        usersRef.doc(widget.user.uid)
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

        usersRef.doc(widget.user.uid)
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
        usersRef.doc(widget.user.uid)
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
        usersRef.doc(widget.user.uid)
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


      widget.match.currentBatsmen1=selectedBatsmen1;
      widget.match.currentBatsmen2=selectedBatsmen2;
      widget.match.currentBowler=selectedBowler;

      Navigator.pop(context);

      setState(() {

      });

      print("WWWWWWWWWWW: OVER COUNT ${widget.match.currentOver.getCurrentOverNo()}");

      final currentOver = widget.match.currentOver.getCurrentOverNo();

      widget.match.currentOver.setCurrentOverNo(currentOver+1);

      print("WWWWWWWWWWW: OVER COUNT ${widget.match.currentOver.getCurrentOverNo()}");

      ///animation of horizontal list view
      // widget.scrollListAnimationFunction();


    }

    void updatingTheOverCountInScoreBoardOnCloud(){
      if(inningNumber==1){
        ///increasing over no
        ///
        usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId()).collection('FirstInning')
            .doc("scoreBoardData").update({
          "currentOverNo": FieldValue.increment(1)
        });


      } else{
        ///increasing over no
        usersRef.doc(widget.user.uid)
            .collection("createdMatches")
            .doc(widget.match.getMatchId()).collection('SecondInning')
            .doc("scoreBoardData").update({
          "currentOverNo": FieldValue.increment(1)
        });
      }

      ///setting isCurrentOverToTrue
      usersRef.doc(widget.user.uid)
          .collection("createdMatches")
          .doc(widget.match.getMatchId()).collection('inning${inningNumber}overs')
          .doc("over${currentOverNo+1}").update({

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

