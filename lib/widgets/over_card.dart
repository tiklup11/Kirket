import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/widgets/ball_widget.dart';

class DummyOverCard extends StatefulWidget {

  DummyOverCard({this.match,
    this.overNoOnCard,
    this.creatorUID,
    @required this.inningNo
  });

  String creatorUID;
  int overNoOnCard;
  CricketMatch match;
  int inningNo;

  @override
  _DummyOverCardState createState() => _DummyOverCardState();
}

class _DummyOverCardState extends State<DummyOverCard> {

///over container with 6balls
///we will increase no of balls in specific cases
///TODO: increase no of balls...in the lower section
overCard()
//String bowlerName,String batsman1Name,String batsman2Name
{
  List<Widget> zeroOverBalls = [
    BallWidget(),
    BallWidget(),
    BallWidget(),
    BallWidget(),
    BallWidget(),
    BallWidget(),
  ];
  Ball currentBall = null;

  return Container(
      margin: EdgeInsets.symmetric(
          vertical: (4 * SizeConfig.oneH).roundToDouble(),
          horizontal: (10 * SizeConfig.oneW).roundToDouble()),
      padding: EdgeInsets.symmetric(
          vertical: (8 * SizeConfig.oneH).roundToDouble(),
          horizontal: (4 * SizeConfig.oneW).roundToDouble()),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular((5 * SizeConfig.oneW).roundToDouble()),
          color: Colors.white),
      child: StreamBuilder<DocumentSnapshot>(
        stream: usersRef.doc(widget.creatorUID)
            .collection('createdMatches')
            .doc(widget.match.getMatchId())
            .collection('inning${widget.inningNo}overs')
            .doc("over${widget.overNoOnCard}")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          } else {
            final overData = snapshot.data.data();

            final overLength = overData['overLength'];

            List<Widget> balls = [];

            for (int i = 0; i < overLength; i++) {
              balls.add(BallWidget());
            }

            Map<String, dynamic> fullOverData =
            overData['fullOverData'];
            // final isThisCurrentOver = overData["isThisCurrentOver"];

            final bowlerOfThisOver = overData['bowlerName'];
            // final currentBallNo = overData['currentBall'];

            //decoding the map [ballNo:::RunsScores]
            fullOverData.forEach((ballNo, runsScored) {
              Ball ball = Ball(
                currentBallNo: int.parse(ballNo),
                runToShowOnUI: runsScored,
                cardOverNo: widget.overNoOnCard,
                currentOverNo: widget.match.currentOver.getCurrentOverNo(),
              );

              if (runsScored != null) {
                balls[int.parse(ballNo) - 1] = BallWidget(
                  currentBall: ball,
                );
              } else {
                print("Ball??????????  $runsScored");
                balls[int.parse(ballNo) - 1] = BallWidget(
                  currentBall: currentBall,
                );
              }
            });
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: (6 * SizeConfig.oneW).roundToDouble()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("OVER NO: ${widget.overNoOnCard}"),
                      SizedBox(
                        width: (30 * SizeConfig.oneW).roundToDouble(),
                      ),
                      bowlerOfThisOver == null
                          ? Container()
                          : Text("🏐 : $bowlerOfThisOver"),
                    ],
                  ),
                ),
                Container(
                  height: (60 * SizeConfig.oneH).roundToDouble(),
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: balls),
                ),
              ],
            );
          }
        }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
return overCard();
}

}


