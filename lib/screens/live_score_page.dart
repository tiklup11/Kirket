import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/ball_widget.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';

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
  ScoreBoardData _scoreBoardData;

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
    // TODO: implement initState
    super.initState();
    // FirebaseAdMob.instance.initialize(appId: "ca-app-pub-7348080910995117/5980363458");
    _scoreBoardData = new ScoreBoardData();
    currentBothBatsmen = [];
    _scrollController = ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 5), (){
    // _bannerAd..load();
    //   _bannerAd?.show();

    return StreamBuilder<DocumentSnapshot>(
        stream: matchesRef.doc(widget.matchUID).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return CircularProgressIndicator();
          } else {
            final matchData = snapshot.data.data();

            ///
            ///getting data from firebase and setting it to the CricketMatch object
            final team1Name = matchData['team1name'];
            final team2Name = matchData['team2name'];
            final oversCount = matchData['overCount'];
            // final matchId = matchData['matchId'];
            final playerCount = matchData['playerCount'];
            final tossWinner = matchData['tossWinner'];
            final batOrBall = matchData['whatChoose'];
            final location = matchData['matchLocation'];
            final isMatchStarted = matchData['isMatchStarted'];
            final currentOverNumber = matchData['currentOverNumber'];
            final firstBattingTeam = matchData['firstBattingTeam'];
            final firstBowlingTeam = matchData['firstBowlingTeam'];
            final secondBattingTeam = matchData['secondBattingTeam'];
            final secondBowlingTeam = matchData['secondBowlingTeam'];
            final currentBattingTeam = matchData['currentBattingTeam'];
            final isFirstInningStarted = matchData['isFirstInningStarted'];
            final isFirstInningEnd = matchData['isFirstInningEnd'];
            final isSecondStartedYet = matchData['isSecondStartedYet'];
            final isSecondInningEnd = matchData['isSecondInningEnd'];
            final totalRunsOfInning1 = matchData['totalRunsOfInning1'];
            final totalRunsOfInning2 = matchData['totalRunsOfInning2'];
            final totalWicketsOfInning1 = matchData['totalWicketsOfInning1'];
            final totalWicketsOfInning2 = matchData['totalWicketsOfInning1'];
            final nonStriker = matchData['nonStrikerBatsmen'];
            final striker = matchData['strikerBatsmen'];
            final inningNo = matchData['inningNumber'];
            final currentBallNo = matchData['currentBallNo'];

            widget.match.nonStrikerBatsmen = nonStriker;
            widget.match.strikerBatsmen = striker;

            widget.match.isSecondInningEnd = isSecondInningEnd;
            widget.match.isSecondInningStartedYet = isSecondStartedYet;
            widget.match.isFirstInningEnd = isFirstInningEnd;
            widget.match.isFirstInningStartedYet = isFirstInningStarted;

            widget.match.totalRunsOf1stInning = totalRunsOfInning1;
            widget.match.totalRunsOf2ndInning = totalRunsOfInning2;
            widget.match.totalWicketsOf1stInning = totalWicketsOfInning1;
            widget.match.totalWicketsOf2ndInning = totalWicketsOfInning2;

            widget.match.firstBattingTeam = firstBattingTeam;
            widget.match.firstBowlingTeam = firstBowlingTeam;
            widget.match.secondBattingTeam = secondBattingTeam;
            widget.match.secondBowlingTeam = secondBowlingTeam;
            widget.match.setInningNo(inningNo);
            // widget.match.setMatchId(matchId);

            final totalRuns = matchData['totalRuns'];
            final wicketsDown = matchData['wicketsDown'];

            widget.match.totalRuns = totalRuns;
            widget.match.wicketDown = wicketsDown;

            widget.match.currentOver.setCurrentOverNo(currentOverNumber);
            widget.match.currentOver.setCurrentBallNo(currentBallNo);
            widget.match.setTeam1Name(team1Name);
            widget.match.setTeam2Name(team2Name);
            // widget.match.setMatchId(matchId);
            widget.match.setPlayerCount(playerCount);
            widget.match.setLocation(location);
            widget.match.setTossWinner(tossWinner);
            widget.match.setBatOrBall(batOrBall);
            widget.match.setOverCount(oversCount);
            widget.match.setIsMatchStarted(isMatchStarted);

            if (firstBattingTeam != null &&
                firstBowlingTeam != null &&
                secondBattingTeam != null &&
                secondBowlingTeam != null) {
              widget.match.setFirstInnings();
            }

            print("INNING NO:: $inningNo");
            print("Batting:: ${firstBattingTeam}");

            return Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  miniScoreCard(),
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

  ///upper scorecard with team runs and stuff
  miniScoreCard() {
    // widget.creatorUID = '4VwUugdc6XVPJkR2yltZtFGh4HN2'; //pulkitUID
    Stream<DocumentSnapshot> stream;

    if (widget.match.getInningNo() == 1) {
      stream = matchesRef
          .doc(widget.matchUID)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .snapshots();
    } else if (widget.match.getInningNo() == 2) {
      stream = matchesRef
          .doc(widget.matchUID)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .snapshots();
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return miniScoreLoadingScreen();
          } else {
            final scoreBoardData = snapshot.data.data();
            final ballOfTheOver = scoreBoardData['ballOfTheOver'];
            final currentOverNo = scoreBoardData['currentOverNo'];
            final totalRuns = scoreBoardData['totalRuns'];
            final wicketsDown = scoreBoardData['wicketsDown'];

            _scoreBoardData.currentBallNo = ballOfTheOver;
            _scoreBoardData.currentOverNo = currentOverNo;
            _scoreBoardData.totalRuns = totalRuns;
            _scoreBoardData.totalWicketsDown = wicketsDown;
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
                      color: Colors.white,
                      border: Border.all(color: Colors.black12, width: 2),
                      borderRadius: BorderRadius.circular(
                          (10 * SizeConfig.oneW).roundToDouble())),
                  child: Column(
                    children: [
                      Text("Inning ${widget.match.getInningNo()}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: SizeConfig.setWidth(280),
                                child: Text(
                                  widget.match
                                      .getCurrentBattingTeam()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: (20 * SizeConfig.oneW)
                                          .roundToDouble()),
                                ),
                              ),
                              Text(
                                // runs/wickets (currentOverNumber.currentBallNo)
                                // "65/3  (13.2)",
                                _scoreBoardData.getFormatedRunsString(),
                                style: TextStyle(
                                    fontSize:
                                        (16 * SizeConfig.oneW).roundToDouble()),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("CRR"),
                              Text(_scoreBoardData.getCrr()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
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
                      borderRadius: BorderRadius.circular(
                          (10 * SizeConfig.oneW).roundToDouble())),
                  child: playersScore(),
                )
              ],
            );
          }
        });
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
        itemBuilder: (BuildContext context, int index) => overCard(
            overNoOnCard: (index + 1),
            currentOver: widget.match.currentOver.getCurrentOverNo(),
            currentBallNo: widget.match.currentOver.getCurrentBallNo()),
      ),
    );
  }

  ///over container with 6balls
  ///we will increase no of balls in specific cases
  ///TODO: increase no of balls...in the lower section
  overCard({int overNoOnCard, int currentBallNo, int currentOver})
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
    print("OVER CARD NO::: $overNoOnCard");

    Ball currentBall = null;

    if (overNoOnCard != null) {
      return Container(
        margin: EdgeInsets.symmetric(
            vertical: (4 * SizeConfig.oneH).roundToDouble(),
            horizontal: (10 * SizeConfig.oneW).roundToDouble()),
        padding: EdgeInsets.symmetric(
            vertical: (8 * SizeConfig.oneH).roundToDouble(),
            horizontal: (4 * SizeConfig.oneW).roundToDouble()),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular((5 * SizeConfig.oneW).roundToDouble()),
            color: overNoOnCard == currentOver ? Colors.white : Colors.white60),
        // height: (60 * SizeConfig.oneH).roundToDouble(),
        // color: Colors.black26,
        child: currentOver == 0
            ? Row(children: zeroOverBalls)
            : StreamBuilder<DocumentSnapshot>(
                stream: matchesRef
                    .doc(widget.matchUID)
                    .collection('inning${widget.match.getInningNo()}overs')
                    .doc("over${overNoOnCard}")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  } else {
                    final overData = snapshot.data.data();

                    final overLength = overData['overLength'];

                    List<Widget> balls = [];

                    for (int i = 0; i < overLength; i++) {
                      balls.add(BallWidget());
                    }

                    Map<String, dynamic> fullOverData =
                        overData['fullOverData'];
                    final isThisCurrentOver = overData["isThisCurrentOver"];

                    final bowlerOfThisOver = overData['bowlerName'];
                    final currentBallNo = overData['currentBall'];

                    //decoding the map [ballNo:::RunsScores]
                    fullOverData.forEach((ballNo, runsScored) {
                      Ball ball = Ball(
                        currentBallNo: int.parse(ballNo),
                        runToShowOnUI: runsScored,
                        cardOverNo: overNoOnCard,
                        currentOverNo:
                            widget.match.currentOver.getCurrentOverNo(),
                      );

                      if (runsScored != null) {
                        balls[int.parse(ballNo) - 1] = BallWidget(
                          currentBall: ball,
                        );
                      } else {
                        print("Ball??????????  $runsScored");
                        balls[int.parse(ballNo) - 1] = BallWidget(
                          currentBall: currentBall,
                        );
                      }
                    });
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (6 * SizeConfig.oneW).roundToDouble()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("OVER NO: $overNoOnCard"),
                              SizedBox(
                                width: (30 * SizeConfig.oneW).roundToDouble(),
                              ),
                              bowlerOfThisOver == null
                                  ? Container()
                                  : Text("🏐 : $bowlerOfThisOver"),
                            ],
                          ),
                        ),
                        Container(
                          height: (60 * SizeConfig.oneH).roundToDouble(),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: balls),
                        ),
                      ],
                    );
                  }
                },
              ),
      );
    }
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
                        widget.match.strikerBatsmen = batsmen1.playerName;
                        // updateStrikerToGeneralMatchData(batsmen1.playerName);
                      }
                    }

                    if (batsmen2 != dummyBatsmen) {
                      if (batsmen2.isOnStrike) {
                        widget.match.strikerBatsmen = batsmen2.playerName;
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
