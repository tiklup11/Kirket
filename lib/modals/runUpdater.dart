import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/constants.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class RunUpdater {
  RunUpdater({this.matchId, this.userUID, @required this.context,this.setIsUploadingDataToFalse,});

  final String matchId;
  final String userUID;
  final BuildContext context;
  final Function setIsUploadingDataToFalse;
  // final Function setWideToFalse;

  void updateRun({Ball thisBallData,}) async {
    print("Starting progress dialog");
    print("Started progress dialog");

    ///doing 2 things here 1. updatingBallNo and Runs
    if (thisBallData.isNormalRun) {
      await _updateRunsInParticularOver(
        toShowOnUI: thisBallData.runToShowOnUI,
          overNo: thisBallData.currentOverNo,
          inningNo: thisBallData.inningNo,
          runsScored: thisBallData.runScoredOnThisBall,
          ballNo: thisBallData.currentBallNo);

      await _updateScoreBoardData(
          inningNo: thisBallData.inningNo, overNo: thisBallData.currentOverNo);

      await _updateDataInGeneral(runsScored: thisBallData.runScoredOnThisBall);

      await _updateBatsmenData(
          inningNo: thisBallData.inningNo,
          batsmenName: thisBallData.batsmenName,
          runsScored: thisBallData.runScoredOnThisBall);

      await _updateBowlerData(
          inningNo: thisBallData.inningNo,
          bowlersName: thisBallData.bowlerName,
          runsScored: thisBallData.runScoredOnThisBall);

      await _updateTotalRunsInScoreBoard(
          inningNo: thisBallData.inningNo,
          runsScored: thisBallData.runScoredOnThisBall);

      setIsUploadingDataToFalse();
      // Navigator.pop(context);
      print("End progress dialog");
      return;
    }

    ///in case of NoBAll wide etc....
    if (!thisBallData.isNormalRun) {
      if (thisBallData.runKey == K_OUT) {

        //
        setIsUploadingDataToFalse();
        return;
      }

      if (thisBallData.runKey == K_NOBALL) {

        await _wideBallUpdateFunction(
            toShowOnUI: thisBallData.runToShowOnUI,
            runsScored: thisBallData.runScoredOnThisBall,
            inningNo: thisBallData.inningNo,
            ballNo: thisBallData.currentBallNo,
            overNo: thisBallData.currentOverNo,
            thisBallData: thisBallData);

        setIsUploadingDataToFalse();
        return;
      }

      if (thisBallData.runKey == K_LEGBYE) {

        await _legByeUpdateFunction(
            toShowOnUI: thisBallData.runToShowOnUI,
            runsScored: thisBallData.runScoredOnThisBall,
            inningNo: thisBallData.inningNo,
            ballNo: thisBallData.currentBallNo,
            overNo: thisBallData.currentOverNo,
            thisBallData: thisBallData);

        setIsUploadingDataToFalse();
        return;
      }

      if (thisBallData.runKey == K_BYE) {
        await _legByeUpdateFunction(
            toShowOnUI: thisBallData.runToShowOnUI,
            runsScored: thisBallData.runScoredOnThisBall,
            inningNo: thisBallData.inningNo,
            ballNo: thisBallData.currentBallNo,
            overNo: thisBallData.currentOverNo,
            thisBallData: thisBallData);

        setIsUploadingDataToFalse();
        return;
      }

      if (thisBallData.runKey == K_OVERTHROW) {

        await _wideBallUpdateFunction(
            toShowOnUI: thisBallData.runToShowOnUI,
            runsScored: thisBallData.runScoredOnThisBall,
            inningNo: thisBallData.inningNo,
            ballNo: thisBallData.currentBallNo,
            overNo: thisBallData.currentOverNo,
            thisBallData: thisBallData);

        setIsUploadingDataToFalse();
        return;
      }

      if (thisBallData.runKey == K_WIDEBALL) {

        await _wideBallUpdateFunction(
            toShowOnUI: thisBallData.runToShowOnUI,
            runsScored: thisBallData.runScoredOnThisBall,
            inningNo: thisBallData.inningNo,
            ballNo: thisBallData.currentBallNo,
            overNo: thisBallData.currentOverNo,
            thisBallData: thisBallData);

        setIsUploadingDataToFalse();
        // setWideToFalse();
        print("End progress dialog");
        return;
      }
      return;
    }
  }

  _updateBatsmenData({String batsmenName, int runsScored, int inningNo}) async {
    ///updating players score and bowler stats
    if (inningNo == 1) {
      if (runsScored == 4) {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('1InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
          "noOf4s": FieldValue.increment(1),
        });
      } else if (runsScored == 6) {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('1InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
          "noOf6s": FieldValue.increment(1),
        });
      } else {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('1InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
        });
      }
    } else {
      if (runsScored == 4) {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('2InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
          "noOf4s": FieldValue.increment(1),
        });
      } else if (runsScored == 6) {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('2InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
          "noOf6s": FieldValue.increment(1),
        });
      } else {
        await userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('2InningBattingData')
            .doc(batsmenName)
            .update({
          "balls": FieldValue.increment(1),
          "runs": FieldValue.increment(runsScored),
        });
      }
    }
  }

  _updateBowlerData({String bowlersName, int runsScored, int inningNo}) async {
    if (inningNo == 1) {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('1InningBowlingData')
          .doc(bowlersName)
          .update({
        "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(runsScored),
      });
    } else {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('2InningBowlingData')
          .doc(bowlersName)
          .update({
        "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(runsScored),
      });
    }
  }

  _updateTotalRunsInScoreBoard({int inningNo, int runsScored}) async {
    if (inningNo == 1) {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update({"totalRuns": FieldValue.increment(runsScored)});
    }
    if (inningNo == 2) {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update({"totalRuns": FieldValue.increment(runsScored)});
    }
  }

  _updateDataInGeneral({int runsScored}) async {
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .update({"currentBallNo": FieldValue.increment(1)});

    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .update({"totalRuns": FieldValue.increment(runsScored)});
  }

  _updateTotalRunsInGeneralData({int runsScored}) async {
    userRef.doc(userUID).collection('createdMatches').doc(matchId).update({
      "totalRuns": FieldValue.increment(runsScored),
      "currentBallNo": FieldValue.increment(1)
    });
  }

  _updateScoreBoardData({
    int inningNo,
    int overNo,
  }) async {
    if (inningNo == 1) {
      ///updating in SCOREBOARD_DATA
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update({"ballOfTheOver": FieldValue.increment(1)});

      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection("inning1overs")
          .doc("over$overNo")
          .update({"currentBall": FieldValue.increment(1)});
    } else {
      ///updating in SCOREBOARD_DATA
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update({"ballOfTheOver": FieldValue.increment(1)});

      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection("inning2overs")
          .doc("over$overNo")
          .update({
        "currentBall": FieldValue.increment(1),
      });
    }
  }

  _updateRunsInParticularOver(
      {int inningNo, int runsScored, int ballNo, int overNo,String toShowOnUI}) async {
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('inning${inningNo}overs')
        .doc("over$overNo")
        .update({"fullOverData.${ballNo + 1}": toShowOnUI});
  }

  _updateRunsInOverDocForSpecialCases(
      {int inningNo,
      int runsScored,
      int ballNo,
      int overNo,
      String runsOnUI}) async {
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('inning${inningNo}overs')
        .doc("over$overNo")
        .update({
      "fullOverData.${ballNo + 1}": runsOnUI,
      "currentBall": FieldValue.increment(1),
    });
  }

  _updateOverLengthInOverDoc(
      {int inningNo, int runsScored, int ballNo, int overNo}) async {
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('inning${inningNo}overs')
        .doc("over$overNo")
        .update({"overLength": FieldValue.increment(1)});
  }

  _updateBowlerDataForSpecialCase(
      {String bowlersName, int runsScored, int inningNo}) async {
    if (inningNo == 1) {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('1InningBowlingData')
          .doc(bowlersName)
          .update({
        // "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(runsScored),
        "overLength": FieldValue.increment(1),
      });
    } else {
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('2InningBowlingData')
          .doc(bowlersName)
          .update({
        // "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(runsScored),
        "overLength": FieldValue.increment(1),
      });
    }
  }

  _wideBallUpdateFunction(
      {int inningNo, int runsScored, int ballNo, int overNo, String toShowOnUI, Ball thisBallData}) async {
    ///totalRuns++ generalData and scoreBoard
    await _updateTotalRunsInScoreBoard(runsScored: runsScored, inningNo: inningNo);
    await _updateTotalRunsInGeneralData(runsScored: runsScored);

    await _updateBowlerDataForSpecialCase(inningNo: inningNo, runsScored: runsScored, bowlersName: thisBallData.bowlerName);

    ///overLength in overDoc++
    await _updateOverLengthInOverDoc(inningNo: inningNo, overNo: overNo, ballNo: ballNo, runsScored: runsScored);

    ///doc me wideSet krna h MAP me
    await _updateRunsInOverDocForSpecialCases(inningNo: inningNo, overNo: overNo, ballNo: ballNo, runsScored: runsScored, runsOnUI: toShowOnUI);
  }

  ///updating legByeData
  _legByeUpdateFunction({int inningNo, int runsScored, int ballNo, int overNo, String toShowOnUI, Ball thisBallData}) async {
    ///totalRuns++ generalData and scoreBoard
    await _updateRunsInParticularOver(toShowOnUI: toShowOnUI,runsScored: runsScored,inningNo: inningNo,overNo: overNo,ballNo: ballNo);

    await _updateScoreBoardData(
        inningNo: thisBallData.inningNo, overNo: thisBallData.currentOverNo);

    await _updateDataInGeneral(runsScored: thisBallData.runScoredOnThisBall);

    await _updateBatsmenData(
        inningNo: thisBallData.inningNo,
        batsmenName: thisBallData.batsmenName,
        runsScored: 0);

    await _updateBowlerData(
        inningNo: thisBallData.inningNo,
        bowlersName: thisBallData.bowlerName,
        runsScored: thisBallData.runScoredOnThisBall);

    await _updateTotalRunsInScoreBoard(
        inningNo: thisBallData.inningNo,
        runsScored: thisBallData.runScoredOnThisBall);

    print("End progress dialog");
    return;
  }

}
