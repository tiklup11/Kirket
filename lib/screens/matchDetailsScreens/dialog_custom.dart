import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/main.dart';
///MQD


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
            padding: EdgeInsets.only(top: (40*SizeConfig.oneH).roundToDouble(),
                left: (20*SizeConfig.oneW).roundToDouble(),
            right:  (20*SizeConfig.oneW).roundToDouble(),
              bottom:  (20*SizeConfig.oneW).roundToDouble()
            ),
            height: (240*SizeConfig.oneH).roundToDouble(),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12,width: 2)
          ),
            child:dialogContent(context),
        )
    );
  }

  topAppName(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular((8*SizeConfig.oneW).roundToDouble()),
              topRight: Radius.circular((8*SizeConfig.oneW).roundToDouble())),
          color: Colors.blueGrey,
      ),
      padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble()),
      // alignment: Alignment.centerLeft,
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("ADD NEW PLAYER",
            style: TextStyle(fontWeight: FontWeight.w400,),),
          Text("Kirket"),
        ],
      ),
    );
  }


  Widget dialogContent(BuildContext context){

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        TextFormField(
          decoration: InputDecoration(
            border: new OutlineInputBorder(),
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
            Bounce(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Text("Cancel"),
              ),
            ),
            Bounce(
              onPressed: () {
                onCreateBtnPressed();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12,width: 2)
                ),
                child: Text("Create"),
              ),
            ),
          ],
        )
      ],
    );
  }

  void onCreateBtnPressed(){

    if(widget.match.getInningNo()==1){

      if(widget.areWeAddingBatsmen){
        matchesRef.doc(widget.match.getMatchId())
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

        matchesRef.doc(widget.match.getMatchId())
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

        matchesRef.doc(widget.match.getMatchId())
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

        matchesRef.doc(widget.match.getMatchId())
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
        matchesRef.doc(widget.match.getMatchId())
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

        matchesRef.doc(widget.match.getMatchId())
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
        matchesRef.doc(widget.match.getMatchId())
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

        matchesRef.doc(widget.match.getMatchId())
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
