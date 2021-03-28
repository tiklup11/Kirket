import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/widgets/next_over_button.dart';
import 'package:umiperer/widgets/score_button_widget.dart';
import 'package:umiperer/widgets/score_counting_widgets/loading_progress_widget.dart';
import 'package:umiperer/widgets/score_counting_widgets/select_players_btn.dart';
import 'package:umiperer/widgets/differentWidgets/bye_options.dart';
import 'package:umiperer/widgets/differentWidgets/leg_bye_options.dart';
import 'package:umiperer/widgets/differentWidgets/no_ball_options.dart';
import 'package:umiperer/widgets/differentWidgets/out_options.dart';
import 'package:umiperer/widgets/differentWidgets/over_throw_options.dart';
import 'package:umiperer/widgets/differentWidgets/runout_options.dart';
import 'package:umiperer/widgets/differentWidgets/wide_ball_options.dart';

class ScoreSelectionWidget extends StatefulWidget {
  ScoreSelectionWidget({this.ballData, this.user});
  final Ball ballData;
  final User user;

  @override
  _ScoreSelectionWidgetState createState() => _ScoreSelectionWidgetState();
}

class _ScoreSelectionWidgetState extends State<ScoreSelectionWidget> {
  RunUpdater runUpdater;

  bool isWideBall = false;
  bool isLegBye = false;
  bool isBye = false;
  bool isOut = false;
  bool isNoBall = false;
  bool isOverThrow = false;
  bool isRunOut = false;

  bool isUploadingData = false;

  final scoreSelectionAreaLength = (220 * SizeConfig.oneH).roundToDouble();

