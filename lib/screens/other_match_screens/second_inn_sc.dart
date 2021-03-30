import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/screens/matchDetailsScreens/mini_score.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/headline_widget.dart';
import 'package:umiperer/screens/matchDetailsScreens/bowlers_data_list.dart';
import 'package:umiperer/widgets/over_card.dart';
import 'package:umiperer/screens/matchDetailsScreens/batsmen_data_list.dart';

///mqd
class SecondInningScoreCard extends StatefulWidget {
  SecondInningScoreCard({this.creatorUID, this.match});
  final String creatorUID;
  final CricketMatch match;
  @override
  _SecondInningScoreCardState createState() => _SecondInningScoreCardState();
}

class _SecondInningScoreCardState extends State<SecondInningScoreCard> {
  List<Batsmen> currentBothBatsmen;
  DataStreams dataStreams;
  ScoreBoardData secondInningScoreBoard = ScoreBoardData();
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          children: [
            widget.match.isSecondInningEnd
                ? Center(
                    child:
                        HeadLineWidget(headLineString: "Second inning ended"))
                : Container(),
            HeadLineWidget(headLineString: "SCORECARD"),
            MiniScoreCard(
              isLiveScoreCard: false,
              inningNo: 2,
              matchId: widget.match.getMatchId(),
            ),
            HeadLineWidget(headLineString: widget.match.getSecondBattingTeam()),
            BatsmenDataList(
              inningNo: 2,
              matchId: widget.match.getMatchId(),
            ),
            HeadLineWidget(headLineString: widget.match.getSecondBowlingTeam()),
            BowlersDataList(
              inningNo: 2,
              matchId: widget.match.getMatchId(),
            ),
            HeadLineWidget(headLineString: "OVERS"),
            buildOversList()
          ],
        ));
  }

  buildOversList() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (8 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) => DummyOverCard(
          inningNo: 2,
          creatorUID: widget.creatorUID,
          match: widget.match,
          overNoOnCard: (index + 1),
        ),
      ),
    );
  }

  loadingData() {
    return Container(
        height: (80 * SizeConfig.oneH).roundToDouble(),
        child: Center(child: CircularProgressIndicator()));
  }
}
