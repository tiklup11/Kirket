import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';

class BallWidget extends StatelessWidget {
  BallWidget({this.currentBall});

  final double ballRadius = 18.0;
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
    if(currentBall.currentBallNo==key && currentBall.currentOverNumber==currentBall.cardOverNo){
      isCurrentBall=true;
    }
    print( "and runsScored=${currentBall.runScoredOnThisBall}");
    if(currentBall.currentOverNo==0){
      return Container(
          margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
          radius: 20,
          backgroundColor: isCurrentBall
              ? Colors.black54
              : Colors.blue.shade50,
        ));
  }

  nullBallWidget() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
