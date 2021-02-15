import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:umiperer/widgets/differentWidgets/over_throw_options.dart';
import 'package:umiperer/widgets/differentWidgets/runout_options.dart';
import 'package:umiperer/widgets/differentWidgets/wide_ball_options.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';

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
  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
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
  /// gif url in map
  Map<String,String> gifPathMap = {
    'wonUrl':"assets/gifs/tenor_10.gif",
    'sixUrl':"assets/gifs/tenor_8.gif",
    'fourUrl':"",
  };

  // Image wonImage = Image.network("https://media1.tenor.com/images/d24f5c8aea51cd131083e7ecc52cf357/tenor.gif?itemid=18918106",height: 100,width: 100,);

  ///TODO: remove gifs from assets
  List<String> gifPaths = [
    'assets/gifs/tenor_2.gif',
    'assets/gifs/tenor_3.gif',
    'assets/gifs/tenor_4.gif',
    'assets/gifs/tenor_5.gif',
    'assets/gifs/tenor_6.gif',
    'assets/gifs/tenor_7.gif',
    'assets/gifs/tenor_9.gif',
  ];
  ///
  bool isWideBall =false;
  bool isLegBye =false;
  bool isBye = false;
  bool isOut = false;
  bool isNoBall = false;
  bool isOverThrow = false;
  bool isRunOut = false;
  ///
  void setIsUploadingDataToFalse(){
    setState(() {
      isUploadingData =false;
    });
  }

  void setIsUploadingDataToTrue(){
    setState(() {
      isUploadingData =true;
    });
  }

  String gifPath;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    print("Init State called");

    // wonImage=Image.network(gifUrlMap["wonUrl"],height: 100,width: 100,);
    // Random random = new Random();
    // int randomNumber = random.nextInt(4);
    // gifPath = gifPaths[randomNumber];

    _scrollController = ScrollController(keepScrollOffset: true);
    dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
    runUpdater = RunUpdater(
        userUID: widget.user.uid, matchId: widget.match.getMatchId(),context: context,
    setIsUploadingDataToFalse: setIsUploadingDataToFalse
    );
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
            globalOnStrikeBatsmen = matchData['strikerBatsmen'];

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
            final isFirstInningStarted = matchData['isFirstInningStarted'];
            final isFirstInningEnd = matchData['isFirstInningEnd'];
            final isSecondStartedYet = matchData['isSecondStartedYet'];
            final isSecondInningEnd = matchData['isSecondInningEnd'];
            final totalRunsOfInning1 = matchData['totalRunsOfInning1'];
            final totalRunsOfInning2 = matchData['totalRunsOfInning2'];
            final totalWicketsOfInning1= matchData['totalWicketsOfInning1'];
            final totalWicketsOfInning2=matchData['totalWicketsOfInning1'];
            final nonStriker = matchData['nonStrikerBatsmen'];
            final striker = matchData['strikerBatsmen'];


            widget.match.nonStrikerBatsmen = nonStriker;
            widget.match.strikerBatsmen = striker;

            widget.match.isSecondInningEnd=isSecondInningEnd;
            widget.match.isSecondInningStartedYet=isSecondStartedYet;
            widget.match.isFirstInningEnd = isFirstInningEnd;
            widget.match.isFirstInningStartedYet = isFirstInningStarted;

            widget.match.totalRunsOf1stInning = totalRunsOfInning1;
            widget.match.totalRunsOf2ndInning = totalRunsOfInning2;
            widget.match.totalWicketsOf1stInning=totalWicketsOfInning1;
            widget.match.totalWicketsOf2ndInning=totalWicketsOfInning2;

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
              // widget.match.setInningNo(2);
            }

            if(globalCurrentBowler!=null && currentOverNumber!=null){
              //set bowlerName in overDoc
              settingBowlerNameInOverDoc(bowlerName: globalCurrentBowler,overNo: currentOverNumber);
            }

            print("____________________________________________________________");

            return Container(
              color: Colors.black12,
              child: Column(
                children: [
                  miniScoreCard(),
                  buildOversList(),
                  textWidget(),
                  // currentOverNo == 0
                  //     ? startOverBtns():
                  Container(
                    color:Colors.blueGrey.shade400,
                    height: scoreSelectionAreaLength,
                    width: double.infinity,
                    child: whenToDisplayWhatAtBottom(
                      ballData: Ball(
                      inningNo: widget.match.getInningNo(),
                      batsmenName: globalOnStrikeBatsmen,
                      currentBallNo: currentBallNo,
                      currentOverNo: currentOverNumber,
                      bowlerName: globalCurrentBowler,
                    ),),
                  )
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

        "totalRunsOfInning1":totalRuns,
        "totalWicketsOfInning1":totalWickets,
        "isFirstInningEnd":true,
        "battingTeam": widget.match.secondBattingTeam,
        "currentBattingTeam": widget.match.secondBattingTeam,
        "currentOverNumber": 1,
        "nonStrikerBatsmen": null,
        "strikerBatsmen": null,
        "totalRuns": 0,
        "wicketsDown": 0,
      });
      return;
    }

    if(widget.match.getInningNo()==2){
      await usersRef
          .doc(widget.user.uid)
          .collection('createdMatches')
          .doc(widget.match.getMatchId())
          .update({
        "totalRunsOfInning2":totalRuns,
        "totalWicketsOfInning1":totalWickets,
        "isSecondInningEnd":true,
      });
      return;
    }

  }

  Widget textWidget() {
    return Container(
      margin: EdgeInsets.only(top: (3*SizeConfig.oneH).roundToDouble(), bottom: (6*SizeConfig.oneH).roundToDouble()),
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
              CRR = totalRuns / (currentOverNo+currentBallNo/6);
            } catch (e) {
              CRR = 0.0;
            }
            return Column(
              children: [
                tossLineWidget(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (10*SizeConfig.oneH).roundToDouble()),
                  margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (10*SizeConfig.oneH).roundToDouble()),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular((4*SizeConfig.oneW).roundToDouble()),
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
                                style: TextStyle(fontSize: (24*SizeConfig.oneW).roundToDouble()),
                              ),
                              Text(
                                // runs/wickets (currentOverNumber.currentBallNo)
                                // "65/3  (13.2)",
                                runsFormat,
                                style: TextStyle(fontSize: (16*SizeConfig.oneW).roundToDouble()),
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
                        margin: EdgeInsets.symmetric(vertical: (6*SizeConfig.oneH).roundToDouble()),
                        color: Colors.black12,
                        height: (2*SizeConfig.oneW).roundToDouble(),
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
                  sR: "SR",
                  noOf6s: "6s",
                  noOf4s: "4s",
                  balls: "B"),
            ),
          ),
          SizedBox(
            height: (4*SizeConfig.oneH).roundToDouble(),
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

                      if(SR.isNaN){
                        SR=0.0;
                      }

                      currentBothBatsmen.add(Batsmen(
                          isClickable: true,
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
                          height: (4*SizeConfig.oneH).roundToDouble(),
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
            margin: EdgeInsets.symmetric(vertical: (6*SizeConfig.oneH).roundToDouble()),
            color: Colors.black12,
            height: (2*SizeConfig.oneH).roundToDouble(),
          ),
          SizedBox(
            height: (4*SizeConfig.oneH).roundToDouble(),
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
            height: (4*SizeConfig.oneH).roundToDouble(),
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

                    int eco = 0;
                    try {
                      eco = (runs / overs) * 100;
                    } catch (e) {
                      eco = 0;
                    }

                    if(eco.isNaN){eco=0;}

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
            vertical: (6*SizeConfig.oneH).roundToDouble(),
            horizontal: (6*SizeConfig.oneW).roundToDouble()),
        padding: EdgeInsets.symmetric(
            vertical: (8*SizeConfig.oneH).roundToDouble(),
            horizontal: (4*SizeConfig.oneW).roundToDouble()),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((5*SizeConfig.oneW).roundToDouble()),
            color: overNoOnCard == currentOver ? Colors.white : Colors.white60),
        height: (60*SizeConfig.oneH).roundToDouble(),
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

                    final overLength = overData['overLength'];

                    List<Widget> balls = [];

                    for(int i=0;i<overLength;i++){
                      balls.add(BallWidget());
                    }

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
                        runToShowOnUI: runsScored,
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
    final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.oneW).roundToDouble(),
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
                padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (6*SizeConfig.oneH).roundToDouble()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              thisBall.runToShowOnUI="0";
                              gifPath=gifPaths[3];
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall);
                            },
                            child: Text("0")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=1;
                              thisBall.isNormalRun=true;
                              thisBall.runToShowOnUI="1";
                              gifPath=gifPaths[0];
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall,
                              );
                            },
                            child: Text("1")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=2;
                              thisBall.isNormalRun=true;
                              thisBall.runToShowOnUI="2";
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall);
                            },
                            child: Text("2")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=3;
                              thisBall.isNormalRun=true;
                              thisBall.runToShowOnUI='3';
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall);
                            },
                            child: Text("3")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              thisBall.runScoredOnThisBall=4;
                              thisBall.isNormalRun=true;
                              thisBall.runToShowOnUI="4";
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall);
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
                              thisBall.runToShowOnUI="6";
                              gifPath=gifPaths[7];
                              setIsUploadingDataToTrue();
                              runUpdater.updateRun(
                                  thisBallData: thisBall);
                            },
                            child: Text("6")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            onPressed: () {
                              setState(() {
                                isWideBall=true;
                              });
                            },
                            child: Text("Wide")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: out btn clicked
                            onPressed: () {
                              thisBall.runKey=K_BYE;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isBye=true;
                              });
                            },
                            child: Text("Bye")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: legBye runs need to updated [open new run set]
                            onPressed: () {
                              thisBall.runKey=K_LEGBYE;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isLegBye=true;
                              });
                            },
                            child: Text("LB")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: no-ball -- open new no-ball set
                            onPressed: () {
                              thisBall.runKey=K_NOBALL;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isNoBall=true;
                              });
                            },
                            child: Text("NB")),

                      ],
                    ),
                    ///row 3 [over throw, o,]
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: out btn clicked
                            onPressed: () {
                              thisBall.runKey=K_OUT;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isOut=true;
                              });
                            },
                            child: Text("Out")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: over throw
                            onPressed: () {
                              thisBall.runKey=K_OVERTHROW;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isOverThrow=true;
                              });
                            },
                            child: Text("Over Throw")),
                        spaceBtwn,
                        FlatButton(
                            color: btnColor,
                            minWidth: buttonWidth,
                            //TODO: over throw
                            onPressed: () {
                              thisBall.runKey=K_RUNOUT;
                              thisBall.isNormalRun=false;
                              setState(() {
                                isRunOut=true;
                              });
                            },
                            child: Text("Run Out")),
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  bool isUploadingData = false;

  setIsWideToFalse(){
    setState(() {
      isWideBall=false;
    });
  }
  ///bye & legBye & out & noBall, these things have their own
  ///
  updateInningOnOffAfter1stInningStarted() async{
    await usersRef.doc(widget.user.uid).collection('createdMatches').doc(widget.match.getMatchId()).update({
      "isFirstInningStarted":true,
    });
  }

  ///function after 1st inning end
  updateInningOnOffAfter1stInningEnd() async{
    await usersRef.doc(widget.user.uid).collection('createdMatches').doc(widget.match.getMatchId()).update({
      "isSecondStartedYet":true,
      "inningNumber": 2,
    });
    widget.match.setInningNo(2);
  }

  ///set of things..logic to display them is below
  whenToDisplayWhatAtBottom({Ball ballData}) {

    if(widget.match.isSecondInningEnd){
      return finalResult();
    }

    if(widget.match.isFirstInningEnd && !widget.match.isSecondInningStartedYet){
      return startNewInningBtn(
          btnText: "Start 2nd Inning",whatToUpdateFunction: updateInningOnOffAfter1stInningEnd);
    }

    if(!widget.match.isFirstInningStartedYet){
      return startNewInningBtn(
          btnText: "Start 1st Inning",whatToUpdateFunction: updateInningOnOffAfter1stInningStarted);
    }

    if(isUploadingData){
      return loadingGif();
    }

    if (globalCurrentBowler == null || widget.match.strikerBatsmen==null) { //TODO: add batsmen condition please
      return selectPlayersBtn();
    } else {

      if(isWideBall){
        ballData.runKey=K_WIDEBALL;
        ballData.isNormalRun=false;

        return WideBallOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
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

      if(isRunOut){
        ballData.runKey=K_RUNOUT;
        ballData.isNormalRun=false;
        return RunOutOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          match: widget.match,
          setRunOutToFalse: (){
            setState(() {
              isRunOut=false;
            });
          },
        );
      }

      if(isLegBye){

        ballData.runKey=K_LEGBYE;
        ballData.isNormalRun=false;

        return LegByeOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
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

        ballData.runKey=K_BYE;
        ballData.isNormalRun=false;

        return ByeOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
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

        ballData.runKey=K_OUT;
        ballData.isNormalRun=false;

        return OutOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
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

        ballData.runKey=K_NOBALL;
        ballData.isNormalRun=false;

        return NoBallOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
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
      if(isOverThrow){
        ballData.runKey=K_OVERTHROW;
        ballData.isNormalRun=false;
        return OverThrowOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.match.getMatchId(),
          setOverThrowToFalse: (){
            setState(() {
              isOverThrow=false;
            });
          },
        );
      }

      return scoreSelectionWidget();
    }
  }

  ///will be shown before 1st inning and 2nd inning
  startNewInningBtn({String btnText,Function whatToUpdateFunction,}){

    TextStyle textStyle = TextStyle(fontSize: 16);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnText=="Start 2nd Inning"?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("1st Inning Ended",style: textStyle,),
            Text("Target - ${widget.match.totalRunsOf1stInning+1}",style: textStyle),
          ],
        ):Container(),
        FlatButton(
            minWidth: double.infinity,
            color: Colors.black12,
            child: Text(btnText),
            onPressed: whatToUpdateFunction
        ),
      ],
    );
  }

  ///SelectBatsmen and bowler btn
  selectPlayersBtn() {
    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.blueGrey.shade400,
      padding: EdgeInsets.symmetric(horizontal: (70*SizeConfig.oneW).roundToDouble()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              minWidth: double.infinity,
              color: Colors.black12,
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
            color: Colors.black12,
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
        padding: EdgeInsets.only(left: (12*SizeConfig.oneW).roundToDouble(), top: (12*SizeConfig.oneH).roundToDouble()),
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

  ///final match result
  finalResult(){

    String resultLine;
    TextStyle textStyle = new TextStyle(fontSize: 16,);

    if(widget.match.totalRunsOf1stInning>widget.match.totalRunsOf2ndInning){
      resultLine = "${widget.match.firstBattingTeam.toUpperCase()} won by ${widget.match.totalRunsOf1stInning-widget.match.totalRunsOf2ndInning} runs";
    }
    if(widget.match.totalRunsOf1stInning<widget.match.totalRunsOf2ndInning){
      resultLine = "${widget.match.secondBattingTeam.toUpperCase()} won by ${widget.match.getPlayerCount()-1-widget.match.totalWicketsOf2ndInning} wickets";
    }
    //TODO: MatchTied function when runs EQUAL

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(gifPathMap["wonUrl"],height: 100,width: 100,),
        // Image.asset(gifPaths[0],width: 100,height: 100,),
        Text(resultLine,style: textStyle,),
        startNewInningBtn(btnText: "End Game",whatToUpdateFunction: (){Navigator.pop(context);})
      ],
    );
  }
  ///
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

  ///when async tasks are performed, this loadingGif
  ///is shown in bottom to restrict users from performing
  ///further action
  Widget loadingGif() {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              gifPath,
            height: 190,width: 190,
          ),
          Text("Updating Data..",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}

///
