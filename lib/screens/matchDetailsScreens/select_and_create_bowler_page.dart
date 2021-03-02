import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';

///MQD

class SelectAndCreateBowlerPage extends StatefulWidget {
  SelectAndCreateBowlerPage({this.match, this.user});

  final CricketMatch match;
  final User user;
  @override
  _SelectAndCreateBowlerPageState createState() =>
      _SelectAndCreateBowlerPageState();
}

class _SelectAndCreateBowlerPageState
    extends State<SelectAndCreateBowlerPage> {
  DataStreams _dataStreams;
  bool isPlayerSelected = false;
  HashMap<String,bool> checkBoxMap = HashMap();
  int maximumCheckBox=1;
  int selectedCheckBox;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // backgroundColor: Colors.blueAccent,
          title: Text("Select Bowler (${widget.match.getCurrentBowlingTeam()})"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            bowlersList(),
            addNewPlayerBtn(),
            saveBtn()
          ],
        ));
  }

  Widget bowlersList() {

    return StreamBuilder<QuerySnapshot>(
      stream:
      _dataStreams.bowlersData(inningNumber: widget.match.getInningNo()),
      builder: (context, snapshot) {
        selectedCheckBox=0;
        if (!snapshot.hasData) {
          return Expanded(child: Container(child: Center(child: CircularProgressIndicator())));
        } else {
          final playersData = snapshot.data.docs;
          List<Widget> playerNames = [];
          if (playersData.isEmpty) {
            return addNewPlayerText();
          }

          // updatetotalRunsOfInning1 after everyball

          ///getting isBatting data and filling checkboxes depending upon them
          playersData.forEach((player) {

            if(player.data()['isBowling']==false){
              checkBoxMap[player.id]=false;
            }
            if(player.data()['isBowling']==true){
              checkBoxMap[player.id]=true;
              selectedCheckBox++;
            }
            playerNames.add(playerText(playerName:player.id));
          });

          print("XXXXXXXXXXXXXXXXXXXXD $selectedCheckBox");

          print(checkBoxMap);
          return Expanded(
            child: ListView(
              shrinkWrap: true,
              children: playerNames,
            ),
          );
        }
      },
    );
  }


  Widget playerText({String playerName}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.setWidth(10)),
        margin: EdgeInsets.symmetric(vertical: (4*SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("   $playerName"),
          Checkbox(
            value: checkBoxMap[playerName],
            onChanged: (bool value) {
              if(selectedCheckBox<maximumCheckBox || !value){
                updateIsBowling(playerName: playerName,value: value);
                setState(() {
                  checkBoxMap[playerName] = value;
                  if(!value){
                    selectedCheckBox--;
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void updateIsBowling({String playerName, bool value}){
    matchesRef
        .doc(widget.match.getMatchId())
        .collection('${widget.match.getInningNo()}InningBowlingData')
        .doc(playerName)
        .update({
      "isBowling":value
    });
    matchesRef.doc(widget.match.getMatchId()).update({
      "currentBowler":playerName
    });
  }


  Widget addNewPlayerText() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_handball),
            Text(
              "ADD NEW PLAYER",
              style: TextStyle(
                  fontSize: (20*SizeConfig.oneW).roundToDouble(),
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget addNewPlayerBtn() {
    return  Bounce(
      onPressed: () {
        //TODO: update current batsmen name and other related stuff
        openDialog();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueGrey.shade400,
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(
            left: (30 * SizeConfig.oneW).roundToDouble(),
            right: (30 * SizeConfig.oneW).roundToDouble(),
            bottom: (10 * SizeConfig.oneH).roundToDouble()),
        child: Center(child: Text("ADD NEW PLAYER")),
      ),
    );
  }

  Widget saveBtn() {
    return Bounce(
      onPressed: () {
        //TODO: update current batsmen name and other related stuff
        // onSaveBtnPressed();
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.blueGrey.shade400,
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.only(
            left: (30 * SizeConfig.oneW).roundToDouble(),
            right: (30 * SizeConfig.oneW).roundToDouble(),
            bottom: (10 * SizeConfig.oneH).roundToDouble()),
        child: Center(child: Text("CONTINUE..")),
      ),
    );
  }




  openDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AddPlayerDialog(
            areWeAddingBatsmen: false,
            user: widget.user,
            match: widget.match,
          );
        });
  }
}
