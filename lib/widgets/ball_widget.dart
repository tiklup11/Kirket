import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/size_config.dart';

///mqd
// ignore: must_be_immutable
class BallWidget extends StatelessWidget {
  BallWidget({this.currentBall});

  final double ballRadius = (21 * SizeConfig.oneW).roundToDouble();
  final Ball currentBall;

  int fontSize = 15;

  @override
  Widget build(BuildContext context) {
    decideFontSize();
    return currentBall == null ? nullBallWidget() : ballWidget();
  }

  decideFontSize() {
    try {
      int.parse(currentBall.runToShowOnUI);
    } catch (e) {
      fontSize = 12;
    }
  }

  ///circleBall widget placed inside Over container
  ballWidget() {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: (4 * SizeConfig.oneW).roundToDouble(),
            vertical: (4 * SizeConfig.oneH).roundToDouble()),
        child: CircleAvatar(
          child: currentBall.runToShowOnUI == null
              ? Text(
                  "",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )
              : Text(
                  currentBall.runToShowOnUI,
                  style: TextStyle(
                      color: Colors.black, fontSize: fontSize.toDouble()),
                ),
          radius: ballRadius,
          backgroundColor: currentBall.runToShowOnUI == "W"
              ? Colors.red.shade400
              : Colors.blueAccent.shade100,
        ));
  }

  nullBallWidget() {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: (4 * SizeConfig.oneW).roundToDouble(),
            vertical: (4 * SizeConfig.oneH).roundToDouble()),
        child: CircleAvatar(
          child: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          radius: ballRadius,
          backgroundColor: Colors.blueAccent.shade100.withOpacity(0.5),
        ));
  }
}
