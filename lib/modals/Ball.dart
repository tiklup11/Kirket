import 'package:umiperer/modals/ScoreBoardData.dart';

class Ball {
  
  ScoreBoardData scoreBoardData;
  int runScoredOnThisBall;
  String runToShowOnUI;
  int cardOverNo;
  bool isNormalRun; //this contains 0,1,2,3,4,6
  String outBatsmenName;
  String runKey; //this key will tell whether the ball is NOBALL or LEGBYE or ...etc

  Ball({
    this.scoreBoardData,
    this.runScoredOnThisBall,
    this.cardOverNo,
    this.outBatsmenName,
    this.runKey,
    this.isNormalRun,
    this.runToShowOnUI,
  });
}
