import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/runUpdater.dart';
import 'package:umiperer/modals/size_config.dart';

class RunOutOptions extends StatefulWidget {

  RunOutOptions({this.ball,this.match,this.userUID,
    this.setRunOutToFalse,this.setUpdatingDataToTrue,this.setUpdatingDataToFalse,this.nonStriker,this.striker
  });

  final Ball ball;
  final CricketMatch match;
  final String userUID;
  final Function setRunOutToFalse;
  final Function setUpdatingDataToTrue;
  final Function setUpdatingDataToFalse;
  final String striker,nonStriker;

  @override
  _RunOutOptionsState createState() => _RunOutOptionsState();
}

class _RunOutOptionsState extends State<RunOutOptions> {

  final scoreSelectionAreaLength = (220*SizeConfig.oneH).roundToDouble();
  RunUpdater runUpdater;
  final double buttonWidth = (60*SizeConfig.oneW).roundToDouble();
  final btnColor = Colors.black12;

  String selectedRunOutBatsmen;
  List<DropdownMenuItem<String>> playersList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("BS ; ${ widget.nonStriker}");
    print("BS ; ${ widget.striker}");

    if(widget.striker!=null){
      widget.ball.strikerName = widget.striker;
      selectedRunOutBatsmen=widget.ball.strikerName;
      playersList.add(DropdownMenuItem(
        child: Text(widget.striker),
        value: widget.striker,
      ),);
    }
    if(widget.nonStriker!=null){
      widget.ball.nonStrikerName = widget.nonStriker;
      playersList.add(DropdownMenuItem(
        child: Text(widget.nonStriker),
        value: widget.nonStriker,
      ),);
    }
    runUpdater = RunUpdater(
      matchId: widget.match.getMatchId(),userUID: widget.userUID,
      context: context,setIsUploadingDataToFalse: widget.setUpdatingDataToFalse,
      // setWideToFalse: widget.setWideToFalse
    );
  }

  @override
  Widget build(BuildContext context) {
    return runOutOptions();
  }
  ///this is placed at the bottom, contains many run buttons
  runOutOptions() {
    final spaceBtwn = SizedBox(
      width: (4 * SizeConfig.oneW).roundToDouble(),
    );

    return Container(
        padding: EdgeInsets.symmetric(
            vertical: (30 * SizeConfig.oneH).roundToDouble()),
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
                  Row(
                    children: [
                      Text("Select Batsmen  -  "),
                      dropDownListOfBatsmen(),
                    ],
                  ),

                  ///row one [0,1,2,3,4]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(
                          runScored: 0, btnText: "RunOut+0", toShowOnUI: "W"),
                      spaceBtwn,
                      customButton(
                          runScored: 1, btnText: "RunOut+1", toShowOnUI: "W+1"),
                    ],
                  ),

                  ///row 2 [6,Wide,LB,Out,NB]
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(
                          runScored: 2, btnText: "RunOut+2", toShowOnUI: "W+2"),
                      spaceBtwn,
                      customButton(
                          runScored: 3, btnText: "RunOut+3", toShowOnUI: "W+3"),
                      spaceBtwn,
                      customButton(
                          runScored: 4, btnText: "RunOut+4", toShowOnUI: "W+4"),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  ///set isWide to false
                  widget.setRunOutToFalse();
                })
          ],
        )
    );
  }


  dropDownListOfBatsmen(){
    return DropdownButton(
        value:selectedRunOutBatsmen,
        items:playersList,
        onChanged: (value) {
          setState(() {
            selectedRunOutBatsmen = value;
          });
        });
  }

  ///this is the wideCustom btn
  customButton({int runScored,String btnText,String toShowOnUI}){
    return FlatButton(
        color: btnColor,
        minWidth: buttonWidth,
        onPressed: () {
          widget.ball.strikerName = widget.striker;
          widget.ball.nonStrikerName  =widget.nonStriker;
          widget.setUpdatingDataToTrue();
          widget.ball.runScoredOnThisBall=runScored;
          widget.ball.runToShowOnUI=toShowOnUI;
          widget.ball.batsmenName=selectedRunOutBatsmen;
          runUpdater.updateRunOut(ballData: widget.ball);
          widget.setRunOutToFalse();
        },
        child: Text(btnText));
  }
}
