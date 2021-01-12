import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:umiperer/modals/Match.dart';
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
  Color selectedColor = Colors.blue;

  final double outerRadius = 40;
  final double innerRadius = 32;

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
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("$tossWinner won toss"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
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
                        backgroundImage: NetworkImage('https://image.freepik.com/free-vector/mysterious-esport-logo-design_149374-148.jpg'),
                      ),
                    ),
                    Text(widget.match.getTeam1Name())
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
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
                        backgroundImage: NetworkImage('https://image.freepik.com/free-vector/mysterious-esport-logo-design_149374-148.jpg'),
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
          borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Column(
        // crossAxisAlignment: ,
        children: [
          Text("and selected to $batOrBall"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: (){
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
              GestureDetector(
                onTap: (){
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
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: MaterialButton(
        height: 40,
        elevation: 0,
        highlightElevation: 0,
        color: Colors.black12,
        minWidth: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Continue"),
            Icon(Icons.arrow_forward)
          ],
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

      // buildPlayersName();
      Navigator.pop(context);
      //TODO: navigate to counterPage
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return MatchDetails(match: widget.match,user: widget.user,);
      }));

    }

  }

}
