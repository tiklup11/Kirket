import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/size_config.dart';

///mqd
class BallWidget extends StatelessWidget {
  BallWidget({this.currentBall});  //TODO: remove this required it is for special cases

  final double ballRadius = (20*SizeConfig.oneW).roundToDouble();
  final Ball currentBall;

  @override
  Widget build(BuildContext context) {

    return
      currentBall==null?
          nullBallWidget():
      ballWidget();
  }

  ///circleBall widget placed inside Over container
  ballWidget() {
    bool isCurrentBall = false;
    if(currentBall.currentOverNo==currentBall.cardOverNo){
      isCurrentBall=true;
    }
    print( "and runsScored=${currentBall.runScoredOnThisBall}");
    if(currentBall.currentOverNo==0){
      return Container(
          margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.oneW).roundToDouble(), vertical: (4*SizeConfig.oneH).roundToDouble()),
          child: CircleAvatar(
            child:
            Text(
              "z",
              style: TextStyle(color: Colors.black),
            ),
            radius: ballRadius,
            backgroundColor: Colors.blueGrey.shade400,
          ));
    }
    return Container(
        margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.oneW).roundToDouble(),
            vertical: (4*SizeConfig.oneH).roundToDouble()),
        child: CircleAvatar(
          child: currentBall.runToShowOnUI == null
              ? Text(
            "",
            style: TextStyle(color: Colors.black),
          )
              : Text(
            currentBall.runToShowOnUI,
            style: TextStyle(color: Colors.black),
          ),
          radius: (20*SizeConfig.oneW).roundToDouble(),
          backgroundColor
              : Colors.blueGrey.shade400,
        ));
  }

  nullBallWidget() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.oneW).roundToDouble(),
            vertical: (4*SizeConfig.oneH).roundToDouble()),
        child: CircleAvatar(
          child: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          radius: ballRadius,
          backgroundColor: Colors.blue.shade100,
        ));
  }
}
