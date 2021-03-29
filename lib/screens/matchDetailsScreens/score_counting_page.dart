import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:shimmer/shimmer.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_batsmen_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_bowler_page.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/ball_widget.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';
import 'package:umiperer/widgets/live_score_loading_screen.dart';
import 'package:umiperer/widgets/score_counting_widgets/score_selection_widget.dart';

///media query done
// ignore: must_be_immutable
class ScoreCountingPage extends StatefulWidget {
  ScoreCountingPage({this.match, this.user});
  CricketMatch match;
  final User user;

  @override
  _ScoreCountingPageState createState() => _ScoreCountingPageState();
}

class _ScoreCountingPageState extends State<ScoreCountingPage> {
  Ball ballData = new Ball();
  DataStreams dataStreams;
  Random random = new Random();
  RunUpdater runUpdater;
  final scoreSelectionAreaLength = (220 * SizeConfig.oneH).roundToDouble();
  // String checkerStriker;

  List<Batsmen> currentBothBatsmen;

  Bowler dummyBowler = Bowler(
      playerName: "-------",
      runs: "-",
      wickets: "-",
      overs: "-",
      median: "-",
      economy: "-");

  Bowler currentBowler;

  List<String> loadingWinGifs = [
    "assets/gifs/win.gif",
  ];

  void setIsUploadingDataToFalse() {
    setState(() {
      isUploadingData = false;
    });
  }

  void setIsUploadingDataToTrue() {
    setState(() {
      isUploadingData = true;
    });
  }

  int getRandomIntBelow(int value) {
    //give a random int from 0-value
    int randomNumber = random.nextInt(value);
    return randomNumber;
  }

  String loadingGifPath;

  @override
  void initState() {
    super.initState();

    dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
    runUpdater = RunUpdater(
        matchId: widget.match.getMatchId(),
        context: context,
        setIsUploadingDataToFalse: setIsUploadingDataToFalse);
    currentBothBatsmen = [];

    if (loadingGifPath == null) {
      loadingGifPath = loadingWinGifs[0];
    }
  }

