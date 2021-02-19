import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/toss_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
///mqd
final usersRef = FirebaseFirestore.instance.collection('users');

class MatchCardForCounting extends StatefulWidget {
  MatchCardForCounting({this.match, this.user});

  final CricketMatch match;
  final User user;

  @override
  _MatchCardForCountingState createState() => _MatchCardForCountingState();
}

class _MatchCardForCountingState extends State<MatchCardForCounting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (6*SizeConfig.oneH).roundToDouble(), left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble()),
      height: (160*SizeConfig.oneH).roundToDouble(),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: (14*SizeConfig.oneW).roundToDouble(),vertical:( 14*SizeConfig.oneH).roundToDouble()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Image.asset(
                          'assets/images/team1.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                      ),
                      Text(widget.match.getTeam1Name().toUpperCase(),maxLines: 2,)
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
                      CircleAvatar(
                        child: Image.asset(
                          'assets/images/team2.png',
                          scale: (17*SizeConfig.oneW).roundToDouble(),
                        ),
                      ),
                      Text(
                        widget.match.getTeam2Name().toUpperCase(),maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble()),
              child: MaterialButton(
                elevation: 0,
                highlightElevation: 0,
                color: Colors.black12,
                minWidth: double.infinity,
                child:
                btnLogic(),
                onPressed: () {
                  if (widget.match.getTossWinner() == null &&
                      widget.match.getChoosedOption() == null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return TossScreen(
                            match: widget.match,
                            user: widget.user,
                          );
                        },
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MatchDetails(
                            match: widget.match,
                            user: widget.user,
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  btnLogic(){

    if(widget.match.isSecondInningEnd){
      return Text("Match Ended - View Score");
    }
    if(widget.match.getIsMatchStarted()){
      return Text("Continue..");
    }else{
      Text("Start Match");
    }
  }
}
