import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class ByeOptions extends StatefulWidget {

  ByeOptions({this.ball,this.matchId,this.userUID,this.setByeToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setByeToFalse;

  @override
  _ByeOptionsState createState() => _ByeOptionsState();
}

class _ByeOptionsState extends State<ByeOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runUpdater = RunUpdater(matchId: widget.matchId,userUID: widget.userUID,context: context);
  }

  @override
  Widget build(BuildContext context) {
    return wideBallOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  wideBallOptions() {
    final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.oneW).roundToDouble(),
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
              padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (6*SizeConfig.oneH).roundToDouble()),
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
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("1B")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            // updateRuns(playerName: playersName, runs: 1);
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("2B")),


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
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("3B")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("4B")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("5B")),
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
                  widget.setByeToFalse();
                } )
          ],
        )
    );
  }
}
