import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';
import 'package:umiperer/screens/matchDetailsScreens/mini_score.dart';
import 'package:umiperer/widgets/over_card.dart';

//remove scaffold
//add into tabBarView along with other shit
///mqd
class LiveScorePage extends StatefulWidget {
  LiveScorePage({this.creatorUID, this.matchUID, this.match});

  String creatorUID;
  String matchUID;
  CricketMatch match;

  @override
  _LiveScorePageState createState() => _LiveScorePageState();
}

class _LiveScorePageState extends State<LiveScorePage> {
  final scoreSelectionAreaLength = (220 * SizeConfig.oneH).roundToDouble();
  List<Batsmen> currentBothBatsmen;
  ScrollController _scrollController;

  Bowler dummyBowler = Bowler(
      playerName: "-------",
      runs: "-",
      wickets: "-",
      overs: "-",
      median: "-",
      economy: "-");

  Bowler currentBowler;
  Batsmen batsmen1;
  Batsmen batsmen2;

  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance.initialize(appId: "ca-app-pub-7348080910995117/5980363458");
    currentBothBatsmen = [];
    _scrollController = ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<DocumentSnapshot>(
        stream: matchesRef.doc(widget.matchUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return CircularProgressIndicator();
          } else {
            final matchData = snapshot.data;

            widget.match = CricketMatch.from(matchData);

            return Container(
              color: Colors.white,
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  MiniScoreCard(
                    inningNo: widget.match.getInningNo(),
                    isLiveScoreCard: true,
                    matchId: widget.match.getMatchId(),
                  ),
                  playersScore(),
                  buildOversList(),
                ],
              ),
            );
          }
        });
  }

  ///
  Widget miniScoreLoadingScreen() {
    return Container(
      child: Center(
        child: Text("Loading.."),
      ),
    );
  }

  buildOversList() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.only(
        left: (10 * SizeConfig.oneW).roundToDouble(),
        right: (10 * SizeConfig.oneW).roundToDouble(),
        bottom: (10 * SizeConfig.oneW).roundToDouble(),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius:
              BorderRadius.circular((10 * SizeConfig.oneW).roundToDouble())),
      child: ListView.builder(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) => DummyOverCard(
          inningNo: widget.match.getInningNo(),
          creatorUID: widget.creatorUID,
          match: widget.match,
          overNoOnCard: (index + 1),
        ),
      ),
    );
  }

  playersScore() {
    final Batsmen dummyBatsmen = Batsmen(
        isClickable: false,
        isOnStrike: false,
        runs: "-",
        playerName: "--------",
        sR: "-",
        noOf6s: "-",
        noOf4s: "-",
        balls: "-");

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
            isThisSelectBatsmenBtn: true,
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
          SizedBox(
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: matchesRef
                  .doc(widget.matchUID)
                  .collection('${widget.match.getInningNo()}InningBattingData')
                  .where("isBatting", isEqualTo: true)
                  .snapshots(),

              // stream: dataStreams.batsmenData(inningNumber: inningNumber).where((isBatting) => false).where((isOnStrike) => true),
              builder: (context, snapshot) {
                currentBothBatsmen = [];

                if (!snapshot.hasData) {
                  return BatsmenScoreRow(
                    batsmen: dummyBatsmen,
                    isOnStrike: false,
                    isThisSelectBatsmenBtn: false,
                  );
                } else {
                  final batsmenData = snapshot.data.docs;
                  if (batsmenData.isEmpty) {
                    return BatsmenScoreRow(
                        isThisSelectBatsmenBtn: false,
                        batsmen: dummyBatsmen,
                        isOnStrike: false);
                  } else {
                    final currentBothBatsmenData = snapshot.data.docs;

                    print("LENGTH: ${currentBothBatsmenData.length}");

                    currentBothBatsmenData.forEach((playerData) {
                      print("DATA::  ${playerData.data()}");
                      final ballsPlayed = playerData.data()['balls'];
                      final noOf4s = playerData.data()['noOf4s'];
                      final noOf6s = playerData.data()['noOf6s'];
                      final playerName = playerData.data()['name'];
                      final runs = playerData.data()['runs'];
                      final isOnStrike = playerData.data()['isOnStrike'];

                      double SR = 0;
                      try {
                        print(
                            "tryinggggggggggggggggggggggggggggggggggggggggggggggggggg");
                        SR = ((runs / ballsPlayed) * 100);
                        print(
                            "tryinggggggggggggggggggggggggggggggggggggggggggggggggggg ;;SR== $SR");
                      } catch (e) {
                        print("Failedddddddddddddddddddddd");
                        SR = 0;
                      }

                      if (SR.isNaN) {
                        SR = 0.0;
                      }

                      currentBothBatsmen.add(Batsmen(
                          isClickable: false,
                          balls: ballsPlayed.toString(),
                          noOf4s: noOf4s.toString(),
                          noOf6s: noOf6s.toString(),
                          sR: SR.toStringAsFixed(0),
                          playerName: playerName,
                          runs: runs.toString(),
                          isOnStrike: isOnStrike));
                    });

                    if (currentBothBatsmen.length == 1) {
                      currentBothBatsmen.add(dummyBatsmen);
                    }

                    if (currentBothBatsmen[0] != null) {
                      batsmen1 = currentBothBatsmen[0];
                    } else {
                      batsmen1 = dummyBatsmen;
                    }

                    if (currentBothBatsmen[1] != null) {
                      batsmen2 = currentBothBatsmen[1];
                    } else {
                      batsmen2 = dummyBatsmen;
                    }

                    if (batsmen1 != dummyBatsmen) {
                      if (batsmen1.isOnStrike) {
                        // widget.match.strikerBatsmen = batsmen1.playerName;
                        // updateStrikerToGeneralMatchData(batsmen1.playerName);
                      }
                    }

                    if (batsmen2 != dummyBatsmen) {
                      if (batsmen2.isOnStrike) {
                        // widget.match.strikerBatsmen = batsmen2.playerName;
                        // updateStrikerToGeneralMatchData(batsmen2.playerName);
                      } else {
                        // updateNonStrikerToGeneralMatchData(batsmen2.playerName);
                      }
                    }

                    return Column(
                      children: [
                        BatsmenScoreRow(
                          isThisSelectBatsmenBtn: false,
                          isOnStrike: batsmen1.isOnStrike,
                          batsmen: batsmen1,
                        ),
                        SizedBox(
                          height: (4 * SizeConfig.oneH).roundToDouble(),
                        ),
                        BatsmenScoreRow(
                          isThisSelectBatsmenBtn: false,
                          isOnStrike: batsmen2.isOnStrike,
                          batsmen: batsmen2,
                        ),
                      ],
                    );
                  }
                }
              }),
          //Line
          Container(
            margin: EdgeInsets.symmetric(
                vertical: (6 * SizeConfig.oneH).roundToDouble()),
            color: Colors.black12,
            height: (2 * SizeConfig.oneH).roundToDouble(),
          ),
          SizedBox(
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),
          //Bowler's Data
          BowlerStatsRow(
            isThisSelectBowlerBtn: true,
            bowler: Bowler(
                playerName: "Bowler",
                runs: "R",
                wickets: "W",
                overs: "O",
                median: "M",
                economy: "E"),
          ),
          SizedBox(
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          ///Bowler's StreamBuilder
          StreamBuilder<QuerySnapshot>(
              stream: matchesRef
                  .doc(widget.matchUID)
                  .collection('${widget.match.getInningNo()}InningBowlingData')
                  .where("isBowling", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return BowlerStatsRow(
                    isThisSelectBowlerBtn: false,
                    bowler: dummyBowler,
                  );
                } else {
                  final currentBowlerData = snapshot.data.docs;

                  print("LENGTH:BOWL ${currentBowlerData.length}");

                  currentBowler = dummyBowler;

                  int overLengthToFinishTheOver; //this overLength counts wide noball etc..

                  currentBowlerData.forEach((playerData) {
                    final maidens = playerData.data()['maidens'];
                    final wickets = playerData.data()['wickets'];
                    final overs = playerData.data()['overs'];
                    final ballOfThatOver = playerData.data()['ballOfTheOver'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isBowling = playerData.data()['isBowling'];
                    final totalBalls = playerData.data()['totalBalls'];
                    overLengthToFinishTheOver = playerData.data()['overLength'];

                    double eco = 0;
                    try {
                      eco = (runs / ((overs) + (ballOfThatOver / 6)));
                    } catch (e) {
                      eco = 0;
                    }

                    if (eco.isNaN) {
                      eco = 0;
                    }

                    currentBowler = Bowler(
                        playerName: playerName,
                        runs: runs.toString(),
                        economy: eco.toStringAsFixed(1),
                        median: maidens.toString(),
                        overs: "$overs.$ballOfThatOver",
                        wickets: wickets.toString(),
                        totalBallBowled: totalBalls,
                        ballOfTheOver: ballOfThatOver);
                  });

                  return BowlerStatsRow(
                    isThisSelectBowlerBtn: false,
                    bowler: currentBowler,
                  );
                }
              }),
        ],
      ),
    );
  }
}
