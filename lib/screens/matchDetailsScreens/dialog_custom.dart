import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';

///MQD

final usersRef = FirebaseFirestore.instance.collection('users');

class AddPlayerDialog extends StatefulWidget {

  AddPlayerDialog({this.match, this.user,@required this.areWeAddingBatsmen});

  final CricketMatch match;
  final User user;
  final bool areWeAddingBatsmen;
  @override
  _AddPlayerDialogState createState() => _AddPlayerDialogState();
}

class _AddPlayerDialogState extends State<AddPlayerDialog> {

  String playerName;
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular((20*SizeConfig.oneW).roundToDouble()),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child:
        Container(
            padding: EdgeInsets.symmetric(vertical: (20*SizeConfig.oneH).roundToDouble(),
                horizontal: (20*SizeConfig.oneW).roundToDouble()),
            height: (220*SizeConfig.oneH).roundToDouble(),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular((8*SizeConfig.oneW).roundToDouble()),
                color: Colors.white),
            child:dialogContent(context),
        )
    );
  }

  Widget dialogContent(BuildContext context){

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text("NEW PLAYER",
            style: TextStyle(fontWeight: FontWeight.w400,),),
        ),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            icon: Icon(Icons.sports_baseball_sharp),
            hintText: "Enter player name",
            labelText: "Player Name",
            // prefixText: '+1 ',
          ),
          onChanged: (value) {
          //  newMatch.setTeam2Name(value);
            playerName = value;
          },
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
              color: Colors.blueGrey.shade400,
              child: Text("Create"),
              onPressed: () {
                onCreateBtnPressed();
              },
            ),
          ],
        )
      ],
    );
  }

  void onCreateBtnPressed(){

    if(widget.match.getInningNo()==1){

      if(widget.areWeAddingBatsmen){
        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('1InningBattingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "balls":0,
              "noOf4s":0,
              "noOf6s":0,
              "isOnStrike":false,
              "isBatting":false,
            }
        );

        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('2InningBowlingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "overs":0,
              "wickets":0,
              "maidens":0,
              "isBowling":false,
              "totalBalls":6,
              "overLength":6,
              "ballOfTheOver":0,
            }
        );
      }else{

        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('1InningBowlingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "overs":0,
              "wickets":0,
              "maidens":0,
              "isBowling":false,
              "ballOfTheOver":0,
              "totalBalls":6,
              "overLength":6,
            }
        );

        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('2InningBattingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "balls":0,
              "noOf4s":0,
              "noOf6s":0,
              "isOnStrike":false,
              "isBatting":false,
              "isOut":false,
            }
        );
      }
    }

    if(widget.match.getInningNo()==2){

      if(widget.areWeAddingBatsmen){
        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('2InningBattingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "balls":0,
              "noOf4s":0,
              "noOf6s":0,
              "isOnStrike":false,
              "isBatting":false,
              "isOut":false,

            }
        );

        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('1InningBowlingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "overs":0,
              "wickets":0,
              "maidens":0,
              "isBowling":false,
              "ballOfTheOver":0,
              "totalBalls":6,
              "overLength":6,
              "isOut":false,

            }
        );
      }else{
        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('2InningBowlingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "overs":0,
              "wickets":0,
              "maidens":0,
              "isBowling":false,
              "ballOfTheOver":0,
              "totalBalls":6,
              "overLength":6,
            }
        );

        usersRef.doc(widget.user.uid).collection("createdMatches")
            .doc(widget.match.getMatchId())
            .collection('1InningBattingData')
            .doc(playerName).set(
            {
              "name":playerName,
              "runs":0,
              "balls":0,
              "noOf4s":0,
              "noOf6s":0,
              "isOnStrike":false,
              "isBatting":false,
              "isOut":false,
            }
        );
      }
    }
    Navigator.pop(context);
  }
}
