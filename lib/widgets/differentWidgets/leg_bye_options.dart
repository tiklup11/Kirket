import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class LegByeOptions extends StatefulWidget {

  LegByeOptions({
    this.setUpdatingDataToFalse,this.setUpdatingDataToTrue,
    this.ball,this.matchId,this.userUID,this.setLegByeToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setLegByeToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _LegByeOptionsState createState() => _LegByeOptionsState();
}

class _LegByeOptionsState extends State<LegByeOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runUpdater = RunUpdater(matchId: widget.matchId,userUID: widget.userUID,context: context,setIsUploadingDataToFalse: widget.setUpdatingDataToFalse);
  }

  @override
  Widget build(BuildContext context) {
    return wideBallOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  wideBallOptions() {

    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.oneW).roundToDouble(),
    );

    return ListView(
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
                  customLegByeButton(runScored: 1,btnText: "1LB",toShowOnUI: "1LB"),
                  spaceBtwn,
                  customLegByeButton(runScored: 2,btnText: "2LB",toShowOnUI: "2LB"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customLegByeButton(runScored: 3,btnText: "3LB",toShowOnUI: "3LB"),
                  spaceBtwn,
                  customLegByeButton(runScored: 4,btnText: "4LB",toShowOnUI: "4LB"),
                  spaceBtwn,
                  customLegByeButton(runScored: 5,btnText: "5LB",toShowOnUI: "5LB"),
                ],
              ),
              ///row 3 [over throw, overEnd,]
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     FlatButton(
              //         color: btnColor,
              //         minWidth: buttonWidth,
              //         //TODO: over throw
              //         onPressed: () {
              //           // updateRuns(playerName: playersName, runs: 0);
              //         },
              //         child: Text("Over Throw")),
              //   ],
              // ),
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
    );
  }
  customLegByeButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateLegByeAndBye(ballData: widget.ball);
        },
btnText: btnText);
  }
}
