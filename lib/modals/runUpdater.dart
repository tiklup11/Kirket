import 'package:cloud_firestore/cloud_firestore.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class RunUpdater {
  RunUpdater({this.matchId, this.userUID});

  final String matchId;
  final String userUID;

  void updateRun(
      {bool isNormalRun,
      int overNo,
      int ballNumber,
      int inningNo,
      int runScored,
      String batmenName,
      String bowlerName}) {
    ///doing 2 things here 1. updatingBallNo and Runs
    if (isNormalRun) {
      userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .update({"currentBallNo": FieldValue.increment(1)});

      _updateBatsmenData(
          inningNo: inningNo, batsmenName: batmenName, runsScored: runScored);

      _updateBowlerData(inningNo: inningNo,bowlersName: bowlerName,runsScored: runScored);

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
  }

  _updateBatsmenData({String batsmenName, int runsScored, int inningNo}) {
    ///updating players score and bowler stats
    if (inningNo == 1) {
      if (runsScored == 4) {
        userRef
            .doc(userUID)
            .collection('createdMatches')
            .doc(matchId)
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection('Players')
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
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection('Players')
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
            .collection('FirstInning')
            .doc("BattingTeam")
            .collection('Players')
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
            .collection('SecondInning')
            .doc("BattingTeam")
            .collection('Players')
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
            .collection('SecondInning')
            .doc("BattingTeam")
            .collection('Players')
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
            .collection('SecondInning')
            .doc("BattingTeam")
            .collection('Players')
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
          .collection('FirstInning')
          .doc("BowlingTeam")
          .collection('Players')
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
          .collection('SecondInning')
          .doc("BowlingTeam")
          .collection('Players')
          .doc(bowlersName)
          .update({
        "ballOfTheOver": FieldValue.increment(1),
        "runs": FieldValue.increment(runsScored),
      });
    }
  }
}
