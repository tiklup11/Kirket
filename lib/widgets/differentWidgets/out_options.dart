import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class OutOptions extends StatefulWidget {

  OutOptions({this.ball,this.matchId,this.userUID,this.setOutToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setOutToFalse;

  @override
  _OutOptionsState createState() => _OutOptionsState();
}

class _OutOptionsState extends State<OutOptions> {

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
                          child: Text("Bowled")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            // updateRuns(playerName: playersName, runs: 1);
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("Caught")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("LBW")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("Run Out")),
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
                          child: Text("Stumped")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("Hit Wicket")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBall: widget.ball);
                          },
                          child: Text("Injured")),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed:(){
                  ///set isWide to false
                  widget.setOutToFalse();
                } )
          ],
        )
    );
  }
}
