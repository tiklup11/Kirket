import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsHome_forAudience.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';

///mqd
class LiveMatchCard extends StatefulWidget {
  LiveMatchCard({this.match,this.creatorUID,this.matchUID});

  CricketMatch match;
  String creatorUID;
  String matchUID;

  @override
  _LiveMatchCardState createState() => _LiveMatchCardState();
}

class _LiveMatchCardState extends State<LiveMatchCard> {

  DataStreams _dataStreams;
  ScoreBoardData _scoreBoardData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataStreams = DataStreams(userUID: widget.creatorUID,matchId: widget.matchUID);
    _scoreBoardData = ScoreBoardData(
        inningNo: widget.match.getInningNo(),
      battingTeamName: widget.match.getCurrentBattingTeam(),
      bowlingTeam: widget.match.getCurrentBowlingTeam(),
      team1name: widget.match.getTeam1Name(),
      team2name: widget.match.getTeam2Name(),
    );
  }

  @override
  Widget build(BuildContext context) {

    // widget.creatorUID = '4VwUugdc6XVPJkR2yltZtFGh4HN2'; //pulkitUID
    Stream<DocumentSnapshot> stream;

    if(widget.match.getInningNo()==1){

      stream = userRef.doc(widget.creatorUID)
          .collection('createdMatches')
          .doc(widget.matchUID)
          .collection('FirstInning')
          .doc("scoreBoardData").snapshots();

    } else if(widget.match.getInningNo()==2){
      stream = userRef.doc(widget.creatorUID)
          .collection('createdMatches')
          .doc(widget.matchUID)
          .collection('SecondInning')
          .doc("scoreBoardData").snapshots();
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return miniScoreLoadingScreen();
          } else {
            final scoreBoardData = snapshot.data.data();
            final ballOfTheOver = scoreBoardData['ballOfTheOver'];
            final currentOverNo = scoreBoardData['currentOverNo'];
            final totalRuns = scoreBoardData['totalRuns'];
            final wicketsDown = scoreBoardData['wicketsDown'];

            _scoreBoardData.currentBallNo=ballOfTheOver;
            _scoreBoardData.currentOverNo = currentOverNo;
            _scoreBoardData.totalRuns = totalRuns;
            _scoreBoardData.totalWicketsDown = wicketsDown;

            return liveCardUI(scoreBoardData: _scoreBoardData);
          }
        });
  }

  Widget miniScoreLoadingScreen() {
    return Container(
      height: (220*SizeConfig.oneH).roundToDouble(),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  liveCardUI({ScoreBoardData scoreBoardData}){
    return Container(
      margin: EdgeInsets.only(top: (4*SizeConfig.oneH).roundToDouble(),
          left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble()),
      // height:widget.match.getIsMatchStarted()?
      // (250*SizeConfig.oneH).roundToDouble():
      // (150*SizeConfig.oneH).roundToDouble(),
      child: Card(
        elevation: 40,
        child: MaterialButton(
          highlightColor: Colors.grey.shade300,
          padding: EdgeInsets.only(top: 10*SizeConfig.oneH),
          onPressed: () {
            if(widget.match.getIsMatchStarted()){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MatchDetailsHomeForAudience(match: widget.match,creatorUID: widget.creatorUID,matchUID: widget.matchUID,);
              }));
            }else{
              showAlertDialog(context: context);
            }
          },
          child: Column(
            children: [
              widget.match.getIsMatchStarted()?
              liveScore(scoreBoardData: scoreBoardData):Container(),
            Container(
              decoration: BoxDecoration(
                // color: Colors.blueGrey.shade50,
                // borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.only(bottom: 8),
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
                        Text(widget.match.getTeam1Name().toUpperCase(),maxLines: 2,
                            style: TextStyle(fontWeight: FontWeight.bold)
                        )
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
                          widget.match.getTeam2Name().toUpperCase(),maxLines: 2,style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
              Container(
                height: 27,
                width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                  ),
                  child: Center(child: bottomLine())),
            ],
          ),
        ),
      ),
    );
  }


  Container bottomLine(){
    String tossString = "${widget.match.getTossWinner().toUpperCase()} won the TOSS and choose to ${widget.match.getChoosedOption().toUpperCase()}";
    if(widget.match.getFinalResult()!=null && widget.match.isSecondInningEnd){
      return Container(child: Text(widget.match.getFinalResult(),maxLines: 4,),);
    }else if(widget.match.isSecondInningEnd && widget.match.getFinalResult()==null){
      return Container(child: Center(child: Text("Match End",maxLines: 1,),),);
    }else if(tossString!=null){
      return Container(child: Text(tossString,maxLines: 3,),);
    }else {
      return Container();
    }

  }


  liveScore({ScoreBoardData scoreBoardData}){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble()),
      padding: EdgeInsets.only(top: (6*SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular((10*SizeConfig.oneW).roundToDouble())
      ),
      child: Column(
        children: [
          widget.match.getIsMatchStarted()?
          Text("Inning ${widget.match.getInningNo()}"):Container(),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: (10 * SizeConfig.oneW).roundToDouble(),
                vertical: (10 * SizeConfig.oneH).roundToDouble()),
            margin: EdgeInsets.symmetric(
                horizontal: (10 * SizeConfig.oneW).roundToDouble(),
                vertical: (10 * SizeConfig.oneH).roundToDouble()),
            decoration: BoxDecoration(
              // color: Colors.white,
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
                          scoreBoardData.battingTeamName
                              .toUpperCase(),
                          style: TextStyle(
                              fontSize:
                              (24 * SizeConfig.oneW).roundToDouble()),
                        ),
                        Text(
                          // runs/wickets (currentOverNumber.currentBallNo)
                          // "65/3  (13.2)",
                          scoreBoardData.getFormatedRunsString(),
                          style: TextStyle(
                              fontSize:
                              (16 * SizeConfig.oneW).roundToDouble()),
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
