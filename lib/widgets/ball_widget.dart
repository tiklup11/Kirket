import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/size_config.dart';

///mqd
class BallWidget extends StatelessWidget {
  BallWidget({this.currentBall});

  final double ballRadius = (20*SizeConfig.one_W).roundToDouble();
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
    if(currentBall.currentBallNo==key && currentBall.currentOverNo==currentBall.cardOverNo){
      isCurrentBall=true;
    }
    print( "and runsScored=${currentBall.runScoredOnThisBall}");
    if(currentBall.currentOverNo==0){
      return Container(
          margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.one_W).roundToDouble(), vertical: (4*SizeConfig.one_H).roundToDouble()),
          child: CircleAvatar(
            child:
            Text(
              "",
              style: TextStyle(color: Colors.black),
            ),
            radius: ballRadius,
            backgroundColor: isCurrentBall
                ? Colors.black54
                : Colors.blue.shade50,
          ));
    }
    return Container(
        margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.one_W).roundToDouble(),
            vertical: (4*SizeConfig.one_H).roundToDouble()),
        child: CircleAvatar(
          child: currentBall.runScoredOnThisBall == null
              ? Text(
            "",
            style: TextStyle(color: Colors.black),
          )
              : Text(
            currentBall.runScoredOnThisBall.toString(),
            style: TextStyle(color: Colors.black),
          ),
          radius: (20*SizeConfig.one_W).roundToDouble(),
          backgroundColor: isCurrentBall
              ? Colors.black54
              : Colors.blue.shade50,
        ));
  }

  nullBallWidget() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: (4*SizeConfig.one_W).roundToDouble(),
            vertical: (4*SizeConfig.one_H).roundToDouble()),
        child: CircleAvatar(
          child: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          radius: ballRadius,
          backgroundColor: Colors.blue.shade50,
        ));
  }
}
