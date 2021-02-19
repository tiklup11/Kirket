class ScoreBoardData {

  ScoreBoardData({this.totalWicketsDown,this.totalRuns,this.currentOverNo,this.battingTeamName,
    this.currentBallNo,this.bowlingTeam,this.inningNo,this.team1name,this.team2name});

  String battingTeamName;
  String bowlingTeam;
  int inningNo;
  int totalRuns;
  int totalWicketsDown;
  int currentOverNo;
  int currentBallNo;
  String team1name;
  String team2name;

  String getCrr(){
    double crr;
    try {
      crr= totalRuns / (currentOverNo + currentBallNo / 6);
    } catch (e) {
      crr = 0.0;
    }
    if(crr.isNaN){
      crr=0.0;
    }
    return crr.toStringAsFixed(2);
  }

  String getFormatedRunsString(){
    String runsFormat =
        "$totalRuns/$totalWicketsDown ($currentOverNo.$currentBallNo)";
    return runsFormat;
  }


}