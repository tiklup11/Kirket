import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

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

    return Container(
        padding: EdgeInsets.symmetric(vertical: (20*SizeConfig.oneH).roundToDouble()),
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


  ///this is the wideCustom btn
  customOutButton({int runScored,String btnText,String toShowOnUI}){
    return FlatButton(
        color: btnColor,
        minWidth: buttonWidth,
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateOut(thisBallData: widget.ball);
          // widget.setIsWideToFalse();
        },
        child: Text(btnText));
  }
}
