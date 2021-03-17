import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';
import 'package:umiperer/services/database_updater.dart';

class SelectAndCreateBowlerPage extends StatefulWidget {
  SelectAndCreateBowlerPage({this.match, this.currentOverNo});

  final CricketMatch match;
  final int currentOverNo;

  @override
  _SelectAndCreateBowlerPageState createState() =>
      _SelectAndCreateBowlerPageState();
}

class _SelectAndCreateBowlerPageState extends State<SelectAndCreateBowlerPage> {
  bool isPlayerSelected = false;
  HashMap<String, bool> checkBoxMap = HashMap();
  int maximumCheckBox = 1;
  int selectedCheckBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          // backgroundColor: Colors.blueAccent,
          title: Text(
            "Select Bowler (${widget.match.getCurrentBowlingTeam()})",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [bowlersList(), addNewPlayerBtn(), saveBtn()],
        ));
  }

  Widget bowlersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: DatabaseController.getBowlersCollRef(
              inningNo: widget.match.getInningNo(),
              matchId: widget.match.getMatchId())
          .snapshots(),
      builder: (context, snapshot) {
        selectedCheckBox = 0;
        if (!snapshot.hasData) {
          return addNewPlayerGif();
        } else {
          final playersData = snapshot.data.docs;
          List<Widget> playerNames = [];
          if (playersData.isEmpty) {
            return addNewPlayerGif();
          }
          // updatetotalRunsOfInning1 after everyball

          ///getting isBatting data and filling checkboxes depending upon them
          playersData.forEach((player) {
            if (player.data()['isBowling'] == false) {
              checkBoxMap[player.id] = false;
            }
            if (player.data()['isBowling'] == true) {
              checkBoxMap[player.id] = true;
              selectedCheckBox++;
            }
            playerNames.add(playerText(playerName: player.id));
          });

          print("XXXXXXXXXXXXXXXXXXXXD $selectedCheckBox");

          print(checkBoxMap);
          return Expanded(
            child: ListView(
              cacheExtent: 11,
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
      margin:
          EdgeInsets.symmetric(vertical: (4 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("   $playerName"),
          Checkbox(
            value: checkBoxMap[playerName],
            onChanged: (bool value) {
              if (selectedCheckBox < maximumCheckBox || !value) {
                updateIsBowling(playerName: playerName, value: value);
                setState(() {
                  checkBoxMap[playerName] = value;
                  if (!value) {
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

  void updateIsBowling({String playerName, bool value}) {
    DatabaseController.getBowlerDocRef(
            bowlerName: playerName,
            inningNo: widget.match.getInningNo(),
            matchId: widget.match.getMatchId())
        .update({
      "isBowling": value,
    });

    DatabaseController.getOverDoc(
            inningNo: widget.match.getInningNo(),
            matchId: widget.match.getMatchId(),
            overNo: widget.currentOverNo)
        .update({"bowlerName": playerName});

    DatabaseController.getScoreBoardDocRef(
      inningNo: widget.match.getInningNo(),
      matchId: widget.match.getMatchId(),
    ).update({"currentBowler": playerName});
  }

  Widget addNewPlayerGif() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "ADD NEW PLAYER",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Icon(Icons.keyboard_arrow_down_rounded)
        ],
      ),
    );
  }

  Widget addNewPlayerBtn() {
    return Bounce(
      onPressed: () {
        openDialog();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
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
        // onSaveBtnPressed();
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
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
            match: widget.match,
          );
        });
  }
}
