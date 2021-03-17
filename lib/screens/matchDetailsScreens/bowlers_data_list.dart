import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';

class BowlersDataList extends StatelessWidget {
  BowlersDataList({@required this.inningNo, @required this.matchId});
  final int inningNo;
  final String matchId;
  @override
  Widget build(BuildContext context) {
    return bowlersList();
  }

  Container bowlersList() {
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
          BowlerStatsRow(
            isThisSelectBowlerBtn: false,
            bowler: Bowler(
                playerName: "Bowler",
                runs: "R",
                wickets: "W",
                overs: "O",
                median: "M",
                economy: "E"),
          ),
          Container(
            color: Colors.black12,
            height: (2 * SizeConfig.oneH).roundToDouble(),
          ),
          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: DatabaseController.getBowlersCollRef(
                      inningNo: inningNo, matchId: matchId)
                  .where('overs', isGreaterThan: 0)
                  .orderBy("overs", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                List<BowlerStatsRow> allBowlersList = [];

                if (!snapshot.hasData) {
                  return loadingData();
                } else {
                  final bowlersData = snapshot.data.docs;

                  bowlersData.forEach((playerData) {
                    final maidens = playerData.data()['maidens'];
                    final wickets = playerData.data()['wickets'];
                    final overs = playerData.data()['overs'];
                    final ballOfThatOver = playerData.data()['ballOfTheOver'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isBowling = playerData.data()['isBowling'];
                    final totalBalls = playerData.data()['totalBalls'];
                    final overLengthToFinishTheOver =
                        playerData.data()['overLength'];

                    double eco = 0;
                    try {
                      eco = (runs / ((overs) + (ballOfThatOver / 6)));
                    } catch (e) {
                      eco = 0;
                    }

                    if (eco.isNaN) {
                      eco = 0;
                    }

                    allBowlersList.add(BowlerStatsRow(
                      isThisSelectBowlerBtn: false,
                      bowler: Bowler(
                          playerName: playerName,
                          runs: runs.toString(),
                          economy: eco.toStringAsFixed(1),
                          median: maidens.toString(),
                          overs: "$overs.$ballOfThatOver",
                          wickets: wickets.toString(),
                          totalBallBowled: totalBalls,
                          ballOfTheOver: ballOfThatOver),
                    ));
                  });
                }
                if (allBowlersList.isEmpty) {
                  return zeroData(
                      iconData: Icons.sports_handball,
                      msg: "Bowlers data is shown here");
                }
                return Column(
                  children: allBowlersList,
                );
              })
        ],
      ),
    );
  }

  loadingData() {
    return Container(
        height: (80 * SizeConfig.oneH).roundToDouble(),
        child: Center(child: CircularProgressIndicator()));
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
}
