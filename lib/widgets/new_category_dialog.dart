import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
///MQD


class CreateNewCategoryDialog extends StatefulWidget {

  CreateNewCategoryDialog({this.match, this.user,@required this.areWeAddingBatsmen});

  final CricketMatch match;
  final User user;
  final bool areWeAddingBatsmen;
  @override
  _CreateNewCategoryDialogState createState() => _CreateNewCategoryDialogState();
}

class _CreateNewCategoryDialogState extends State<CreateNewCategoryDialog> {

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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topAppName(),
            Container(
              padding: EdgeInsets.symmetric(vertical: (20*SizeConfig.oneH).roundToDouble(),
                  horizontal: (20*SizeConfig.oneW).roundToDouble()),
              height: (300*SizeConfig.oneH).roundToDouble(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular((8*SizeConfig.oneW).roundToDouble()),
                    bottomRight: Radius.circular((8*SizeConfig.oneW).roundToDouble())),
                color: Colors.white,
              ),
              child:dialogContent(context),
            ),
          ],
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
          Text("ADD YOUR CATEGORY",
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
        SizedBox(
          height: 10,
        ),
        hintTextTop(),
        SizedBox(
          height: 18,
        ),
        enterForm(),
        radioButtonPublicOrPrivate(),
        SizedBox(
          height: 16,
        ),
        endBtns()
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

  hintTextTop(){
    return Container(
      child: Text("Category can be your Tournament name, Location etc. Next time you create a similar new match, you can put it in same category.")
    );
  }

  String selectedState = "Private";


  radioButtonPublicOrPrivate(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Radio(
          value: "Public",
          groupValue: selectedState,
          onChanged: (value){
            setState(() {
              selectedState=value;
              print(selectedState);
            });
          },
        ),
        new Text(
          'Public',
        ),
        new Radio(
          value: "Private",
          groupValue: selectedState,
          onChanged:  (value){
            setState(() {
              selectedState=value;
            });
          },
        ),
        new Text(
          'Private',),
      ],
    );
  }

  enterForm(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Create new category",
        labelText: "New Category",
      ),
      onChanged: (value) {
        playerName = value;
      },
    );
  }
  endBtns(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Bounce(
          onPressed: () {
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
            // onCreateBtnPressed();
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade400,
                borderRadius: BorderRadius.circular(6)
            ),
            child: Text("Create"),
          ),
        ),
      ],
    );
  }
}
