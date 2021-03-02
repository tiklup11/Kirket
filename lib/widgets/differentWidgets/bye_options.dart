import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

class ByeOptions extends StatefulWidget {

  ByeOptions({
    this.setUpdatingDataToTrue,this.setUpdatingDataToFalse,
    this.ball,this.matchId,this.userUID,this.setByeToFalse});

  final Ball ball;
  final String matchId;
  final String userUID;
  final Function setByeToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;

  @override
  _ByeOptionsState createState() => _ByeOptionsState();
}

class _ByeOptionsState extends State<ByeOptions> {

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
                  customByeButton(runScored: 1,btnText: "1B",toShowOnUI: "1B"),
                  spaceBtwn,
                  customByeButton(runScored: 2,btnText: "2B",toShowOnUI: "2B"),
                ],
              ),

              ///row 2 [6,Wide,LB,Out,NB]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customByeButton(runScored: 3,btnText: "3B",toShowOnUI: "3B"),
                  spaceBtwn,
                  customByeButton(runScored: 4,btnText: "4B",toShowOnUI: "4B"),
                  spaceBtwn,
                  customByeButton(runScored: 5,btnText: "5B",toShowOnUI: "5B"),
                ],
              ),

              ///row 3 [over throw, overEnd,]
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customByeButton(runScored: 6,btnText: "6B",toShowOnUI: "6B"),
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
    );
  }

  customByeButton({int runScored,String btnText,String toShowOnUI}){
    return ScoreButton(
        onPressed: () {
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          runUpdater.updateLegByeAndBye(ballData: widget.ball);
        },
        btnText:btnText);
  }
}
