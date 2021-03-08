import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';
import 'package:umiperer/widgets/headline_widget.dart';
import 'package:umiperer/widgets/shimmer_container.dart';
import 'package:umiperer/widgets/over_card.dart';

class FirstInningScoreCard extends StatefulWidget {
  FirstInningScoreCard({this.creatorUID, this.match});
  final String creatorUID;
  final CricketMatch match;
  // final String matchUID;
  @override
  _FirstInningScoreCardState createState() => _FirstInningScoreCardState();
}

class _FirstInningScoreCardState extends State<FirstInningScoreCard> {
  List<Batsmen> currentBothBatsmen;
  DataStreams dataStreams;

  ScoreBoardData firstInningScoreBoard = ScoreBoardData();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          tossLineWidget(),
          widget.match.isFirstInningEnd
              ? Center(
                  child: HeadLineWidget(headLineString: "First inning ended"))
              : Container(),
          HeadLineWidget(headLineString: "SCORECARD"),
          miniScoreCard(),
          HeadLineWidget(headLineString: widget.match.firstBattingTeam),
          batsmenList(),
          HeadLineWidget(headLineString: widget.match.firstBowlingTeam),
          bowlersList(),
          HeadLineWidget(headLineString: "OVERS"),
          buildOversList(),
        ],
      ),
    );
  }

  bowlersList() {
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
              stream: matchesRef
                  .doc(widget.match.getMatchId())
                  .collection('1InningBowlingData')
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
                    final totalBalls = playerData.data()['totalBalls'];

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
              stream: matchesRef
                  .doc(widget.match.getMatchId())
                  .collection('1InningBattingData')
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

  ///upper scorecard with team runs and stuff
  miniScoreCard() {
    Stream<DocumentSnapshot> stream;
    stream = matchesRef
        .doc(widget.match.getMatchId())
        .collection('FirstInning')
        .doc("scoreBoardData")
        .snapshots();

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
          stream: stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            } else {
              final scoreBoardData = snapshot.data.data();
              final ballOfTheOver = scoreBoardData['ballOfTheOver'];
              final currentOverNo = scoreBoardData['currentOverNo'];
              final totalRuns = scoreBoardData['totalRuns'];
              final wicketsDown = scoreBoardData['wicketsDown'];

              firstInningScoreBoard.currentBallNo = ballOfTheOver;
              firstInningScoreBoard.currentOverNo = currentOverNo;
              firstInningScoreBoard.totalRuns = totalRuns;
              firstInningScoreBoard.totalWicketsDown = wicketsDown;
              firstInningScoreBoard.battingTeamName =
                  widget.match.firstBattingTeam;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: SizeConfig.setWidth(280),
                            child: Text(
                              firstInningScoreBoard.battingTeamName
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize:
                                      (20 * SizeConfig.oneW).roundToDouble()),
                            ),
                          ),
                          Text(
                            // runs/wickets (currentOverNumber.currentBallNo)
                            // "65/3  (13.2)",
                            firstInningScoreBoard.getFormatedRunsString(),
                            style: TextStyle(
                                fontSize:
                                    (16 * SizeConfig.oneW).roundToDouble()),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text("CRR"),
                          Text(firstInningScoreBoard.getCrr()),
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

  loadingData() {
    return Container(
        height: (80 * SizeConfig.oneH).roundToDouble(),
        child: Center(child: CircularProgressIndicator()));
  }

  buildOversList() {
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
      child: ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) => DummyOverCard(
          inningNo: 1,
          creatorUID: widget.creatorUID,
          match: widget.match,
          overNoOnCard: (index + 1),
        ),
      ),
    );
  }

  ///TODO: might change its position
  tossLineWidget() {
    return Container(
        padding: EdgeInsets.only(
            left: (12 * SizeConfig.oneW).roundToDouble(),
            top: (12 * SizeConfig.oneH).roundToDouble()),
        child: Center(
          child: Text(
            "${widget.match.getTossWinner().toUpperCase()} won the TOSS and choose to ${widget.match.getChoosedOption().toUpperCase()}",
            maxLines: 2,
            style: TextStyle(fontSize: 12),
          ),
        ));
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
