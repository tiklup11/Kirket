import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
//where actual counting happens
class TossScreen extends StatefulWidget {

  TossScreen({this.match,this.user});

  final CricketMatch match;
  final User user;
  @override
  _TossScreenState createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> {

  String tossWinner = "who";
  String batOrBall = "";
  Color unSelectedColor = Colors.black12;
  Color selectedColor = Colors.blueGrey.shade400;

  final double outerRadius = (40*SizeConfig.oneW).roundToDouble();
  final double innerRadius = (26*SizeConfig.oneW).roundToDouble();

  bool isTeam1Selected=false;
  bool isTeam2Selected=false;

  bool isBattingSelected = false;
  bool isBowlingSelected = false;


  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${widget.match.getTeam1Name()} vs ${widget.match.getTeam2Name()}"),
        ),
        body: Container(
          child: Column(
            children: [
              //Who won toss widget
              whoWonTossWidget(),
              //and choose
              andChooseToWidget(),

              continueButton(),
            ],
          ),
        ));
  }




  whoWonTossWidget(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
        borderRadius: BorderRadius.circular((10*SizeConfig.oneW).roundToDouble())
      ),
      margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(),vertical: (10*SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble(),vertical: (20*SizeConfig.oneH).roundToDouble()),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("$tossWinner won toss"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BouncingWidget(
                onPressed: (){
                  setState(() {
                    isTeam1Selected=!isTeam1Selected;
                    isTeam2Selected=false;
                    if(isTeam1Selected){
                      tossWinner = widget.match.getTeam1Name();
                    } else{
                      tossWinner = "who";
                    }
                  });
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: isTeam1Selected? selectedColor:unSelectedColor,
                      radius: outerRadius,
                      child: CircleAvatar(
                        radius: innerRadius,
                        child: Image.asset(
                          'assets/images/team1.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                      ),
                    ),
                    Text(widget.match.getTeam1Name())
                  ],
                ),
              ),
              BouncingWidget(
                onPressed: (){
                  setState(() {
                    isTeam2Selected=!isTeam2Selected;
                    isTeam1Selected=false;
                    if(isTeam2Selected){
                      tossWinner = widget.match.getTeam2Name();
                    } else{
                      tossWinner = "who";
                    }
                  });
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: isTeam2Selected? selectedColor:unSelectedColor,
                      radius: outerRadius,
                      child: CircleAvatar(
                        radius: innerRadius,
                        child: Image.asset(
                          'assets/images/team2.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                      ),
                    ),
                    Text(widget.match.getTeam2Name())
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  andChooseToWidget(){
    return Container(
      decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular((10*SizeConfig.oneW).roundToDouble())
      ),
      margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(),vertical: (10*SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble(),vertical: (20*SizeConfig.oneH).roundToDouble()),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("and selected to $batOrBall"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BouncingWidget(
                onPressed: (){
                  setState(() {
                    isBattingSelected=!isBattingSelected;
                    isBowlingSelected=false;
                    if(isBattingSelected){
                      batOrBall = "Bat";
                    } else{
                      batOrBall = "";
                    }
                  });
                },
                child: CircleAvatar(
                  backgroundColor: isBattingSelected? selectedColor:unSelectedColor,
                  radius: outerRadius,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: innerRadius,
                    backgroundImage: AssetImage('assets/images/bat.png'),
                  ),
                ),
              ),
              BouncingWidget(
                onPressed: (){
                  setState(() {
                    isBowlingSelected=!isBowlingSelected;
                    isBattingSelected=false;
                    if(isBowlingSelected)
                    {
                      batOrBall = "Bowl";
                    } else{
                      batOrBall = "";
                    }
                  });
                },
                child: CircleAvatar(
                  backgroundColor: isBowlingSelected? selectedColor:unSelectedColor,
                  radius: outerRadius,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: innerRadius,
                    backgroundImage: AssetImage('assets/images/ball.png'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  continueButton(){
    return Container(
      margin: EdgeInsets.only(top: (10*SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble()),
      child: BouncingWidget(
        // elevation: 0,
        // highlightElevation: 0,
        // minWidth: double.infinity,
        child: Container(
          color: Colors.black12,
          width: double.infinity,
          height: (40*SizeConfig.oneH).roundToDouble(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Continue"),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
        onPressed: (){
          uploadTossDataToCloud();
        },
      ),
    );
  }

  uploadTossDataToCloud(){

    if(tossWinner != "who" && batOrBall != "")
    {
      widget.match.setBatOrBall(batOrBall);
      widget.match.setTossWinner(tossWinner);

      widget.match.setFirstInnings();

      usersRef.doc(widget.user.uid).collection("createdMatches").doc(widget.match.getMatchId()).update({
        "whatChoose": widget.match.getChoosedOption(),
        "tossWinner": widget.match.getTossWinner(),
        "isMatchStarted": true,
        "firstBattingTeam": widget.match.firstBattingTeam,
        "firstBowlingTeam": widget.match.firstBowlingTeam,
        "secondBattingTeam": widget.match.secondBattingTeam,
        "secondBowlingTeam": widget.match.secondBowlingTeam,
        "currentBattingTeam": widget.match.getCurrentBattingTeam(),
      });

      ///matchDoc > FirstInningCollection > scoreBoardDataDoc >
      usersRef.doc(widget.user.uid).collection('createdMatches').doc(widget.match.getMatchId())
          .update({
        "battingTeam": widget.match.firstBattingTeam,
        "totalRuns":0,
        "wicketsDown":0
      });

      // buildPlayersName();
      Navigator.pop(context);
      //TODO: navigate to counterPage
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return MatchDetails(match: widget.match,user: widget.user,);
      }));

    }

  }


}
