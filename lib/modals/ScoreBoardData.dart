import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/modals/CricketMatch.dart';

class ScoreBoardData {
  ScoreBoardData(
      {this.totalWicketsDown,
      this.totalRuns,
      this.currentOverNo,
      this.battingTeamName,
      this.currentBallNo,
      this.bowlingTeam,
      this.dummyBallNo,
      this.matchData,
      this.bowlerName,
      this.nonStrikerName,
      this.strikerName});

  factory ScoreBoardData.from(DocumentSnapshot doc) {
    return ScoreBoardData(
        strikerName: doc.data()['strikerBatsmen'],
        nonStrikerName: doc.data()['nonStrikerBatsmen'],
        dummyBallNo: doc.data()['dummyBallOfTheOver'],
        currentBallNo: doc.data()['ballOfTheOver'],
        currentOverNo: doc.data()['currentOverNo'] + 1,
        bowlerName: doc.data()['currentBowler'],
        battingTeamName: doc.data()['battingTeam'],
        bowlingTeam: doc.data()['bowlingTeam'],
        totalRuns: doc.data()['totalRuns'],
        totalWicketsDown: doc.data()['wicketsDown']);
  }

  CricketMatch matchData;

  String battingTeamName;
  String bowlingTeam;
  int totalRuns;
  int totalWicketsDown;
  int currentOverNo;
  int currentBallNo;
  int dummyBallNo;
  String nonStrikerName;
  String strikerName;
  String bowlerName;

  String getCrr() {
    double crr;
    try {
      crr = totalRuns / (currentOverNo + currentBallNo / 6);
    } catch (e) {
      crr = 0.0;
    }
    if (crr.isNaN) {
      crr = 0.0;
    }
    return crr.toStringAsFixed(2);
  }

  String getFormatedRunsString() {
    String runsFormat =
        "$totalRuns/$totalWicketsDown (${currentOverNo - 1}.$currentBallNo)";
    return runsFormat;
  }
}
