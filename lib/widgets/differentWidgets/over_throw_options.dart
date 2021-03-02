import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class OverThrowOptions extends StatefulWidget {

  OverThrowOptions({
    this.setUpdatingDataToFalse,this.setUpdatingDataToTrue,
    this.ball,this.matchId,this.userUID,this.setOverThrowToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setOverThrowToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _OverThrowOptionsState createState() => _OverThrowOptionsState();
}

class _OverThrowOptionsState extends State<OverThrowOptions> {

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
                  customOverThrowButton(runScored: 1,toShowOnUI: "+1Th",btnText: "+1 OverThrow"),
                  spaceBtwn,
                  customOverThrowButton(runScored: 2,toShowOnUI: "+2Th",btnText: "+2 OverThrow"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customOverThrowButton(runScored: 3,toShowOnUI: "+3Th",btnText: "+3 OverThrow"),
                  spaceBtwn,
                  customOverThrowButton(runScored: 4,toShowOnUI: "+4Th",btnText: "+4 OverThrow"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customOverThrowButton(runScored: 5,toShowOnUI: "+5Th",btnText: "+5 OverThrow"),
                  spaceBtwn,
                  customOverThrowButton(runScored: 6,toShowOnUI: "+6Th",btnText: "+6 OverThrow"),
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
    );
  }

  customOverThrowButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateWideAndOverThrowRuns(ballData: widget.ball);
        },
        btnText: btnText);
  }
}
