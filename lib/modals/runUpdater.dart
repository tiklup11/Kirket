import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/services/database_updater.dart';

class RunUpdater {
  RunUpdater(
      {this.matchId, @required this.context, this.setIsUploadingDataToFalse});

  final String matchId;
  final BuildContext context;
  final Function setIsUploadingDataToFalse;

  //[1,2,3,4,5,6]
  void updateNormalRuns({@required Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.scoreBoardData.strikerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    print('printing ballData: 1: ${ballData.scoreBoardData.strikerName}'
        '2: ${ballData.scoreBoardData.nonStrikerName}  3: ${ballData.scoreBoardData.bowlerName} 4: Over: ${ballData.scoreBoardData.currentOverNo}');

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalMatchData
      scoreBoardRef.update({
        "dummyBallOfTheOver": FieldValue.increment(1),
        "ballOfTheOver": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      });

      //3. batsmenData
      if (ballData.runScoredOnThisBall == 6) {
        batsmenDocRef.update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
          "noOf6s": FieldValue.increment(1),
        });
      } else if (ballData.runScoredOnThisBall == 4) {
        batsmenDocRef.update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
          "noOf4s": FieldValue.increment(1),
        });
      } else {
        batsmenDocRef.update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        });
      }

      //4.bowlerData
      bowlerDocRef
        ..update({
          "ballOfTheOver": FieldValue.increment(1),
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        });

      //5. particular over data
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
  }

  //bye and legBye
  void updateLegByeAndBye({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.scoreBoardData.strikerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalMatchData

      scoreBoardRef.update({
        "dummyBallOfTheOver": FieldValue.increment(1),
        "ballOfTheOver": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      });

      //3. batsmenData
      batsmenDocRef.update({
        "balls": FieldValue.increment(1),
      });

      //4.bowlerData
      bowlerDocRef.update({
        "ballOfTheOver": FieldValue.increment(1),
      });

      //5. particular over data
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
    return;
  }

  //[NB,wide,overThrow]
  void updateNoBallRuns({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.scoreBoardData.strikerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalMatchData

      scoreBoardRef.update({
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "dummyBallOfTheOver": FieldValue.increment(1)
      });

      //3. batsmenData
      if (ballData.runScoredOnThisBall == 7) {
        batsmenDocRef.update({
          "runs": FieldValue.increment(ballData.runScoredOnThisBall - 1),
          "noOf6s": FieldValue.increment(1),
        });
      } else if (ballData.runScoredOnThisBall == 5) {
        batsmenDocRef.update({
          "runs": FieldValue.increment(ballData.runScoredOnThisBall - 1),
          "noOf4s": FieldValue.increment(1),
        });
      } else {
        batsmenDocRef.update({
          "runs": FieldValue.increment(ballData.runScoredOnThisBall - 1),
        });
      }

      //4.bowlerData
      bowlerDocRef.update({
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "overLength": FieldValue.increment(1)
      });

      //5. particular over data
      overDocRef.update({
        "overLength": FieldValue.increment(1),
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
  }

  void updateWideAndOverThrowRuns({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalMatchData
      scoreBoardRef.update({
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "dummyBallOfTheOver": FieldValue.increment(1)
      });

      //3. batsmenData
      // await matchDocReference.collection(
      //     '${ballData.scoreBoardData.matchData.getInningNo()}InningBattingData')
      //     .doc(ballData.batsmenName)
      //     .update(
      //     {
      //       "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      //     });

      //4.bowlerData
      bowlerDocRef.update({
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "overLength": FieldValue.increment(1)
      });

      //5. particular over data
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "overLength": FieldValue.increment(1),
        "currentBall": FieldValue.increment(1)
      });
    }

    setIsUploadingDataToFalse();
  }

  ///wickets update
  void updateWicket({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.scoreBoardData.strikerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalData

      scoreBoardRef.update({
        "dummyBallOfTheOver": FieldValue.increment(1),
        "ballOfTheOver": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "strikerBatsmen": null,
        "nonStrikerBatsmen": null
      });

      //3. batsmenData
      batsmenDocRef.update({
        "balls": FieldValue.increment(1),
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "isOut": true,
        "isBatting": false,
        "isOnStrike": false,
      });

      //4. BowlerData
      bowlerDocRef.update({
        "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "wickets": FieldValue.increment(1),
      });

      //overData
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
  }

  void updateWidePlusStump({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.scoreBoardData.strikerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final bowlerDocRef = DatabaseController.getBowlerDocRef(
        bowlerName: ballData.scoreBoardData.bowlerName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalData
      scoreBoardRef.update({
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "strikerBatsmen": null,
        "currentBallNo": FieldValue.increment(1),
        "nonStrikerBatsmen": null
      });

      //3. batsmenData
      batsmenDocRef.update({
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "isOut": true,
        "isBatting": false,
        "isOnStrike": false,
      });

      //4. BowlerData
      bowlerDocRef.update({
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        "wickets": FieldValue.increment(1),
      });

      //overData
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "overLength": FieldValue.increment(1),
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
  }

  ///wickets update
  void updateRunOut({Ball ballData}) {
    final scoreBoardRef = DatabaseController.getScoreBoardDocRef(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final batsmenDocRef = DatabaseController.getBatsmenDocRef(
        batsmenName: ballData.outBatsmenName,
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId);

    final overDocRef = DatabaseController.getOverDoc(
        inningNo: ballData.scoreBoardData.matchData.getInningNo(),
        matchId: matchId,
        overNo: ballData.scoreBoardData.currentOverNo);

    if (ballData.scoreBoardData.matchData.getInningNo() != null &&
        ballData.runScoredOnThisBall != null &&
        ballData.outBatsmenName != null &&
        ballData.scoreBoardData.bowlerName != null &&
        ballData.scoreBoardData.currentOverNo != null) {
      //1. generalData

      scoreBoardRef.update({
        "dummyBallOfTheOver": FieldValue.increment(1),
        "ballOfTheOver": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "strikerBatsmen": null,
        "nonStrikerBatsmen": null
      });

      //3. batsmenData
      print("Striker : ${ballData.scoreBoardData.strikerName}");
      print("RunOut  : ${ballData.outBatsmenName}");
      matchesRef
          .doc(matchId)
          .collection(
              '${ballData.scoreBoardData.matchData.getInningNo()}InningBattingData')
          .doc(ballData.scoreBoardData.strikerName)
          .update({
        "balls": FieldValue.increment(1),
        "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      });

      batsmenDocRef.update({
        "isOut": true,
        "isBatting": false,
        "isOnStrike": false,
      });

      //overData
      overDocRef.update({
        "fullOverData.${ballData.scoreBoardData.dummyBallNo + 1}":
            ballData.runToShowOnUI,
        "currentBall": FieldValue.increment(1)
      });
    }
    setIsUploadingDataToFalse();
  }
}
