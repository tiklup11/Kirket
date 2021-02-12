import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class OverThrowOptions extends StatefulWidget {

  OverThrowOptions({this.ball,this.matchId,this.userUID,this.setOverThrowToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setOverThrowToFalse;

  @override
  _OverThrowOptionsState createState() => _OverThrowOptionsState();
}

class _OverThrowOptionsState extends State<OverThrowOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runUpdater = RunUpdater(matchId: widget.matchId,userUID: widget.userUID,context: context );
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
                          child: Text("+1 OverThrow")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            // updateRuns(playerName: playersName, runs: 1);
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("+2 OverThrow")),


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
                          child: Text("+3 OverThrow")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("+4 OverThrow")),

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
                          child: Text("+6 OverThrow")),

                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("+5 OverThrow")),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed:(){
                  ///set isWide to false
                  widget.setOverThrowToFalse();
                } )
          ],
        )
    );
  }
}
