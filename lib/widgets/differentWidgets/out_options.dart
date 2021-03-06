import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class OutOptions extends StatefulWidget {

  OutOptions({
    this.setUpdatingDataToTrue,this.setUpdatingDataToFalse,
    this.ball,this.matchId,this.userUID,this.setOutToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setOutToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _OutOptionsState createState() => _OutOptionsState();
}

class _OutOptionsState extends State<OutOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;

  @override
  void initState() {
    super.initState();
    runUpdater = RunUpdater(matchId: widget.matchId,context: context,setIsUploadingDataToFalse: widget.setUpdatingDataToFalse);
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///row one [0,1,2,3,4]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customOutButton(btnText: "Bowled",toShowOnUI: "W",runScored: 0),
                spaceBtwn,
                customOutButton(btnText: "Caught",toShowOnUI: "W",runScored: 0),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customOutButton(btnText: "LBW",toShowOnUI: "W",runScored: 0),
                spaceBtwn,
                customOutButton(btnText: "Stumped",toShowOnUI: "W",runScored: 0),
              ],
            ),
            ///row 2 [6,Wide,LB,Out,NB]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customOutButton(btnText: "Hit Wicket",toShowOnUI: "W",runScored: 0),
                spaceBtwn,
                customOutButton(btnText: "Injured",toShowOnUI: "W",runScored: 0),
              ],
            ),
          ],
        ),
        IconButton(
            icon: Icon(Icons.close),
            onPressed:(){
              ///set isWide to false
              widget.setOutToFalse();
            } )
      ],
    );
  }


  ///this is the wideCustom btn
  customOutButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateWicket(ballData: widget.ball);
          // widget.setIsWideToFalse();
        },
        btnText: btnText);
  }
}
