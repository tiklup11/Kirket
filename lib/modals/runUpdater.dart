import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/modals/Ball.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class RunUpdater {
  RunUpdater({this.matchId, this.userUID});

  final String matchId;
  final String userUID;

  void updateRun(
      {Ball thisBall}) {
    ///doing 2 things here 1. updatingBallNo and Runs
    if (thisBall.isNormalRun) {

      _updateRunsInParticularOver(overNo: thisBall.currentOverNo,inningNo: thisBall.inningNo,
          runsScored: thisBall.runScoredOnThisBall,ballNo: thisBall.currentBallNo);

      _updateScoreBoardData(inningNo: thisBall.inningNo,overNo: thisBall.currentOverNo);

      _updateDataInGeneral(runsScored: thisBall.runScoredOnThisBall);

      _updateBatsmenData(
          inningNo: thisBall.inningNo, batsmenName: thisBall.batsmenName, runsScored: thisBall.runScoredOnThisBall);

      _updateBowlerData(inningNo: thisBall.inningNo,bowlersName: thisBall.bowlerName,runsScored: thisBall.runScoredOnThisBall);

      _updateTotalRuns(inningNo: thisBall.inningNo,runsScored: thisBall.runScoredOnThisBall);

    }
  }

  _updateBatsmenData({String batsmenName, int runsScored, int inningNo}) {
    ///updating players score and bowler stats
    if (inningNo == 1) {
      if (runsScored == 4) {
        userRef
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
        userRef
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
        userRef
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
        userRef
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
        userRef
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
        userRef
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

  _updateBowlerData({String bowlersName, int runsScored, int inningNo}) {
    if (inningNo == 1) {
      userRef
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
      userRef
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

  _updateTotalRuns({int inningNo,int runsScored}){

    if(inningNo==1){
      userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData").update({
        "totalRuns": FieldValue.increment(runsScored)
      });
    }
    if(inningNo==2){
      userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData").update({
        "totalRuns": FieldValue.increment(runsScored)
      });
    }

  }

  _updateDataInGeneral({int runsScored}){
    userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .update({"currentBallNo": FieldValue.increment(1)});

    userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .update({"totalRuns": FieldValue.increment(runsScored)});
  }

  _updateScoreBoardData({int inningNo,int overNo,}){
    if (inningNo == 1) {
      ///updating in SCOREBOARD_DATA
      userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update({"ballOfTheOver": FieldValue.increment(1)});

      userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection("inning1overs")
          .doc("over$overNo")
          .update({"currentBall": FieldValue.increment(1)});
    } else {
      ///updating in SCOREBOARD_DATA
      userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update({"ballOfTheOver": FieldValue.increment(1)});

      userRef
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

  _updateRunsInParticularOver({int inningNo,int runsScored, int ballNo,int overNo}){

    userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('inning${inningNo}overs')
        .doc("over$overNo")
        .update({
      "fullOverData.${ballNo + 1}":runsScored
    });


  }
}
