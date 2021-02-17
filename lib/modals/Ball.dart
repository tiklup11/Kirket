class Ball{
  int runScoredOnThisBall;
  String runToShowOnUI;
  int cardOverNo;
  int currentBallNo;
  int currentOverNo;
  int inningNo;
  bool isNormalRun; //this contains 0,1,2,3,4,6
  String batsmenName;
  String nonStrikerName;
  String strikerName;
  String bowlerName;
  String runKey; //this key will tell whether the ball is NOBALL or LEGBYE or ...etc

  Ball(
      {this.runScoredOnThisBall,
      this.cardOverNo,
      this.currentBallNo,
      this.currentOverNo,
        this.bowlerName,
        this.inningNo,
        this.batsmenName,
        this.runKey,
        this.isNormalRun,
        this.runToShowOnUI,
        this.nonStrikerName,
        this.strikerName
      });
}