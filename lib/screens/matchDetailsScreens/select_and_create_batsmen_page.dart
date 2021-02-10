import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';

///MQD
///
class SelectAndCreateBatsmenPage extends StatefulWidget {
  SelectAndCreateBatsmenPage({this.match, this.user});

  final CricketMatch match;
  final User user;
  @override
  _SelectAndCreateBatsmenPageState createState() =>
      _SelectAndCreateBatsmenPageState();
}

class _SelectAndCreateBatsmenPageState
    extends State<SelectAndCreateBatsmenPage> {
  DataStreams _dataStreams;
  bool isPlayerSelected = false;
  HashMap<String,bool> checkBoxMap = HashMap();
  int maximumCheckBox=2;
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
          // backgroundColor: Colors.blueAccent,
          automaticallyImplyLeading: false,
          title: Text("Select Batsmen (${widget.match.getCurrentBattingTeam()})"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            batsmensList(),
            addNewPlayerBtn(),
            saveBtn()
          ],
        ));
  }

  Widget batsmensList() {

    return StreamBuilder<QuerySnapshot>(
      stream:
          _dataStreams.batsmenData(inningNumber: widget.match.getInningNo()),
      builder: (context, snapshot) {
        selectedCheckBox=0;
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final playersData = snapshot.data.docs;

          List<Widget> playerNames = [];

          if (playersData.isEmpty) {
            return addNewPlayerText();
          }

          ///getting isBatting data and filling checkboxes depending upon them
          playersData.forEach((player) {

            if(player.data()['isBatting']==false){
              checkBoxMap[player.id]=false;
            }
            if(player.data()['isBatting']==true){
              checkBoxMap[player.id]=true;
              selectedCheckBox++;
            }
            playerNames.add(selectPlayerWidget(playerName:player.id));
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


  Widget selectPlayerWidget({String playerName}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.one_W).roundToDouble(),vertical: (4*SizeConfig.one_H).roundToDouble()),
      // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      decoration: BoxDecoration(
          color: ThemeData.light().primaryColor.withOpacity(0.1)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("   $playerName"),
          Checkbox(
            value: checkBoxMap[playerName],
            onChanged: (bool value){
              if(selectedCheckBox<maximumCheckBox || !value){

                updateIsBatting(playerName: playerName,value: value);

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

  void updateIsBatting({String playerName, bool value}){

    if(selectedCheckBox==0){
      usersRef.doc(widget.user.uid).collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('${widget.match.getInningNo()}InningBattingData')
          .doc(playerName)
          .update({
        "isBatting":value,
        "isOnStrike":true,
      });

    }

    if(selectedCheckBox==1){
      usersRef.doc(widget.user.uid).collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('${widget.match.getInningNo()}InningBattingData')
          .doc(playerName)
          .update({
        "isBatting":value,
        // "isOnStrike":true,
      });
    }

    if(!value){
      usersRef.doc(widget.user.uid).collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('${widget.match.getInningNo()}InningBattingData')
          .doc(playerName)
          .update({
        "isBatting":value,
        "isOnStrike":value,
      });

    }

  }

  Widget addNewPlayerText() {
    return Expanded(
      child: Center(
        child: Text(
          "ADD NEW PLAYER",
          style: TextStyle(
              fontSize: (20*SizeConfig.one_W).roundToDouble(),
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget addNewPlayerBtn() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (26*SizeConfig.one_W).roundToDouble()),
      child: FlatButton(
        minWidth: double.infinity,
        color: Colors.blueGrey.shade400,
        child: Text("ADD NEW PLAYER"),
        onPressed: () {
          openDialog();
        },
      ),
    );
  }

  Widget saveBtn() {
    return Container(
      margin: EdgeInsets.only(left: (26*SizeConfig.one_W).roundToDouble(),
          right: (26*SizeConfig.one_W).roundToDouble(),
          bottom: (10*SizeConfig.one_H).roundToDouble()),
      child: FlatButton(
        minWidth: double.infinity,
        color: Colors.blueGrey.shade400,
        child: Text("CONTINUE.."),
        onPressed: () {
          //TODO: update current batsmen name and other related stuff
          // onSaveBtnPressed();
          Navigator.pop(context);
        },
      ),
    );
  }




  openDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AddPlayerDialog(
            areWeAddingBatsmen: true,
            user: widget.user,
            match: widget.match,
          );
        });
  }
}
