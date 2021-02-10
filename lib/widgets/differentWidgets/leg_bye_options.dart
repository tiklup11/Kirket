import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class LegByeOptions extends StatefulWidget {

  LegByeOptions({this.ball,this.matchId,this.userUID,this.setLegByeToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setLegByeToFalse;

  @override
  _LegByeOptionsState createState() => _LegByeOptionsState();
}

class _LegByeOptionsState extends State<LegByeOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.one_H).roundToDouble();
  RunUpdater runUpdater;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runUpdater = RunUpdater(matchId: widget.matchId,userUID: widget.userUID );
  }

  @override
  Widget build(BuildContext context) {
    return wideBallOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  wideBallOptions() {
    final double buttonWidth = (60*SizeConfig.one_W).roundToDouble();
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.one_W).roundToDouble(),
    );

    return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        height: scoreSelectionAreaLength.toDouble(),
        color: Colors.blueGrey.shade400,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.one_W).roundToDouble(), vertical: (6*SizeConfig.one_H).roundToDouble()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///row one [0,1,2,3,4]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            // updateRuns(playerName: "RAJU", runs: 0);
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("1LB")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            // updateRuns(playerName: playersName, runs: 1);
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("2LB")),


                    ],
                  ),

                  ///row 2 [6,Wide,LB,Out,NB]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("3LB")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("4LB")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("5LB")),
                    ],
                  ),

                  ///row 3 [over throw, overEnd,]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          //TODO: over throw
                          onPressed: () {
                            // updateRuns(playerName: playersName, runs: 0);
                          },
                          child: Text("Over Throw")),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed:(){
                  ///set isWide to false
                  widget.setLegByeToFalse();
                } )
          ],
        )
    );
  }
}
