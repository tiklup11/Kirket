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
      margin: EdgeInsets.only(top: (6*SizeConfig.one_H).roundToDouble(), left: (10*SizeConfig.one_W).roundToDouble(),
          right: (10*SizeConfig.one_W).roundToDouble()),
      height: (145*SizeConfig.one_H).roundToDouble(),
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: (14*SizeConfig.one_W).roundToDouble()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/team1.png',
                        scale: (17*SizeConfig.one_W).roundToDouble(),
                      ),
                      Text(widget.match.getTeam1Name())
                    ],
                  ),
                  Text(
                    "V/S",
                    style: TextStyle(
                      fontSize: (25*SizeConfig.one_W).roundToDouble(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/team2.png',
                        scale: (17*SizeConfig.one_W).roundToDouble(),
                      ),
                      Text(
                        widget.match.getTeam2Name(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.one_W).roundToDouble()),
              child: MaterialButton(
                elevation: 0,
                highlightElevation: 0,
                color: Colors.black12,
                minWidth: double.infinity,
                child:
                widget.match.getIsMatchStarted()?
                    Text("Continue.."):
                Text("Start Match"),
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
}