  @override
  void initState() {
    super.initState();
    runUpdater = new RunUpdater(
        setIsUploadingDataToFalse: setIsUploadingDataToFalse,
        context: context,
        matchId: widget.ballData.scoreBoardData.matchData.getMatchId());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: whenToDisplayWhatAtBottom(ballData: widget.ballData),
    );
  }

  void setIsUploadingDataToTrue() {
    setState(() {
      isUploadingData = true;
    });
  }

  setIsWideToFalse() {
    setState(() {
      isWideBall = false;
    });
  }

  updateIsBowling({String bowlerName, bool setTo}) {
    DatabaseController.getBowlerDocRef(
            bowlerName: bowlerName,
            inningNo: widget.ballData.scoreBoardData.matchData.getInningNo(),
            matchId: widget.ballData.scoreBoardData.matchData.getMatchId())
        .update({
      "isBowling": setTo,
      "ballOfTheOver": 0,
      "overs": FieldValue.increment(1)
    });
  }

  thingsToDoAfterOverIsComplete({String bowlerName}) {
    isBye = false;
    isWideBall = false;
    isLegBye = false;
    isNoBall = false;
    isOut = false;
    isRunOut = false;

    ///ballOfTheOver==0 || displaySelectBowlerBtn ||currentOver++
    // currentBowler = dummyBowler;
    ///updateDataInScoreBoard when Over is finished
    DatabaseController.getScoreBoardDocRef(
      inningNo: widget.ballData.scoreBoardData.matchData.getInningNo(),
      matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
    ).update({
      "currentBowler": null,
      "dummyBallOfTheOver": 0,
      "ballOfTheOver": 0,
      "currentOverNo": FieldValue.increment(1)
    });

    ///update isBowling to false
    updateIsBowling(bowlerName: bowlerName, setTo: false);
  }

  ///this is placed at the bottom, contains many run buttons
  scoreSelectionWidget({@required Ball ballData}) {
    final spaceBtwn = SizedBox(
      width: (4 * SizeConfig.oneW).roundToDouble(),
    );

    if (ballData.scoreBoardData.strikerName == null) {
      return Container(
          child: Center(
              child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("First Select Strike Batsmen 🏏"),
          Text("<By Re-clicking on Batsmen Name>"),
          SizedBox(
            height: SizeConfig.setHeight(50),
            width: SizeConfig.setWidth(180),
            child: SelectPlayerButton(
              btnText: "Select new batsmen",
              match: widget.ballData.scoreBoardData.matchData,
            ),
          )
        ],
      )));
    }

    ballData.outBatsmenName = ballData.scoreBoardData.strikerName;

    if (ballData.scoreBoardData.currentBallNo == 6 &&
        ballData.scoreBoardData.currentOverNo !=
            widget.ballData.scoreBoardData.matchData.getOverCount()) {
      return NextOverButton(
        bowlerName: ballData.scoreBoardData.bowlerName,
        onPressed: (bowlerName) {
          thingsToDoAfterOverIsComplete(bowlerName: bowlerName);
        },
      );
    }

    return ListView(
      children: [
        ///row one [0,1,2,3,4]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreButton(
              btnText: "0",
              onPressed: () {
                ballData.runScoredOnThisBall = 0;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = "0";
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "1",
              onPressed: () {
                ballData.runScoredOnThisBall = 1;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = "1";
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "2",
              onPressed: () {
                ballData.runScoredOnThisBall = 2;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = "2";
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "3",
              onPressed: () {
                ballData.runScoredOnThisBall = 3;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = '3';
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "4",
              onPressed: () {
                ballData.runScoredOnThisBall = 4;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = "4";
                // loadingGifPath = loadingFourGifs[0];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            )
          ],
        ),

        ///row 2 [6,Wide,LB,Bye,NB]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreButton(
              btnText: "6",
              onPressed: () {
                ballData.runScoredOnThisBall = 6;
                ballData.isNormalRun = true;
                ballData.runToShowOnUI = "6";
                // loadingGifPath = loadingSixGifs[getRandomIntBelow(2)];
                setIsUploadingDataToTrue();
                runUpdater.updateNormalRuns(ballData: ballData);
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "Wide",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                setState(() {
                  isWideBall = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "Bye",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                ballData.runKey = K_BYE;
                ballData.isNormalRun = false;
                setState(() {
                  isBye = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "LB",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                ballData.runKey = K_LEGBYE;
                ballData.isNormalRun = false;
                setState(() {
                  isLegBye = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "NB",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                ballData.runKey = K_NOBALL;
                ballData.isNormalRun = false;
                setState(() {
                  isNoBall = true;
                });
              },
            ),
          ],
        ),

        ///row 3 [over throw, o,]
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScoreButton(
              btnText: "Out",
              onPressed: () {
                // loadingGifPath = loadingWicketGifs[0];
                ballData.runKey = K_OUT;
                ballData.isNormalRun = false;
                setState(() {
                  isOut = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "Ov.Throw",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                ballData.runKey = K_OVERTHROW;
                ballData.isNormalRun = false;
                setState(() {
                  isOverThrow = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "RunOut",
              onPressed: () {
                // loadingGifPath = loadingGifPaths[getRandomIntBelow(2)];
                ballData.runKey = K_RUNOUT;
                ballData.isNormalRun = false;
                setState(() {
                  isRunOut = true;
                });
              },
            ),
            spaceBtwn,
            ScoreButton(
              btnText: "EndInn",
              onPressed: () {
                // loadingGifPath = loadingWinGifs[0];
                inningEndFunction(ballData: ballData);
              },
            ),
          ],
        ),

        ///select batsmen and select bowler
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectPlayerButton(
              currentOverNo: widget.ballData.scoreBoardData.currentOverNo,
              btnText: "Select Batsmen",
              match: widget.ballData.scoreBoardData.matchData,
            ),
            spaceBtwn,
            SelectPlayerButton(
              currentOverNo: widget.ballData.scoreBoardData.currentOverNo,
              btnText: "Select Bowler",
              match: widget.ballData.scoreBoardData.matchData,
            ),
            // spaceBtwn,
            // ScoreButton(
            //   btnText: "UNDO",
            //   onPressed: (){
            //
            //   },
            // )
          ],
        )
      ],
    );
  }

  inningEndFunction({Ball ballData}) {
    final inningNo = ballData.scoreBoardData.matchData.getInningNo();
    final matchId = ballData.scoreBoardData.matchData.getMatchId();

    ///things to change after inning ends
    print("cbn :: ${ballData.scoreBoardData.currentBallNo}");

    //TODO: make last batsmen immortal as in NOTOUT

    print(ballData.scoreBoardData.bowlerName == null);
    print(ballData.scoreBoardData.strikerName == null);
    print(ballData.scoreBoardData.nonStrikerName == null);

    DatabaseController.getScoreBoardDocRef(inningNo: 2, matchId: matchId)
        .update({"totalRunsOfInning1": ballData.scoreBoardData.totalRuns});

    if (ballData.scoreBoardData.strikerName != null) {
      DatabaseController.getBatsmenDocRef(
              batsmenName: ballData.scoreBoardData.strikerName,
              inningNo: inningNo,
              matchId: matchId)
          .update({
        "isOut": true,
        "isOnStrike": false,
        "isBatting": false,
      });
    }

    if (ballData.scoreBoardData.nonStrikerName != null) {
      DatabaseController.getBatsmenDocRef(
              batsmenName: ballData.scoreBoardData.nonStrikerName,
              inningNo: inningNo,
              matchId: matchId)
          .update({
        "isOut": true,
        "isOnStrike": false,
        "isBatting": false,
      });
    }

    DatabaseController.getBowlerDocRef(
            bowlerName: ballData.scoreBoardData.bowlerName,
            inningNo: inningNo,
            matchId: matchId)
        .update({"isBowling": false});

    ///this will convert 1.6 to 2.0, that's it.
    if (ballData.scoreBoardData.currentBallNo == 1) {
      DatabaseController.getBowlerDocRef(
              bowlerName: ballData.scoreBoardData.bowlerName,
              inningNo: inningNo,
              matchId: matchId)
          .update({
        "ballOfTheOver": 0,
        "overs": FieldValue.increment(1),
      });
    }

    DatabaseController.getScoreBoardDocRef(inningNo: inningNo, matchId: matchId)
        .update({
      "currentBowler": null,
      "strikerBatsmen": null,
      "nonStrikerBatsmen": null
    });

    ///when 1st inning will end
    if (widget.ballData.scoreBoardData.matchData.getInningNo() == 1) {
      DatabaseController.getGeneralMatchDoc(matchId: matchId).update({
        "isFirstInningEnd": true,
        "inningNumber": 2,
      });
    }

    if (widget.ballData.scoreBoardData.matchData.getInningNo() == 2) {
      DatabaseController.getGeneralMatchDoc(matchId: matchId)
          .update({"isSecondInningEnd": true, "isLive": false});

      if (ballData.scoreBoardData.currentOverNo == 1) {
        DatabaseController.getScoreBoardDocRef(inningNo: 2, matchId: matchId)
            .update(
                {"ballOfTheOver": 0, "currentOverNo": FieldValue.increment(1)});
      }
      // return;
    }
    ballData.scoreBoardData.bowlerName = null;
    widget.ballData.scoreBoardData.strikerName = null;
    widget.ballData.scoreBoardData.nonStrikerName = null;
  }

  ///set of things..logic to display them is below
  whenToDisplayWhatAtBottom({Ball ballData}) {
    // ThisBall thisBall = Provider.of<ThisBall>(context,listen: false);

    if (widget.ballData.scoreBoardData.matchData.isSecondInningEnd) {
      return finalResult();
    }

    if (widget.ballData.scoreBoardData.matchData.isFirstInningEnd &&
        !widget.ballData.scoreBoardData.matchData.isSecondInningStartedYet) {
      return startNewInningBtn(
          btnText: "Start 2nd Inning",
          whatToUpdateFunction: start2ndInningFunction);
    }

    if (!widget.ballData.scoreBoardData.matchData.isFirstInningStartedYet) {
      return startNewInningBtn(
          btnText: "Start 1st Inning",
          whatToUpdateFunction: updateInningOnOffAfter1stInningStarted);
    }

    if (isUploadingData) {
      return LoadingProgressWidget();
    }

    if (ballData.scoreBoardData.strikerName == null &&
        ballData.scoreBoardData.nonStrikerName == null) {
      return selectBatsmenButton();
    }

    if (ballData.scoreBoardData.strikerName == null) {
      return Center(
        child: Text("Select Striker : Tap on batsmens name"),
      );
    }

    if (ballData.scoreBoardData.bowlerName == null) {
      return selectBowlerBtn();
    } else {
      if (isWideBall) {
        ballData.runKey = K_WIDEBALL;
        ballData.isNormalRun = false;

        return WideBallOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setWideToFalse: () {
            setState(() {
              isWideBall = false;
            });
          },
        );
      }

      if (isRunOut) {
        ballData.runKey = K_RUNOUT;
        ballData.isNormalRun = false;
        return RunOutOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          match: widget.ballData.scoreBoardData.matchData,
          striker: ballData.scoreBoardData.strikerName,
          nonStriker: ballData.scoreBoardData.nonStrikerName,
          setRunOutToFalse: () {
            setState(() {
              isRunOut = false;
            });
          },
        );
      }

      if (isLegBye) {
        ballData.runKey = K_LEGBYE;
        ballData.isNormalRun = false;

        return LegByeOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setLegByeToFalse: () {
            setState(() {
              isLegBye = false;
            });
          },
        );
      }
      if (isBye) {
        ballData.runKey = K_BYE;
        ballData.isNormalRun = false;

        return ByeOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setByeToFalse: () {
            setState(() {
              isBye = false;
            });
          },
        );
      }
      if (isOut) {
        ballData.runKey = K_OUT;
        ballData.isNormalRun = false;

        return OutOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setOutToFalse: () {
            setState(() {
              isOut = false;
            });
          },
        );
      }
      if (isNoBall) {
        ballData.runKey = K_NOBALL;
        ballData.isNormalRun = false;

        return NoBallOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setNoBallToFalse: () {
            setState(() {
              isNoBall = false;
            });
          },
        );
      }
      if (isOverThrow) {
        ballData.runKey = K_OVERTHROW;
        ballData.isNormalRun = false;
        return OverThrowOptions(
          setUpdatingDataToFalse: setIsUploadingDataToFalse,
          setUpdatingDataToTrue: setIsUploadingDataToTrue,
          ball: ballData,
          userUID: widget.user.uid,
          matchId: widget.ballData.scoreBoardData.matchData.getMatchId(),
          setOverThrowToFalse: () {
            setState(() {
              isOverThrow = false;
            });
          },
        );
      }
      return scoreSelectionWidget(ballData: ballData);
    }
  }

  ///function after 1st inning end
  start2ndInningFunction() {
    DatabaseController.getGeneralMatchDoc(
            matchId: widget.ballData.scoreBoardData.matchData.getMatchId())
        .update({"isSecondStartedYet": true});
    widget.ballData.scoreBoardData.matchData.setInningNo(2);
  }

  ///final match result
  finalResult() {
    TextStyle textStyle = TextStyle(
      fontSize: 16,
    );

    String resultLine = widget.ballData.scoreBoardData.getFinalResult();

    //TODO: MatchTied function when runs EQUAL

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/gifs/winn.gif",
          height: (100 * SizeConfig.oneH).roundToDouble(),
          width: (100 * SizeConfig.oneW).roundToDouble(),
        ),
        // Image.asset(gifPaths[0],width: 100,height: 100,),
        resultLine != null
            ? Text(
                resultLine,
                style: textStyle,
              )
            : Text(""),
        startNewInningBtn(
            btnText: "Go Home",
            whatToUpdateFunction: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  ///will be shown before 1st inning and 2nd inning
  startNewInningBtn({
    String btnText,
    Function whatToUpdateFunction,
  }) {
    TextStyle textStyle =
        TextStyle(fontSize: (16 * SizeConfig.oneW).roundToDouble());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        btnText == "Start 2nd Inning"
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1st Inning Ended",
                    style: textStyle,
                  ),
                  // TODO: Text("Target - ${widget.match.totalRunsOf1stInning + 1}",
                  //     style: textStyle),
                ],
              )
            : Container(),
        SizedBox(
          height: 4,
        ),
        Bounce(
          onPressed: whatToUpdateFunction,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12, width: 2)),
            child: Text(btnText),
          ),
        ),
      ],
    );
  }

  updateInningOnOffAfter1stInningStarted() {
    DatabaseController.getGeneralMatchDoc(
            matchId: widget.ballData.scoreBoardData.matchData.getMatchId())
        .update({
      "isFirstInningStarted": true,
    });
  }

  selectBatsmenButton() {
    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.blueAccent.shade100,
      padding: EdgeInsets.symmetric(
          vertical: 50, horizontal: (70 * SizeConfig.oneW).roundToDouble()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectPlayerButton(
            currentOverNo: widget.ballData.scoreBoardData.currentOverNo,
            btnText: "Select Batsmen",
            match: widget.ballData.scoreBoardData.matchData,
          ),
        ],
      ),
    );
  }

  selectBowlerBtn() {
    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.blueAccent.shade100,
      padding: EdgeInsets.symmetric(
          vertical: 50, horizontal: (70 * SizeConfig.oneW).roundToDouble()),
      child: SelectPlayerButton(
        currentOverNo: widget.ballData.scoreBoardData.currentOverNo,
        btnText: "Select Bowler",
        match: widget.ballData.scoreBoardData.matchData,
      ),
    );
  }

  void setIsUploadingDataToFalse() {
    setState(() {
      isUploadingData = false;
      isWideBall = false;
      isNoBall = false;
      isLegBye = false;
      isBye = false;
      isNoBall = false;
      isOut = false;
      isOverThrow = false;
    });
  }
}