  // Future<void> executeAfterBuild() async {
  //   await Future.delayed(Duration(milliseconds:10));
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => executeAfterBuild);

    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseController.getGeneralMatchDoc(
                matchId: widget.match.getMatchId())
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LiveScoreLoadingFullPage();
          } else if (snapshot.hasError) {
            return LiveScoreLoadingFullPage();
          } else {
            final matchData = snapshot.data.data();

            widget.match = CricketMatch.from(snapshot.data);
            widget.match.setInningNo(matchData["inningNumber"]);

            return StreamBuilder<DocumentSnapshot>(
                stream: DatabaseController.getScoreBoardDocRef(
                        inningNo: widget.match.getInningNo(),
                        matchId: widget.match.getMatchId())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final scoreDataDoc = snapshot.data;
                  ScoreBoardData scoreBoardData =
                      ScoreBoardData.from(scoreDataDoc);
                  scoreBoardData.matchData = widget.match;
                  ballData = Ball(scoreBoardData: scoreBoardData);

                  if (widget.match.getInningNo() == 2 &&
                      widget.match.isSecondInningStartedYet) {
                    if (scoreBoardData.totalRuns >
                        scoreBoardData.totalRunsOfInning1) {
                      DatabaseController.getGeneralMatchDoc(
                              matchId: widget.match.getMatchId())
                          .update({"isSecondInningEnd": true});
                    }
                  }

                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        miniScoreCard(),
                        buildOversList(),
                        // textWidget(),
                        Expanded(
                          child: Container(
                            color: Colors.blueAccent.shade100,
                            margin:
                                EdgeInsets.only(top: SizeConfig.setHeight(16)),
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.setHeight(10),
                                horizontal: SizeConfig.setWidth(20)),
                            width: double.infinity,
                            child: ScoreSelectionWidget(
                              user: widget.user,
                              ballData: Ball(
                                scoreBoardData: scoreBoardData,
                                outBatsmenName: scoreBoardData.strikerName,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }
        });
  }

  settingBowlerNameInOverDoc({String bowlerName, int overNo}) {
    // setIsUploadingDataToTrue();
    matchesRef
        .doc(widget.match.getMatchId())
        .collection("inning${widget.match.getInningNo()}overs")
        .doc("over$overNo")
        .update({"bowlerName": bowlerName});
    // setIsUploadingDataToFalse();
  }

  matchEnd() {
    matchesRef.doc(widget.match.getMatchId()).update({
      // "totalRunsOfInning2": widget.match.getTotalRunsOf2ndInning(),
      // "totalWicketsOfInning2": widget.match.getTotalWicketsOf2ndInning(),
      "isSecondInningEnd": true,
      "isLive": false,
    });
    return;
  }

  ///upper scorecard with team runs and stuff
  miniScoreCard() {
    return Column(
      children: [
        Container(
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
              Text("Innning ${widget.match.getInningNo()}"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: SizeConfig.setWidth(300),
                        child: Text(
                          widget.match.getCurrentBattingTeam().toUpperCase(),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: (24 * SizeConfig.oneW).roundToDouble()),
                        ),
                      ),
                      Text(
                        ballData.scoreBoardData.getFormatedRunsString(),
                        style: TextStyle(
                            fontSize: (16 * SizeConfig.oneW).roundToDouble()),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("CRR"),
                      Text(ballData.scoreBoardData.getCrr()),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: (6 * SizeConfig.oneH).roundToDouble()),
                color: Colors.black12,
                height: (2 * SizeConfig.oneW).roundToDouble(),
              ),
              playersScore(),
            ],
          ),
        ),
      ],
    );
  }

  void toogleStrikeOnFirebase({String playerName, bool value}) {
    DatabaseController.getBatsmenDocRef(
            batsmenName: playerName,
            inningNo: widget.match.getInningNo(),
            matchId: widget.match.getMatchId())
        .update({
      "isOnStrike": value,
    });
  }

  ///      ///     ///
  void updateStrikerAndNonStriker({
    String striker,
    String nonStriker,
  }) {
    DatabaseController.getScoreBoardDocRef(
            inningNo: widget.match.getInningNo(),
            matchId: widget.match.getMatchId())
        .update({"strikerBatsmen": striker, "nonStrikerBatsmen": nonStriker});
  }

  ///stream-builder making batsmen score card
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
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBatsmenPage(
                  match: widget.match,
                );
              }));
            },
            child: BatsmenScoreRow(
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
          ),
          SizedBox(
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: matchesRef
                  .doc(widget.match.getMatchId())
                  .collection(
                      '${ballData.scoreBoardData.matchData.getInningNo()}InningBattingData')
                  .where("isBatting", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                currentBothBatsmen = [];
                if (!snapshot.hasData) {
                  return BatsmenScoreRow(
                    batsmen: dummyBatsmen,
                    isOnStrike: false,
                    isThisSelectBatsmenBtn: false,
                  );
                } else {
                  // isStrikerSelected = false;
                  final batsmenData = snapshot.data.docs;
                  if (batsmenData.isEmpty) {
                    return BatsmenScoreRow(
                        isThisSelectBatsmenBtn: false,
                        batsmen: dummyBatsmen,
                        isOnStrike: false);
                  } else {
                    final currentBothBatsmenData = snapshot.data.docs;

                    if (currentBothBatsmenData.isEmpty) {
                      ballData.scoreBoardData.strikerName = null;
                      ballData.scoreBoardData.nonStrikerName = null;
                    }
                    if (currentBothBatsmenData.isNotEmpty) {
                      currentBothBatsmenData.forEach((playerData) {
                        // print("DATA::  ${playerData.data()}");
                        final ballsPlayed = playerData.data()['balls'];
                        final noOf4s = playerData.data()['noOf4s'];
                        final noOf6s = playerData.data()['noOf6s'];
                        final playerName = playerData.data()['name'];
                        final runs = playerData.data()['runs'];
                        final isOnStrike = playerData.data()['isOnStrike'];

                        if (isOnStrike) {
                          ballData.scoreBoardData.strikerName = playerName;
                          // isStrikerSelected = true;
                        } else {
                          ballData.scoreBoardData.nonStrikerName = playerName;
                        }

                        double sR = 0;
                        try {
                          sR = ((runs / ballsPlayed) * 100);
                        } catch (e) {
                          sR = 0;
                        }

                        if (sR.isNaN) {
                          sR = 0.0;
                        }

                        currentBothBatsmen.add(Batsmen(
                            isClickable: true,
                            balls: ballsPlayed.toString(),
                            noOf4s: noOf4s.toString(),
                            noOf6s: noOf6s.toString(),
                            sR: sR.toStringAsFixed(0),
                            playerName: playerName,
                            runs: runs.toString(),
                            isOnStrike: isOnStrike));
                      });
                    }

                    if (currentBothBatsmen.length == 1) {
                      currentBothBatsmen.add(dummyBatsmen);
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (currentBothBatsmen[0].isClickable) {
                              toogleStrikeOnFirebase(
                                  playerName: currentBothBatsmen[0].playerName,
                                  value: true);
                              updateStrikerAndNonStriker(
                                  striker: currentBothBatsmen[0].playerName,
                                  nonStriker: currentBothBatsmen[1].playerName);
                              ballData.scoreBoardData.strikerName =
                                  currentBothBatsmen[0].playerName;
                              ballData.scoreBoardData.nonStrikerName =
                                  currentBothBatsmen[1].playerName;
                              toogleStrikeOnFirebase(
                                  playerName: currentBothBatsmen[1].playerName,
                                  value: false);
                            }
                          },
                          child: BatsmenScoreRow(
                            isThisSelectBatsmenBtn: false,
                            isOnStrike: currentBothBatsmen[0].isOnStrike,
                            batsmen: currentBothBatsmen[0],
                          ),
                        ),
                        SizedBox(
                          height: (4 * SizeConfig.oneH).roundToDouble(),
                        ),
                        GestureDetector(
                          onTap: () {
                            // && !currentBothBatsmen[1].isOnStrike
                            if (currentBothBatsmen[1].isClickable) {
                              toogleStrikeOnFirebase(
                                  playerName: currentBothBatsmen[1].playerName,
                                  value: true);
                              // ballData.scoreBoardData.strikerName = currentBothBatsmen[1].playerName;
                              updateStrikerAndNonStriker(
                                  nonStriker: currentBothBatsmen[0].playerName,
                                  striker: currentBothBatsmen[1].playerName);
                              ballData.scoreBoardData.strikerName =
                                  currentBothBatsmen[1].playerName;
                              ballData.scoreBoardData.nonStrikerName =
                                  currentBothBatsmen[0].playerName;
                              toogleStrikeOnFirebase(
                                  playerName: currentBothBatsmen[0].playerName,
                                  value: false);
                            }
                          },
                          child: BatsmenScoreRow(
                            isThisSelectBatsmenBtn: false,
                            isOnStrike: currentBothBatsmen[1].isOnStrike,
                            batsmen: currentBothBatsmen[1],
                          ),
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
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBowlerPage(
                  currentOverNo: ballData.scoreBoardData.currentOverNo,
                  match: widget.match,
                );
              }));
            },
            child: BowlerStatsRow(
              isThisSelectBowlerBtn: true,
              bowler: Bowler(
                  playerName: "Bowler",
                  runs: "R",
                  wickets: "W",
                  overs: "O",
                  median: "M",
                  economy: "E"),
            ),
          ),
          SizedBox(
            height: (4 * SizeConfig.oneH).roundToDouble(),
          ),

          ///Bowler's StreamBuilder
          StreamBuilder<QuerySnapshot>(
              stream: matchesRef
                  .doc(widget.match.getMatchId())
                  .collection(
                      '${ballData.scoreBoardData.matchData.getInningNo()}InningBowlingData')
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

                  // print("LENGTH:BOWL ${currentBowlerData.length}");

                  currentBowler = dummyBowler;

                  int overLengthToFinishTheOver; //this overLength counts wide noball etc..
                  if (currentBothBatsmen.isEmpty) {
                    ballData.scoreBoardData.bowlerName = null;
                  }
                  {
                    currentBowlerData.forEach((playerData) {
                      final maidens = playerData.data()['maidens'];
                      final wickets = playerData.data()['wickets'];
                      final overs = playerData.data()['overs'];
                      final ballOfThatOver = playerData.data()['ballOfTheOver'];
                      final playerName = playerData.data()['name'];
                      final runs = playerData.data()['runs'];
                      final isBowling = playerData.data()['isBowling'];
                      final totalBalls = playerData.data()['totalBalls'];
                      overLengthToFinishTheOver =
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
                  }

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

  updateBowlerDataToGeneralDoc() {}

  buildOversList() {
    return Container(
      height: SizeConfig.setHeight(105),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) =>
            overCard(overNoOnCard: (index + 1)),
      ),
    );
  }

  ///over container with 6balls
  ///we will increase no of balls in specific cases
  overCard({int overNoOnCard})
  //String bowlerName,String batsman1Name,String batsman2Name
  {
    List<Widget> zeroOverBalls = [
      BallWidget(),
      BallWidget(),
      BallWidget(),
      BallWidget(),
      BallWidget(),
      BallWidget(),
    ];
    // print("OVER CARD NO::: $overNoOnCard");

    Ball currentBall = null;

    if (overNoOnCard != null) {
      return Bounce(
        duration: Duration(milliseconds: 200),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: (6 * SizeConfig.oneH).roundToDouble(),
              horizontal: (6 * SizeConfig.oneW).roundToDouble()),
          padding: EdgeInsets.symmetric(
              vertical: (8 * SizeConfig.oneH).roundToDouble(),
              horizontal: (4 * SizeConfig.oneW).roundToDouble()),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black12, width: 2)),
          // height: (60 * SizeConfig.oneH).roundToDouble(),
          child: ballData.scoreBoardData.currentOverNo == 0
              ? Row(children: zeroOverBalls)
              : StreamBuilder<DocumentSnapshot>(
                  stream: dataStreams.getFullOverDataStream(
                      inningNo: ballData.scoreBoardData.matchData.getInningNo(),
                      overNumber: overNoOnCard),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return overCardLoading(zeroOverBalls: zeroOverBalls);
                    } else {
                      final overData = snapshot.data.data();

                      final overLength = overData['overLength'];

                      List<Widget> balls = [];

                      for (int i = 0; i < overLength; i++) {
                        balls.add(BallWidget());
                      }

                      Map<String, dynamic> fullOverData =
                          overData['fullOverData'];

                      final bowlerOfThisOver = overData['bowlerName'];

                      //decoding the map [ballNo:::RunsScores]
                      fullOverData.forEach((ballNo, runsScored) {
                        Ball ball = Ball(
                          scoreBoardData: ballData.scoreBoardData,
                          // currentBallNo: int.parse(ballNo),
                          runToShowOnUI: runsScored,
                          cardOverNo: overNoOnCard,
                          // currentOverNo: currentOverNo,
                        );

                        if (runsScored != null) {
                          balls[int.parse(ballNo) - 1] = BallWidget(
                            currentBall: ball,
                          );
                        } else {
                          // print("Ball??????????  $runsScored");
                          balls[int.parse(ballNo) - 1] = BallWidget(
                            currentBall: currentBall,
                          );
                        }
                      });
                      return Column(
                        children: [
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("OVER NO: $overNoOnCard"),
                              SizedBox(
                                width: 20,
                              ),
                              bowlerOfThisOver == null
                                  ? Container()
                                  : SizedBox(
                                      child: Text(
                                      "🏐 : $bowlerOfThisOver",
                                      overflow: TextOverflow.ellipsis,
                                    )),
                            ],
                          ),
                          Row(children: balls),
                        ],
                      );
                    }
                  },
                ),
        ),
      );
    }
  }

  scoreSelectionLoading() {
    return Center(
      child: Text("Loading.."),
    );
  }

  bool isUploadingData = false;

  ///bye & legBye & out & noBall, these things have their own
  ///

  ///SelectBatsmen and bowler btn

  BoxDecoration _loadingBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(SizeConfig.setWidth(10)),
    color: Colors.white,
  );

  ///
  Widget miniScoreLoadingScreen() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Container(
        height: SizeConfig.setHeight(260),
        decoration: _loadingBoxDecoration,
      ),
    );
  }

  Widget overCardLoading({List<Widget> zeroOverBalls}) {
    String bowlerOfThisOver;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("OVER NO: 0"),
            SizedBox(
              width: 30 * SizeConfig.oneW,
            ),
            bowlerOfThisOver == null
                ? Container()
                : Text("🏐 : $bowlerOfThisOver"),
          ],
        ),
        Row(children: zeroOverBalls),
      ],
    );
  }
}
