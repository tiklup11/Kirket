import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsHome_forAudience.dart';

///mqd
class LiveMatchCard extends StatelessWidget {
  LiveMatchCard({this.match,this.creatorUID,this.matchUID});

  final CricketMatch match;
  String creatorUID;
  String matchUID;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (4*SizeConfig.oneH).roundToDouble(),
          left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble()),
      height:match.getIsMatchStarted()?
      (190*SizeConfig.oneH).roundToDouble():
      (120*SizeConfig.oneH).roundToDouble()
      ,
      child: Card(
        child: MaterialButton(
          onPressed: () {
            if(match.getIsMatchStarted()){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MatchDetailsHomeForAudience(match: match,creatorUID: creatorUID,matchUID: matchUID,);
              }));
            }else{
              showAlertDialog(context: context);
            }
          },
          child: Column(
            children: [
              match.getIsMatchStarted()?
              liveScore():Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/team1.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                        Text(match.getTeam1Name())
                      ],
                    ),
                    Text(
                      "V/S",
                      style: TextStyle(
                        fontSize: (25*SizeConfig.oneW).roundToDouble(),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/team2.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                        Text(
                          match.getTeam2Name(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              match.getFinalResult()==null?
                  Container():Container(child: Text(match.getFinalResult()),),
              match.isSecondInningEnd?
                  Container(child: Center(child: Text("Match End"),),):Container()
            ],
          ),
        ),
      ),
    );
  }

  liveScore(){

    final String runsFormat =
        "${match.totalRuns} / ${match.wicketDown} (${match.currentOver.getCurrentOverNo()-1}.${match.currentOver.getCurrentBallNo()})";
    double CRR = 0.0;
    try {
      // CRR = totalRuns / (currentOverNo + currentBallNo / 6);
      CRR = match.totalRuns / ((match.currentOver.getCurrentOverNo()-1)+(match.currentOver.getCurrentBallNo()/ 6));
    } catch (e) {
      CRR = 0.0;
    }
    return Column(
      children: [
        // tossLineWidget(),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: (10 * SizeConfig.oneW).roundToDouble(),
              vertical: (10 * SizeConfig.oneH).roundToDouble()),
          margin: EdgeInsets.symmetric(
              horizontal: (10 * SizeConfig.oneW).roundToDouble(),
              vertical: (10 * SizeConfig.oneH).roundToDouble()),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                (4 * SizeConfig.oneW).roundToDouble()),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match
                            .getCurrentBattingTeam()
                            .toUpperCase(),
                        style: TextStyle(
                            fontSize:
                            (24 * SizeConfig.oneW).roundToDouble()),
                      ),
                      Text(
                        // runs/wickets (currentOverNumber.currentBallNo)
                        // "65/3  (13.2)",
                        runsFormat,
                        style: TextStyle(
                            fontSize:
                            (16 * SizeConfig.oneW).roundToDouble()),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("CRR"),
                      CRR.isNaN
                          ? Text("0.0")
                          : Text(CRR.toStringAsFixed(2)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  showAlertDialog({BuildContext context}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Okays"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("Rukho zara sabar kro"),
      title: Image.network('https://media1.tenor.com/images/39acc7baa2eabe357fbb48ed33741d15/tenor.gif?itemid=16657275',
      ),
      content: Text("Match not yet started."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
