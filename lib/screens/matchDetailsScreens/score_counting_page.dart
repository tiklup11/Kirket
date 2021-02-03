import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/Bowler.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/screens/fill_new_match_details_screen.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_batsmen_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_bowler_page.dart';
import 'package:umiperer/widgets/Bowler_stats_row.dart';
import 'package:umiperer/widgets/ball_widget.dart';
import 'package:umiperer/widgets/batsmen_score_row.dart';

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
  final scoreSelectionAreaLength = 220;
  bool isBatsmen1OnStrike = true;
  String globalOnStrikeBatsmen;

  int inningNumber;
  int currentOverNo;
  int currentBallNo;
  List<Batsmen> currentBothBatsmen;

  Bowler dummyBowlerData = Bowler(
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
    _scrollController = ScrollController(keepScrollOffset: true);
    dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
    runUpdater = RunUpdater(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: dataStreams.getGeneralMatchDataStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            final generalMatchData = snapshot.data.data();
            currentOverNo = generalMatchData['currentOverNumber'];
            currentBallNo = generalMatchData['currentBallNo'];
            inningNumber = generalMatchData["inningNumber"];

            widget.match.setInningNo(inningNumber);

            return Container(
              color: Colors.black12,
              child: Column(
                children: [
                  miniScoreCard(),
                  buildOversList(),
                  textWidget(),
                  // currentOverNo == 0
                  //     ? startOverBtns():
                      scoreSelectionWidget(
                          overNumber: 1,
                          ballNo: 1,
                          inningNo: 1,
                          playersName: "pulkit"),
                ],
              ),
            );
          }
        });
  }

  Widget textWidget() {
    return Container(
      margin: EdgeInsets.only(top: 3, bottom: 6),
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
            return Center(
              child: Text("Loading data..."),
            );
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
              CRR = totalRuns / currentOverNo;
            } catch (e) {
              CRR = 0.0;
            }
            return Column(
              children: [
                tossLineWidget(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
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
                                widget.match.getCurrentBattingTeam(),
                                style: TextStyle(fontSize: 24),
                              ),
                              Text(
                                // runs/wickets (currentOverNumber.currentBallNo)
                                // "65/3  (13.2)",
                                runsFormat,
                                style: TextStyle(fontSize: 16),
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
                        margin: EdgeInsets.symmetric(vertical: 6),
                        color: Colors.black12,
                        height: 2,
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
  void updateStrikerToGeneralMatchData(String playerName){

    usersRef.doc(widget.user.uid).collection('createdMatches')
        .doc(widget.match.getMatchId()).update({
      "strikerBatsmen":playerName
    });
  }

  void updateNonStrikerToGeneralMatchData(String playerName) {
    usersRef.doc(widget.user.uid).collection('createdMatches')
        .doc(widget.match.getMatchId()).update({
      "nonStrikerBatsmen": playerName
    });
  }
  ///    ///    ///

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
            onTap: (){
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
            height: 4,
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
                        batsmen: dummyBatsmen, isOnStrike: false);
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

                      int SR = 0;
                      try {
                        SR = (runs / ballsPlayed) * 100;
                      } catch (e) {
                        SR = 0;
                      }

                      currentBothBatsmen.add( Batsmen(
                          isClickable: true,
                          balls: ballsPlayed.toString(),
                          noOf4s: noOf4s.toString(),
                          noOf6s: noOf6s.toString(),
                          SR: SR.toString(),
                          playerName: playerName,
                          runs: runs.toString(),
                          isOnStrike: isOnStrike));
                    });

                    if(currentBothBatsmen[0]!=null){
                      batsmen1 = currentBothBatsmen[0];
                    }else{
                      batsmen1=dummyBatsmen;
                    }

                    if(currentBothBatsmen[1]!=null){
                      batsmen2 = currentBothBatsmen[1];
                    }else{
                      batsmen2=dummyBatsmen;
                    }

                    if(batsmen1!=dummyBatsmen){
                      if(batsmen1.isOnStrike){
                        globalOnStrikeBatsmen = batsmen1.playerName;
                        updateStrikerToGeneralMatchData(batsmen1.playerName);
                      }else{
                        updateNonStrikerToGeneralMatchData(batsmen1.playerName);
                      }
                    }

                    if(batsmen2!=dummyBatsmen){
                      if(batsmen2.isOnStrike){
                        globalOnStrikeBatsmen = batsmen2.playerName;
                        updateStrikerToGeneralMatchData(batsmen2.playerName);
                      }else{
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
                                batsmen1.isOnStrike=true;
                                batsmen2.isOnStrike=false;
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
                          height: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (!batsmen2.isOnStrike && batsmen2.isClickable) {
                                toogleStrikeOnFirebase(
                                    playerName: batsmen2.playerName,
                                    value: true);
                                batsmen2.isOnStrike=true;
                                batsmen1.isOnStrike=false;
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
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.black12,
            height: 2,
          ),
          SizedBox(
            height: 4,
          ),
          //Bowler's Data
          GestureDetector(
            onTap: (){
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
            height: 4,
          ),
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
                    bowler: dummyBowlerData,
                  );
                } else {
                  final currentBowlerData = snapshot.data.docs;

                  print("LENGTH:BOWL ${currentBowlerData.length}");

                  currentBowler = dummyBowlerData;

                  currentBowlerData.forEach((playerData) {
                    print("ENTERINGGGGGGGGGGG");
                    print("DATA::BOWLER::  ${playerData.data()}");

                    final maidens = playerData.data()['maidens'];
                    final wickets = playerData.data()['wickets'];
                    final overs = playerData.data()['overs'];
                    final playerName = playerData.data()['name'];
                    final runs = playerData.data()['runs'];
                    final isBowling = playerData.data()['isBowling'];

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
                      overs: overs.toString(),
                      wickets: wickets.toString()
                    );
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

  buildOversList() {
    print('WWWWWWWWWWWWWWWWWW::: inning${inningNumber}over');

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

    Ball currentBall = Ball(
        runScoredOnThisBall: 3,
        cardOverNo: overNoOnCard,
        currentOverNumber: currentOver,
        key: 3,
        currentBallNo: currentBallNo);

    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: overNoOnCard == currentOver ? Colors.white : Colors.white60),
      height: 60,
      // color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 8,
              top: 8,
            ),
            child: Text("OVER NO: $overNoOnCard"),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            child: currentOver == 0
                ? Row(children: zeroOverBalls)
                : StreamBuilder<DocumentSnapshot>(
                    stream: dataStreams.getFullOverDataStream(
                        inningNo: inningNumber, overNumber: overNoOnCard),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
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
                        final isThisCurrentOver = overData["isThisCurrentOver"];
                        final currentBallNo = overData['currentBall'];
                        print("CurrentBallNo::::::::::::::$currentBallNo");

                        //decoding the map
                        fullOverData.forEach((key, value) {
                          if (value != null) {
                            balls[int.parse(key) - 1] = BallWidget(
                              currentBall: currentBall,
                            );
                          } else {
                            balls[int.parse(key) - 1] = BallWidget(
                              currentBall: currentBall,
                            );
                          }
                        });
                        return Row(children: balls);
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }

  ///this is placed at the bottom, contains many run buttons
  scoreSelectionWidget(
      {String playersName, int overNumber, int ballNo, int inningNo}) {
    final double buttonWidth = 60;
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(
      width: 4,
    );

    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.white,
      child: StreamBuilder<DocumentSnapshot>(
          stream: dataStreams.getGeneralMatchDataStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final matchData = snapshot.data.data();
              final currentOver = matchData['currentOver'];
              final currentBallNo = matchData['currentBallNo'];
              final strikerBatsmen = matchData['strikerBatsmen'];
              final nonStrikerBatsmen = matchData['nonStrikerBatsmen'];
              final currentBowler = matchData['currentBowler'];
              final inningNo = matchData['inningNumber'];

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                              // updateRuns(playerName: "RAJU", runs: 0);
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 0);
                            },
                            child: Text("0")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 1);
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 1);
                            },
                            child: Text("1")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 2);
                            },
                            child: Text("2")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 3);
                            },
                            child: Text("3")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 4);
                            },
                            child: Text("4")),
                      ],
                    ),

                    ///row 2 [6,Wide,LB,Out,NB]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              runUpdater.updateRun(
                                  inningNo: inningNo,
                                  overNo: currentOver,
                                  ballNumber: currentBallNo,
                                  batmenName: strikerBatsmen,
                                  bowlerName: currentBowler,
                                  isNormalRun: true,
                                  runScored: 6);
                            },
                            child: Text("6")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                            },
                            child: Text("Wide")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: legBye runs need to updated [open new run set]
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                            },
                            child: Text("LB")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: no-ball -- open new no-ball set
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 1);
                            },
                            child: Text("NB")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: out btn clicked
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                            },
                            child: Text("Out")),
                      ],
                    ),

                    ///row 3 [over throw, overEnd,]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: over throw
                            onPressed: () {
                              // updateRuns(playerName: playersName, runs: 0);
                            },
                            child: Text("Over Throw")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: start new over
                            onPressed: () {
                              // newOverPlayersSelectionDialog();
                              // updateRuns(playerName: playersName, runs: 0);
                            },
                            child: Text("Start new over")),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  ///only visible when starting first over to make UI intiative
  startOverBtns() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: scoreSelectionAreaLength.toDouble(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            minWidth: 200,
            highlightElevation: 0,
            elevation: 0,
            color: Colors.blue,
            child: Text("Select Batsmen"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBatsmenPage(
                  match: widget.match,
                  user: widget.user,
                );
              }));
            },
          ),
          MaterialButton(
            minWidth: 200,
            highlightElevation: 0,
            elevation: 0,
            color: Colors.blue,
            child: Text("Select Bowler"),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SelectAndCreateBowlerPage(
                  match: widget.match,
                  user: widget.user,
                );
              }));
            },
          )
        ],
      ),
    );
  }

  ///TODO: might change its position
  tossLineWidget() {
    return Container(
        padding: EdgeInsets.only(left: 12, top: 12),
        child: Text(
            "${widget.match.getTossWinner()} won the toss and choose to ${widget.match.getChoosedOption()}"));
  }
}

///
