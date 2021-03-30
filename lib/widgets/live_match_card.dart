import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/other_match_screens/matchDetailsHome_forAudience.dart';
import 'package:umiperer/services/database_updater.dart';
import 'package:umiperer/modals/FbAds.dart';

///mqd
class LiveMatchCard extends StatefulWidget {
  LiveMatchCard({
    this.currentUser,
    this.match,
    this.creatorUID,
    this.matchUID,
  });

  final CricketMatch match;
  final String creatorUID;
  final String matchUID;
  final User currentUser;

  @override
  _LiveMatchCardState createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<LiveMatchCard> {
  ScoreBoardData _scoreBoardData;

  @override
  void initState() {
    super.initState();

    _scoreBoardData = ScoreBoardData(
        battingTeamName: widget.match.getCurrentBattingTeam(),
        bowlingTeam: widget.match.getCurrentBowlingTeam(),
        matchData: widget.match);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: DatabaseController.getScoreBoardDocRef(
          inningNo: widget.match.inningNumber,
          matchId: widget.match.getMatchId(),
        ).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return miniScoreLoadingScreen();
          } else {
            if (widget.match.getIsMatchStarted()) {
              _scoreBoardData = ScoreBoardData.from(snapshot.data);
              _scoreBoardData.matchData = widget.match;
            }
            return liveCardUI(scoreBoardData: _scoreBoardData);
          }
        });
  }

  divider() {
    return Container(
      color: Colors.black12,
      height: 2,
      width: double.infinity,
    );
  }

  Widget miniScoreLoadingScreen() {
    return Container(
      height: (220 * SizeConfig.oneH).roundToDouble(),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  liveCardUI({ScoreBoardData scoreBoardData}) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      margin: EdgeInsets.only(
        top: (16 * SizeConfig.oneH).roundToDouble(),
        left: (10 * SizeConfig.oneW).roundToDouble(),
        right: (10 * SizeConfig.oneW).roundToDouble(),
      ),
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (widget.match.getIsMatchStarted()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MatchDetailsHomeForAudience(
                currentUser: widget.currentUser,
                match: widget.match,
                creatorUID: widget.creatorUID,
                matchUID: widget.matchUID,
              );
            }));
          } else {
            showAlertDialog(context: context);
          }
        },
        child: Column(
          children: [
            widget.match.getIsMatchStarted() && !widget.match.isSecondInningEnd
                ? Container(
                    // padding: EdgeInsets.only(top: 10),
                    child: liveScore(scoreBoardData: scoreBoardData),
                  )
                : Container(),
            aVsB(),
            divider(),
            Container(
              height: SizeConfig.setHeight(40),
              width: double.infinity,
              child: Center(child: bottomLine()),
            ),
          ],
        ),
      ),
    );
  }

  aVsB() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
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
                    scale: (17 * SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Text(widget.match.getTeam1Name().toUpperCase(),
                    maxLines: 2,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
              ],
            ),
          ),
          Text(
            "VS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (25 * SizeConfig.oneW).roundToDouble(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/team2.png',
                    scale: (17 * SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Text(widget.match.getTeam2Name().toUpperCase(),
                    maxLines: 2,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      // child: Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     // Image.asset('assets/gifs/win.gif',height: 100,width: 100,),
      //
      //   ],
      // ),
    );
  }

  Container bottomLine() {
    TextStyle textStyle = TextStyle(fontSize: 12);

    if (!widget.match.getIsMatchStarted()) {
      return Container(
        child: Text(
          "Match will start soon",
          maxLines: 3,
        ),
      );
    }

    String tossString =
        "${widget.match.getTossWinner().toUpperCase()} won the TOSS and choose to ${widget.match.getChoosedOption().toUpperCase()}";
    if (_scoreBoardData.getFinalResult() != null &&
        widget.match.isSecondInningEnd) {
      return Container(
        child: Text(
          _scoreBoardData.getFinalResult(),
          maxLines: 4,
          style: textStyle,
        ),
      );
    } else if (widget.match.isSecondInningEnd &&
        _scoreBoardData.getFinalResult() == null) {
      return Container(
        child: Center(
          child: Text(
            "Match End",
            maxLines: 1,
            style: textStyle,
          ),
        ),
      );
    } else if (tossString != null) {
      return Container(
        child: Text(
          tossString,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      );
    } else {
      return Container();
    }
  }

  liveScore({ScoreBoardData scoreBoardData}) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 14, bottom: 0),
      padding: EdgeInsets.only(top: (6 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12, width: 2),
          borderRadius:
              BorderRadius.circular((10 * SizeConfig.oneW).roundToDouble())),
      child: Column(
        children: [
          widget.match.isMatchLive
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (20 * SizeConfig.oneW).roundToDouble()),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.match.getIsMatchStarted() &&
                              !widget.match.isSecondInningEnd
                          ? Text(
                              "LIVE",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            )
                          : Container(),
                      Text("Inning ${widget.match.getInningNo()}"),
                    ],
                  ),
                )
              : Container(),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (10 * SizeConfig.oneW).roundToDouble(),
                vertical: (4 * SizeConfig.oneH).roundToDouble()),
            margin: EdgeInsets.symmetric(
                horizontal: (10 * SizeConfig.oneW).roundToDouble(),
                vertical: (6 * SizeConfig.oneH).roundToDouble()),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius:
                  BorderRadius.circular((4 * SizeConfig.oneW).roundToDouble()),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 230,
                          child: Text(
                            scoreBoardData.battingTeamName.toUpperCase(),
                            style: TextStyle(
                                fontSize:
                                    (16 * SizeConfig.oneW).roundToDouble()),
                          ),
                        ),
                        Text(
                          // runs/wickets (currentOverNumber.currentBallNo)
                          // "65/3  (13.2)",
                          scoreBoardData.getFormatedRunsString(),
                          style: TextStyle(
                              fontSize: (16 * SizeConfig.oneW).roundToDouble()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text("CRR"),
                        Text(scoreBoardData.getCrr()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
      title: Image.network(
        'https://media1.tenor.com/images/39acc7baa2eabe357fbb48ed33741d15/tenor.gif?itemid=16657275',
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
