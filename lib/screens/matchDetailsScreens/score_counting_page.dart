import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_batsmen_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_bowler_page.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/ball_widget.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';
import 'package:umiperer/widgets/differentWidgets/bye_options.dart';
import 'package:umiperer/widgets/differentWidgets/leg_bye_options.dart';
import 'package:umiperer/widgets/differentWidgets/no_ball_options.dart';
import 'package:umiperer/widgets/differentWidgets/out_options.dart';
import 'package:umiperer/widgets/differentWidgets/wide_ball_options.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';
import "dart:io";
///media query done

class ScoreCountingPage extends StatefulWidget {
  ScoreCountingPage({this.match, this.user});
  final CricketMatch match;
  final User user;

  @override
  _ScoreCountingPageState createState() => _ScoreCountingPageState();
}

class _ScoreCountingPageState extends State<ScoreCountingPage> {
  DataStreams dataStreams;
  ScrollController _scrollController;
  RunUpdater runUpdater;
  final scoreSelectionAreaLength = (220*SizeConfig.one_H).roundToDouble();
  bool isBatsmen1OnStrike = true;
  String globalOnStrikeBatsmen;
  String globalCurrentBowler;

  int inningNumber;
  int currentOverNo;
  int currentBallNo;

  List<Batsmen> currentBothBatsmen;

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

