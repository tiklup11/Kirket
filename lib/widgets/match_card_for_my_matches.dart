import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
import 'package:umiperer/screens/toss_page.dart';
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

  bool isSwitched= true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only( left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble(),),
      padding: EdgeInsets.only(top: (16*SizeConfig.oneH).roundToDouble()),
      height: (170*SizeConfig.oneH).roundToDouble(),
      child: Card(
        elevation: 40,
        // semanticContainer: false,
        // borderOnForeground: true,
        child: Column(
          children: [
            //TEAM A vs TEAM B
            topRow(),
            // live - on/off - continue
            Container(
              padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble()),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //TODO: on this Live switch
                  // Text("LIVE"),
                  //       FlutterSwitch(
                  //         borderRadius: 10,
                  //         showOnOff: true,
                  //         activeColor: Colors.blueGrey,
                  //         value: isSwitched,
                  //         onToggle: (val) {
                  //           setState(() {
                  //             isSwitched = val;
                  //           });
                  //         },
                  //       ),
                  GestureDetector(
                    onTap: () {
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
                    child: Container(
                      height: (35*SizeConfig.oneH).roundToDouble(),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade400,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      width: (200*SizeConfig.oneW).roundToDouble(),
                      padding: EdgeInsets.symmetric(horizontal: (20*SizeConfig.oneW).roundToDouble()),
                      // elevation: 0,
                      // highlightElevation: 0,
                      // color: Colors.blueGrey.shade400,
                      // minWidth: double.infinity,
                      child:
                      btnLogic(),
                    ),
                  ),
                ],
              ),
            )
          ],
        )
    )
    );
  }

  topRow(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        // borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.only(bottom: (8*SizeConfig.oneW).roundToDouble()),
      padding: EdgeInsets.symmetric(horizontal: (14*SizeConfig.oneW).roundToDouble(),vertical:( 14*SizeConfig.oneH).roundToDouble()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // textBaseline: TextBaseline.values,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/team1.png',
                    scale: (17*SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Text(widget.match.getTeam1Name().toUpperCase(),maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            ),
          ),
          Text(
            "VS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (25*SizeConfig.oneW).roundToDouble(),
            ),
          ),
          Expanded(
            child: Column(
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
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///this is button text logic
  ///1. start match -> before toss and just after match created
  ///2. continue -> anytime in between
  ///3. finish see score -> after match end
  btnLogic(){
    if(widget.match.isSecondInningEnd){
      return Center(child: Text("Ended - View Score"));
    }
    if(widget.match.getIsMatchStarted()){
      return Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Text("Continue"),
          Icon(Icons.arrow_forward,size: (16*SizeConfig.oneW).roundToDouble(),)
        ],
      );
    }else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Start Match"),
          Icon(Icons.arrow_forward,size: (16*SizeConfig.oneW).roundToDouble(),)
        ],
      );
    }
  }
}
