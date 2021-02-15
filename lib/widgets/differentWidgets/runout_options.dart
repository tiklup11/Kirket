import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class RunOutOptions extends StatefulWidget {

  RunOutOptions({this.ball,this.match,this.userUID,
    this.setRunOutToFalse,this.setUpdatingDataToTrue,this.setUpdatingDataToFalse,
  });

  final Ball ball;
  final CricketMatch match;
  final String userUID;
  final Function setRunOutToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _RunOutOptionsState createState() => _RunOutOptionsState();
}

enum BothBatsmen { striker, nonStriker }

class _RunOutOptionsState extends State<RunOutOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;

  BothBatsmen runOutBatsmen = BothBatsmen.nonStriker;
  String runOutBatsmenName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    runUpdater = RunUpdater(
      matchId: widget.match.getMatchId(),userUID: widget.userUID,
      context: context,setIsUploadingDataToFalse: widget.setUpdatingDataToFalse,
      // setWideToFalse: widget.setWideToFalse
    );
  }

  @override
  Widget build(BuildContext context) {

    if(BothBatsmen.striker==runOutBatsmen){
      runOutBatsmenName = widget.match.strikerBatsmen;
    }
    if(BothBatsmen.nonStriker==runOutBatsmen){
      runOutBatsmenName = widget.match.nonStrikerBatsmen;
    }

    return runOutOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  runOutOptions() {

    final spaceBtwn = SizedBox(
      width: (4*SizeConfig.oneW).roundToDouble(),
    );

    return Container(
        padding: EdgeInsets.symmetric(vertical: 30),
        height: scoreSelectionAreaLength.toDouble(),
        color: Colors.blueGrey.shade400,

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(), vertical: (6*SizeConfig.oneH).roundToDouble()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///Radio Buttons
                  Text("Select RunOut Batsmen"),
                  radioButtons(),
                  ///row one [0,1,2,3,4]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(runScored: 0,btnText: "RunOut+0",toShowOnUI: "W"),
                      spaceBtwn,
                      customButton(runScored: 1,btnText: "RunOut+1",toShowOnUI: "W"),
                    ],
                  ),
                  ///row 2 [6,Wide,LB,Out,NB]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(runScored: 2,btnText: "RunOut+2",toShowOnUI:"W" ),
                      spaceBtwn,
                      customButton(runScored: 3,btnText: "RunOut+3",toShowOnUI: "W"),
                      spaceBtwn,
                      customButton(runScored: 4,btnText: "RunOut+4",toShowOnUI: "W"),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed:() {
                  ///set isWide to false
                  widget.setRunOutToFalse();
                } )
          ],
        )
    );
  }

  radioButtons(){
    return Row(
      children: [
        widget.match.strikerBatsmen!=null?
        Row(
          children: [
            Radio(
              value: BothBatsmen.nonStriker,
              groupValue: runOutBatsmen,
              onChanged: (BothBatsmen value) {
                setState(() {
                  runOutBatsmen = value;
                });
              },
            ),
            Text(widget.match.strikerBatsmen),
          ],
        ):Container(),
        widget.match.nonStrikerBatsmen!=null?
        Row(
          children: [
            Radio(
              value: BothBatsmen.striker,
              groupValue: runOutBatsmen,
              onChanged: (BothBatsmen value) {
                setState(() {
                  runOutBatsmen = value;
                });
              },
            ),
            Text(widget.match.nonStrikerBatsmen)
          ],
        ):Container(),
      ],
    );
  }

  ///this is the wideCustom btn
  customButton({int runScored,String btnText,String toShowOnUI}){
    return FlatButton(
        color: btnColor,
        minWidth: buttonWidth,
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          widget.ball.batsmenName=runOutBatsmenName;
          runUpdater.updateOut(thisBallData: widget.ball);
          // widget.setIsWideToFalse();
        },
        child: Text(btnText));
  }
}
