import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/modals/CricketMatch.dart';

class ScoreBoardData {
  ScoreBoardData(
      {this.totalWicketsDown,
      this.totalRuns,
      this.totalRunsOfInning1,
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
        totalRunsOfInning1: doc.data()['totalRunsOfInning1'],
        totalWicketsDown: doc.data()['wicketsDown']);
  }

  CricketMatch matchData;

  String battingTeamName;
  String bowlingTeam;
  int totalRuns;
  int totalRunsOfInning1;
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

  //this will be called at inning 2
  //so, totalRuns will be = totalRunsOfInning2
  //and same will be case with totalWicketsDown
  String getFinalResult() {
    String resultLine;

    if (totalRunsOfInning1 != null &&
        totalRuns != null &&
        matchData.getInningNo() == 2) {
      if (totalRunsOfInning1 > totalRuns) {
        resultLine =
            "${matchData.getFirstBattingTeam().toUpperCase()} won by ${totalRunsOfInning1 - totalRuns} runs";
        print(resultLine);
        return resultLine;
      }
      if (totalRunsOfInning1 < totalRuns) {
        resultLine =
            "${matchData.getSecondBattingTeam().toUpperCase()} won by ${matchData.getPlayerCount() - 1 - totalWicketsDown} wickets";
        print(resultLine);
        return resultLine;
      }
    }
    return null;
  }
}
