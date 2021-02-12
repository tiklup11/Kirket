import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/ciruclarprogress_dialog.dart';

class WideBallOptions extends StatefulWidget {

  WideBallOptions({this.ball,this.matchId,this.userUID,this.setWideToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setWideToFalse;

  @override
  _WideBallOptionsState createState() => _WideBallOptionsState();
}

class _WideBallOptionsState extends State<WideBallOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;

  displayProgressDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return ProgressDialog(
            // areWeAddingBatsmen: true,
            // match: widget.match,
            // user: widget.user,
          );
        });
  }

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

                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("Wide+0")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () async{
                            displayProgressDialog();
                            widget.ball.runScoredOnThisBall=1;
                            await runUpdater.updateRun(thisBallData: widget.ball);
                            Navigator.pop(context);
                          },
                          child: Text("Wide+1")),


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
                          child: Text("Wide+2")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("Wide+3")),
                      spaceBtwn,
                      FlatButton(
                          color: btnColor,
                          minWidth: buttonWidth,
                          onPressed: () {
                            runUpdater.updateRun(thisBallData: widget.ball);
                          },
                          child: Text("Wide+4")),
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
                  widget.setWideToFalse();
                } )
          ],
        )
    );
  }
}
