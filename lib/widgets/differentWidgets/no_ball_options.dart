import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class NoBallOptions extends StatefulWidget {

  NoBallOptions({
    this.setUpdatingDataToFalse,this.setUpdatingDataToTrue,
    this.ball,this.matchId,this.userUID,this.setNoBallToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setNoBallToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _NoBallOptionsState createState() => _NoBallOptionsState();
}

class _NoBallOptionsState extends State<NoBallOptions> {

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
                  customNoBallButton(runScored: 1,btnText: "NB+0",toShowOnUI: "NB+0"),
                  spaceBtwn,
                  customNoBallButton(runScored: 2,btnText: "NB+1",toShowOnUI: "NB+1"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customNoBallButton(runScored: 3,btnText: "NB+2",toShowOnUI: "NB+2"),
                  spaceBtwn,
                  customNoBallButton(runScored: 4,btnText: "NB+3",toShowOnUI: "NB+3"),
                  spaceBtwn,
                  customNoBallButton(runScored: 5,btnText: "NB+4",toShowOnUI: "NB+4"),
                ],
              ),

              ///row 3 [over throw, overEnd,]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customNoBallButton(runScored: 6,btnText: "NB+5",toShowOnUI: "NB+5"),
                  spaceBtwn,
                  customNoBallButton(runScored: 7,btnText: "NB+6",toShowOnUI: "NB+6"),
                ],
              ),
            ],
          ),
        ),
        IconButton(
            icon: Icon(Icons.close),
            onPressed:(){
              ///set isWide to false
              widget.setNoBallToFalse();
            } )
      ],
    );
  }

  customNoBallButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateNoBallRuns(ballData: widget.ball);
        },
        btnText: btnText);
  }
}
