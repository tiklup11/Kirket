import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/services/database_updater.dart';

class MiniScoreCard extends StatelessWidget {
  final int inningNo;
  final String matchId;

  //this is just for title text at top: [inning : 1or2]
  final bool isLiveScoreCard;
  MiniScoreCard({@required this.inningNo, this.matchId,@required this.isLiveScoreCard});
  @override
  Widget build(BuildContext context) {
    return miniScoreCard();
  }

  ///upper scorecard with team runs and stuff
  miniScoreCard() {
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
      child: StreamBuilder<DocumentSnapshot>(
          stream: DatabaseController.getScoreBoardDocRef(
                  inningNo: inningNo, matchId: matchId)
              .snapshots(),
          builder: (context, snapshot) {
            ScoreBoardData currentInningScoreBoard = ScoreBoardData();

            if (!snapshot.hasData) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              final scoreBoardData = snapshot.data.data();
              final ballOfTheOver = scoreBoardData['ballOfTheOver'];
              final currentOverNo = scoreBoardData['currentOverNo'] + 1;
              final totalRuns = scoreBoardData['totalRuns'];
              final wicketsDown = scoreBoardData['wicketsDown'];
              final battingTeam = scoreBoardData['battingTeam'];

              currentInningScoreBoard.currentBallNo = ballOfTheOver;
              currentInningScoreBoard.currentOverNo = currentOverNo;
              currentInningScoreBoard.totalRuns = totalRuns;
              currentInningScoreBoard.totalWicketsDown = wicketsDown;
              currentInningScoreBoard.battingTeamName = battingTeam;

              return Column(
                children: [
                  isLiveScoreCard?
                  Text("Inning $inningNo"):Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.setWidth(280),
                            child: Text(
                              currentInningScoreBoard.battingTeamName
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize:
                                      (20 * SizeConfig.oneW).roundToDouble()),
                            ),
                          ),
                          Text(
                            // runs/wickets (currentOverNumber.currentBallNo)
                            // "65/3  (13.2)",
                            currentInningScoreBoard.getFormatedRunsString(),
                            style: TextStyle(
                                fontSize:
                                    (16 * SizeConfig.oneW).roundToDouble()),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("CRR"),
                          Text(currentInningScoreBoard.getCrr()),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }
          }),
    );
  }
}