  ///
  bool isWideBall =false;
  bool isLegBye =false;
  bool isBye = false;
  bool isOut = false;
  bool isNoBall = false;
  ///

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController(keepScrollOffset: true);
    dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
    runUpdater = RunUpdater(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
    currentBothBatsmen=[];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: dataStreams.getGeneralMatchDataStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final matchData = snapshot.data.data();

            currentOverNo = matchData['currentOverNumber'];
            currentBallNo = matchData['currentBallNo'];
            inningNumber = matchData["inningNumber"];
            globalCurrentBowler = matchData["currentBowler"];

            ///getting data from firebase and setting it to the CricketMatch object
            final team1Name = matchData['team1name'];
            final team2Name = matchData['team2name'];
            final oversCount = matchData['overCount'];
            final matchId = matchData['matchId'];
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

            widget.match.firstBattingTeam=firstBattingTeam;
            widget.match.firstBowlingTeam=firstBowlingTeam;
            widget.match.secondBattingTeam=secondBattingTeam;
            widget.match.secondBowlingTeam=secondBowlingTeam;
            widget.match.setInningNo(inningNumber);

            final totalRuns = matchData['totalRuns'];
            final wicketsDown = matchData['wicketsDown'];

            if(firstBattingTeam!=null && firstBowlingTeam!=null && secondBattingTeam!=null && secondBowlingTeam!=null)
            {
              widget.match.setFirstInnings();
            }

            widget.match.currentOver.setCurrentOverNo(currentOverNumber);
            widget.match.setTeam1Name(team1Name);
            widget.match.setTeam2Name(team2Name);
            widget.match.setMatchId(matchId);
            widget.match.setPlayerCount(playerCount);
            widget.match.setLocation(location);
            widget.match.setTossWinner(tossWinner);
            widget.match.setBatOrBall(batOrBall);
            widget.match.setOverCount(oversCount);
            widget.match.setIsMatchStarted(isMatchStarted);


            ///this is my stuff tobe done
            if(currentOverNo==widget.match.getOverCount()+1){
              //updateInningNo;
              updateInningNumberAndOtherStuff(totalRuns: totalRuns,totalWickets: wicketsDown);
              widget.match.setInningNo(2);
            }

            if(globalCurrentBowler!=null && currentOverNumber!=null){
              //set bowlerName in overDoc
              settingBowlerNameInOverDoc(bowlerName: globalCurrentBowler,overNo: currentOverNumber);
            }

            return Container(
              color: Colors.black12,
              child: Column(
                children: [
                  miniScoreCard(),
                  buildOversList(),
                  textWidget(),
                  // currentOverNo == 0
                  //     ? startOverBtns():
                  whenToDisplayWhatAtBottom(),
                ],
              ),
            );
          }
        });
  }

  settingBowlerNameInOverDoc({String bowlerName, int overNo}) async{
    await usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .collection("inning${widget.match.getInningNo()}overs")
        .doc("over$overNo")
        .update({
      "bowlerName":bowlerName
    });
  }

  updateInningNumberAndOtherStuff({int totalRuns,int totalWickets}) async{

    ///when 1st inning will end
    if(widget.match.getInningNo()==1){
      await usersRef
          .doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .update({

        "1stInningTotalRuns":totalRuns,
        "1stInningTotalWickets":totalWickets,

        "inningNumber": 2,
        "battingTeam": widget.match.secondBattingTeam,
        "currentBattingTeam": widget.match.secondBattingTeam,
        "currentOverNumber": 1,
        "nonStrikerBatsmen": null,
        "strikerBatsmen": null,
        "totalRuns": 0,
        "wicketsDown": 0,
      });
    }

    if(widget.match.getInningNo()==2){
      await usersRef
          .doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .update({
        "2stInningTotalRuns":totalRuns,
        "2stInningTotalWickets":totalWickets,
      });
    }
  }

  Widget textWidget() {
    return Container(
      margin: EdgeInsets.only(top: (3*SizeConfig.one_H).roundToDouble(), bottom: (6*SizeConfig.one_H).roundToDouble()),
      child: Text(
        'OPTIONS FOR NEXT BALL',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  ///upper scorecard with team runs and stuff
  miniScoreCard() {
    return StreamBuilder<DocumentSnapshot>(
        stream: dataStreams.getCurrentInningScoreBoardDataStream(
            inningNo: inningNumber),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return miniScoreLoadingScreen();
          } else {
            final scoreBoardData = snapshot.data.data();
            final ballOfTheOver = scoreBoardData['ballOfTheOver'];
            final currentOverNo = scoreBoardData['currentOverNo'];
            final totalRuns = scoreBoardData['totalRuns'];
            final wicketsDown = scoreBoardData['wicketsDown'];

            ///setting scoreBoardData
            final String runsFormat =
                "$totalRuns/$wicketsDown ($currentOverNo.$ballOfTheOver)";
            double CRR = 0.0;
            try {
              CRR = totalRuns / (currentOverNo+1);
            } catch (e) {
              CRR = 0.0;
            }
            return Column(
              children: [
                tossLineWidget(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.one_W).roundToDouble(), vertical: (10*SizeConfig.one_H).roundToDouble()),
                  margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.one_W).roundToDouble(), vertical: (10*SizeConfig.one_H).roundToDouble()),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((4*SizeConfig.one_W).roundToDouble()),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.match.getCurrentBattingTeam().toUpperCase(),
                                style: TextStyle(fontSize: (24*SizeConfig.one_W).roundToDouble()),
                              ),
                              Text(
                                // runs/wickets (currentOverNumber.currentBallNo)
                                // "65/3  (13.2)",
                                runsFormat,
                                style: TextStyle(fontSize: (16*SizeConfig.one_W).roundToDouble()),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Text("CRR"),
                              CRR.isNaN
                                  ? Text("0.0")
                                  : Text(CRR.toStringAsFixed(2)),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: (6*SizeConfig.one_H).roundToDouble()),
                        color: Colors.black12,
                        height: (2*SizeConfig.one_W).roundToDouble(),
                      ),
                      playersScore(),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }

  void toogleStrikeOnFirebase({String playerName, bool value}) {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .collection('${widget.match.getInningNo()}InningBattingData')
        .doc(playerName)
        .update({
      "isOnStrike": value,
    });
  }

  ///      ///     ///
  void updateStrikerToGeneralMatchData(String playerName) {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .update({"strikerBatsmen": playerName});
  }

  void updateNonStrikerToGeneralMatchData(String playerName) {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .update({"nonStrikerBatsmen": playerName});
  }

  void updateBowlerDataToGeneralMatchData(String playerName) {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .update({"currentBowler": playerName});
  }


  ///stream-builder making batsmen score card
  playersScore() {
    final Batsmen dummyBatsmen = Batsmen(
        isClickable: false,
        isOnStrike: false,
        runs: "-",
        playerName: "--------",
        SR: "-",
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
                  user: widget.user,
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
                  SR: "SR",
                  noOf6s: "6s",
                  noOf4s: "4s",
                  balls: "B"),
            ),
          ),
          SizedBox(
            height: (4*SizeConfig.one_H).roundToDouble(),
          ),

          //Batsman's data
          StreamBuilder<QuerySnapshot>(
              stream: usersRef
                  .doc(widget.user.uid)
                  .collection('createdMatches')
                  .doc(widget.match.getMatchId())
                  .collection('${inningNumber}InningBattingData')
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
                        print("tryinggggggggggggggggggggggggggggggggggggggggggggggggggg");
                        SR = ((runs / ballsPlayed) * 100);
                        print("tryinggggggggggggggggggggggggggggggggggggggggggggggggggg ;;SR== $SR");
                      } catch (e) {
                        print("Failedddddddddddddddddddddd");
                        SR = 0;
                      }


                      currentBothBatsmen.add(Batsmen(
                          isClickable: true,
                          balls: ballsPlayed.toString(),
                          noOf4s: noOf4s.toString(),
                          noOf6s: noOf6s.toString(),
                          SR: SR.toStringAsFixed(0),
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
                        globalOnStrikeBatsmen = batsmen1.playerName;
                        updateStrikerToGeneralMatchData(batsmen1.playerName);
                      } else {
                        updateNonStrikerToGeneralMatchData(batsmen1.playerName);
                      }
                    }

                    if (batsmen2 != dummyBatsmen) {
                      if (batsmen2.isOnStrike) {
                        globalOnStrikeBatsmen = batsmen2.playerName;
                        updateStrikerToGeneralMatchData(batsmen2.playerName);
                      } else {
                        updateNonStrikerToGeneralMatchData(batsmen2.playerName);
                      }
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!batsmen1.isOnStrike & batsmen1.isClickable) {
                                toogleStrikeOnFirebase(
                                    playerName: batsmen1.playerName,
                                    value: true);
                                batsmen1.isOnStrike = true;
                                batsmen2.isOnStrike = false;
                                globalOnStrikeBatsmen = batsmen1.playerName;
                                toogleStrikeOnFirebase(
                                    playerName: batsmen2.playerName,
                                    value: false);
                              }
                            });
                          },
                          child: BatsmenScoreRow(
                            isThisSelectBatsmenBtn: false,
                            isOnStrike: batsmen1.isOnStrike,
                            batsmen: batsmen1,
                          ),
                        ),
                        SizedBox(
                          height: (4*SizeConfig.one_H).roundToDouble(),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!batsmen2.isOnStrike &&
                                  batsmen2.isClickable) {
                                toogleStrikeOnFirebase(
                                    playerName: batsmen2.playerName,
                                    value: true);
                                batsmen2.isOnStrike = true;
                                batsmen1.isOnStrike = false;
                                globalOnStrikeBatsmen = batsmen2.playerName;
                                toogleStrikeOnFirebase(
                                    playerName: batsmen1.playerName,
                                    value: false);
                              }
                            });
                          },
                          child: BatsmenScoreRow(
                            isThisSelectBatsmenBtn: false,
                            isOnStrike: batsmen2.isOnStrike,
                            batsmen: batsmen2,
                          ),
                        ),
                      ],
                    );
                  }
                }
              }),
          //Line
          Container(
            margin: EdgeInsets.symmetric(vertical: (6*SizeConfig.one_H).roundToDouble()),
            color: Colors.black12,
            height: (2*SizeConfig.one_H).roundToDouble(),
          ),
          SizedBox(
            height: (4*SizeConfig.one_H).roundToDouble(),
          ),
          //Bowler's Data
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBowlerPage(
                  match: widget.match,
                  user: widget.user,
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
            height: (4*SizeConfig.one_H).roundToDouble(),
          ),

          ///Bowler's StreamBuilder
          StreamBuilder<QuerySnapshot>(
              stream: usersRef
                  .doc(widget.user.uid)
                  .collection('createdMatches')
                  .doc(widget.match.getMatchId())
                  .collection('${inningNumber}InningBowlingData')
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

                  currentBowlerData.forEach((playerData) {
                    final maidens = playerData.data()['maidens'];
                    final wickets = playerData.data()['wickets'];
                    final overs = playerData.data()['overs'];
                    final ballOfThatOver = playerData.data()['ballOfTheOver'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isBowling = playerData.data()['isBowling'];
                    final totalBalls = playerData.data()['totalBalls'];

                    int eco = 0;
                    try {
                      eco = (runs / overs) * 100;
                    } catch (e) {
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

                  if (currentBowler != dummyBowler) {
                    updateBowlerDataToGeneralMatchData(
                        currentBowler.playerName);
                    print("CURRENT B:: ${currentBowler.playerName}");
                  }

                  ///this is checking if the over is done or not
                  if (currentBowler.ballOfTheOver ==
                          currentBowler.totalBallBowled &&
                      currentBowler != dummyBowler) {

                    thingsToDoAfterOverIsComplete(bowlerName: currentBowler.playerName);
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

  thingsToDoAfterOverIsComplete({String bowlerName}) async{
    ///update isBowling to false
    await updateIsBowling(
        bowlerName: bowlerName, setTo: false);

    ///ballOfTheOver==0 || displaySelectBowlerBtn ||currentOver++
    currentBowler = dummyBowler;
    await updateBowlerDataToGeneralDoc();
    await updateDataInScoreBoard();
    // sleep(Duration(milliseconds: 500));
    //TODO: checking if sleep is required or not
    print("CHANGING OVER ||||||| I REPEAT CHANGING OVER");
  }

  updateIsBowling({String bowlerName, bool setTo}) {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .collection('${widget.match.getInningNo()}InningBowlingData')
        .doc(bowlerName)
        .update({
      "isBowling": setTo,
      "ballOfTheOver": 0,
      "overs": FieldValue.increment(1)
    });
  }

  updateBowlerDataToGeneralDoc() {
    usersRef
        .doc(widget.user.uid)
        .collection('createdMatches')
        .doc(widget.match.getMatchId())
        .update({
      "currentOverNumber": FieldValue.increment(1),
      "currentBallNo": 0,
      "currentBowler": null
    });
  }

  buildOversList() {
    // print('WWWWWWWWWWWWWWWWWW::: inning${inningNumber}over');

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) => overCard(
            overNoOnCard: (index + 1),
            currentOver: currentOverNo,
            currentBallNo: currentBallNo),
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
            vertical: (6*SizeConfig.one_H).roundToDouble(),
            horizontal: (6*SizeConfig.one_W).roundToDouble()),
        padding: EdgeInsets.symmetric(
            vertical: (8*SizeConfig.one_H).roundToDouble(),
            horizontal: (4*SizeConfig.one_W).roundToDouble()),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((5*SizeConfig.one_W).roundToDouble()),
            color: overNoOnCard == currentOver ? Colors.white : Colors.white60),
        height: (60*SizeConfig.one_H).roundToDouble(),
        // color: Colors.black26,
        child: currentOver == 0
            ? Row(children: zeroOverBalls)
            : StreamBuilder<DocumentSnapshot>(
                stream: dataStreams.getFullOverDataStream(
                    inningNo: inningNumber, overNumber: overNoOnCard),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Loading");
                  } else {
                    final overData = snapshot.data.data();

                    List<Widget> balls = [
                      BallWidget(),
                      BallWidget(),
                      BallWidget(),
                      BallWidget(),
                      BallWidget(),
                      BallWidget(),
                    ];

                    Map<String, dynamic> fullOverData =
                        overData['fullOverData'];
                    final isThisCurrentOver =
                        overData["isThisCurrentOver"];

                    final bowlerOfThisOver = overData['bowlerName'];

                    final currentBallNo = overData['currentBall'];

                    //decoding the map [ballNo:::RunsScores]
                    fullOverData.forEach((ballNo, runsScored) {
                      Ball ball = Ball(
                        currentBallNo: int.parse(ballNo),
                        runScoredOnThisBall: runsScored,
                        cardOverNo: overNoOnCard,
                        currentOverNo: currentOverNo,
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
                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                          children: [
                            Text("OVER NO: $overNoOnCard"),
                            SizedBox(width: 30,),
                            bowlerOfThisOver==null?
                                Container():
                            Text("🏐 : $bowlerOfThisOver"),
                          ],
                        ),
                        Row(children: balls),
                      ],
                    );
                  }
                },
              ),
      );
    }
  }

  scoreSelectionLoading(){
    return Center(
      child: Text("Loading.."),
    );
  }

  ///this is placed at the bottom, contains many run buttons
  scoreSelectionWidget({int ballNo, int inningNo}) {
    final double buttonWidth = (60*SizeConfig.one_W).roundToDouble();
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.one_W).roundToDouble(),
    );

    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.blueGrey.shade400,
      child: StreamBuilder<DocumentSnapshot>(
          stream: dataStreams.getGeneralMatchDataStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return scoreSelectionLoading();
            } else {

              Ball thisBall;

              final matchData = snapshot.data.data();
              final currentOver = matchData['currentOverNumber'];
              final currentBallNo = matchData['currentBallNo'];
              final strikerBatsmen = matchData['strikerBatsmen'];
              final nonStrikerBatsmen = matchData['nonStrikerBatsmen'];
              final currentBowler = matchData['currentBowler'];
              final inningNo = matchData['inningNumber'];

              thisBall = Ball(
                bowlerName: currentBowler,
                inningNo: inningNo,
                currentOverNo: currentOver,
                currentBallNo: currentBallNo,
                batsmenName: strikerBatsmen,
              );

              return Container(
                padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.one_W).roundToDouble(), vertical: (6*SizeConfig.one_H).roundToDouble()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///row one [0,1,2,3,4]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=0;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("0")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=1;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("1")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=2;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("2")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=3;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("3")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=4;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("4")),
                      ],
                    ),

                    ///row 2 [6,Wide,LB,Bye,NB]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=6;
                              thisBall.isNormalRun=true;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("6")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                              thisBall.runScoredOnThisBall=0;
                              thisBall.runKey=K_WIDEBALL;
                              thisBall.isNormalRun=false;

                              setState(() {
                                isWideBall=true;
                              });

                              // runUpdater.updateRun(
                              //     thisBall: thisBall);

                            },
                            child: Text("Wide")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: out btn clicked
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                              thisBall.runScoredOnThisBall=0;
                              thisBall.runKey=K_BYE;
                              thisBall.isNormalRun=false;

                              setState(() {
                                isBye=true;
                              });

                              // runUpdater.updateRun(
                              //     thisBall: thisBall);
                            },
                            child: Text("Bye")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: legBye runs need to updated [open new run set]
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                              thisBall.runScoredOnThisBall=0;
                              thisBall.runKey=K_LEGBYE;
                              thisBall.isNormalRun=false;

                              setState(() {
                                isLegBye=true;
                              });

                              // runUpdater.updateRun(
                              //     thisBall: thisBall);

                            },
                            child: Text("LB")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: no-ball -- open new no-ball set
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 1);
                              thisBall.runScoredOnThisBall=0;
                              thisBall.runKey=K_NOBALL;
                              thisBall.isNormalRun=false;

                              setState(() {
                                isNoBall=true;
                              });
                              // runUpdater.updateRun(
                              //     thisBall: thisBall);

                            },
                            child: Text("NB")),

                      ],
                    ),

                    ///row 3 [over throw, overEnd,]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: out btn clicked
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                              thisBall.runScoredOnThisBall=0;
                              thisBall.runKey=K_OUT;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isOut=true;
                              });
                              // runUpdater.updateRun(
                              //     thisBall: thisBall);
                            },
                            child: Text("Out")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: over throw
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                              thisBall.runKey=K_OUT;
                              thisBall.isNormalRun=false;
                              runUpdater.updateRun(
                                  thisBall: thisBall);
                            },
                            child: Text("Over Throw")),


                        // spaceBtwn,
                        // FlatButton(
                        //     color: btnColor,
                        //     minWidth: buttonWidth,
                        //     //TODO: start new over
                        //     onPressed: () {
                        //       // newOverPlayersSelectionDialog();
                        //       // updateRuns(playerName: playersName, runs: 0);
                        //     },
                        //     child: Text("Start new over")),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  whenToDisplayWhatAtBottom({Ball ballData}) {

    if (globalCurrentBowler == null) { //TODO: add batsmen condition please
      return selectPlayersBtn();
    } else {

      if(isWideBall){
        return WideBallOptions(
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setWideToFalse: (){
            setState(() {
              isWideBall=false;
            });
          },
        );
      }
      if(isLegBye){
        return LegByeOptions(
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setLegByeToFalse: (){
            setState(() {
              isLegBye=false;
            });
          },
        );
      }
      if(isBye){
        return ByeOptions(
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setByeToFalse: (){
            setState(() {
              isBye=false;
            });
          },
        );
      }
      if(isOut){
        return OutOptions(
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setOutToFalse: (){
            setState(() {
              isOut=false;
            });
          },
        );
      }
      if(isNoBall){
        return NoBallOptions(
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setNoBallToFalse: (){
            setState(() {
              isNoBall=false;
            });
          },
        );
      }

      return scoreSelectionWidget();
    }
  }

  selectPlayersBtn() {
    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: (70*SizeConfig.one_W).roundToDouble()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              minWidth: double.infinity,
              color: Colors.blueGrey.shade400,
              child: Text("Select Batsmen"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SelectAndCreateBatsmenPage(
                    match: widget.match,
                    user: widget.user,
                  );
                }));
              }),
          FlatButton(
            minWidth: double.infinity,
            color: Colors.blueGrey.shade400,
            child: Text("Select Bowler"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBowlerPage(
                  match: widget.match,
                  user: widget.user,
                );
              }));
            },
          ),
        ],
      ),
    );
  }


  ///TODO: might change its position
  tossLineWidget() {
    return Container(
        padding: EdgeInsets.only(left: (12*SizeConfig.one_W).roundToDouble(), top: (12*SizeConfig.one_H).roundToDouble()),
        child: Text(
            "${widget.match.getTossWinner()} won the TOSS and choose to ${widget.match.getChoosedOption().toUpperCase()} (Inning: ${widget.match.getInningNo()}) "));
  }

  ///updateDataInScoreBoard when Over is finished
  updateDataInScoreBoard() {
    if (widget.match.getInningNo() == 1) {
      usersRef
          .doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update(
              {"ballOfTheOver": 0, "currentOverNo": FieldValue.increment(1)});
    }

    if (widget.match.getInningNo() == 2) {
      usersRef
          .doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update(
              {"ballOfTheOver": 0, "currentOverNo": FieldValue.increment(1)});
    }
  }

  Widget miniScoreLoadingScreen(){
    return Expanded(
      child: Container(
        child: Center(
          child: Text(
            "Loading.."
          ),
        ),
      ),
    );
  }

}

///
