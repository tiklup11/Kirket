import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';

class BatsmenDataList extends StatelessWidget {
  BatsmenDataList({this.inningNo, this.matchId});
  final int inningNo;
  final String matchId;
  @override
  Widget build(BuildContext context) {
    return batsmenList();
  }

  batsmenList() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      child: Column(
        children: [
          BatsmenScoreRow(
            isThisSelectBatsmenBtn: false,
            isOnStrike: false,
            batsmen: Batsmen(
                isOnStrike: false,
                isClickable: false,
                runs: "R",
                playerName: "Batsmen",
                sR: "SR",
                noOf6s: "6s",
                noOf4s: "4s",
                balls: "B"),
          ),

          Container(
            color: Colors.black12,
            height: (2 * SizeConfig.oneH).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: DatabaseController.getBatsmenCollRef(
                      inningNo: inningNo, matchId: matchId)
                  .orderBy('balls', descending: true)
                  .where('balls', isGreaterThan: 0)
                  // .where('isOut', isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                List<BatsmenScoreRow> listOfBatsmen = [];

                if (!snapshot.hasData) {
                  return loadingData();
                } else {
                  final batsmenData = snapshot.data.docs;

                  batsmenData.forEach((playerData) {
                    // print("DATA::  ${playerData.data()}");
                    final ballsPlayed = playerData.data()['balls'];
                    final noOf4s = playerData.data()['noOf4s'];
                    final noOf6s = playerData.data()['noOf6s'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    // final isOnStrike = playerData.data()['isOnStrike'];

                    double SR = 0;
                    try {
                      SR = ((runs / ballsPlayed) * 100);
                    } catch (e) {
                      SR = 0;
                    }

                    if (SR.isNaN) {
                      SR = 0.0;
                    }

                    listOfBatsmen.add(BatsmenScoreRow(
                      isOnStrike: false,
                      isThisSelectBatsmenBtn: false,
                      batsmen: Batsmen(
                          isClickable: false,
                          balls: ballsPlayed.toString(),
                          noOf4s: noOf4s.toString(),
                          noOf6s: noOf6s.toString(),
                          sR: SR.toStringAsFixed(0),
                          playerName: playerName,
                          runs: runs.toString(),
                          isOnStrike: false),
                    ));
                  });
                }
                if (listOfBatsmen.isEmpty) {
                  return zeroData(
                      iconData: Icons.sports_cricket_outlined,
                      msg: "Batsmen data is shown here");
                }
                return Column(
                  children: listOfBatsmen,
                );
              })
        ],
      ),
    );
  }

  zeroData({String msg, IconData iconData}) {
    return Container(
      height: (80 * SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(
            width: (4 * SizeConfig.oneW).roundToDouble(),
          ),
          Text(msg),
        ],
      ),
    );
  }

  loadingData() {
    return Container(
        height: (80 * SizeConfig.oneH).roundToDouble(),
        child: Center(child: CircularProgressIndicator()));
  }
}
