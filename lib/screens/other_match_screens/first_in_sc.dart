import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/ScoreBoardData.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/headline_widget.dart';
import 'package:umiperer/widgets/over_card.dart';
import 'package:umiperer/screens/matchDetailsScreens/mini_score.dart';
import 'package:umiperer/screens/matchDetailsScreens/bowlers_data_list.dart';
import 'package:umiperer/screens/matchDetailsScreens/batsmen_data_list.dart';

class FirstInningScoreCard extends StatefulWidget {
  FirstInningScoreCard({this.creatorUID, this.match});
  final String creatorUID;
  final CricketMatch match;
  // final String matchUID;
  @override
  _FirstInningScoreCardState createState() => _FirstInningScoreCardState();
}

class _FirstInningScoreCardState extends State<FirstInningScoreCard> {
  List<Batsmen> currentBothBatsmen;
  DataStreams dataStreams;

  ScoreBoardData firstInningScoreBoard = ScoreBoardData();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        physics: ScrollPhysics(),
        children: [
          tossLineWidget(),
          widget.match.isFirstInningEnd
              ? Center(
                  child: HeadLineWidget(headLineString: "First inning ended"))
              : Container(),
          HeadLineWidget(headLineString: "SCORECARD"),
          MiniScoreCard(
            isLiveScoreCard: false,
            inningNo: 1,
            matchId: widget.match.getMatchId(),
          ),
          HeadLineWidget(headLineString: widget.match.getFirstBattingTeam()),
          BatsmenDataList(
            inningNo: 1,
            matchId: widget.match.getMatchId(),
          ),
          HeadLineWidget(headLineString: widget.match.getFirstBowlingTeam()),
          BowlersDataList(
            inningNo: 1,
            matchId: widget.match.getMatchId(),
          ),
          HeadLineWidget(headLineString: "OVERS"),
          buildOversList(),
        ],
      ),
    );
  }

  buildOversList() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      child: ListView.builder(
        shrinkWrap: true,
        controller: ScrollController(),
        scrollDirection: Axis.vertical,
        itemCount: widget.match.getOverCount(),
        itemBuilder: (BuildContext context, int index) => DummyOverCard(
          inningNo: 1,
          creatorUID: widget.creatorUID,
          match: widget.match,
          overNoOnCard: (index + 1),
        ),
      ),
    );
  }

  ///TODO: might change its position
  tossLineWidget() {
    return Container(
        padding: EdgeInsets.only(
            left: (12 * SizeConfig.oneW).roundToDouble(),
            top: (12 * SizeConfig.oneH).roundToDouble()),
        child: Center(
          child: Text(
            "${widget.match.getTossWinner().toUpperCase()} won the TOSS and choose to ${widget.match.getChoosedOption().toUpperCase()}",
            maxLines: 2,
            style: TextStyle(fontSize: 12),
          ),
        ));
  }

  zeroData({String msg, IconData iconData}) {
    return Container(
      height: (80 * SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(
            width: (4 * SizeConfig.oneW).roundToDouble(),
          ),
          Text(msg),
        ],
      ),
    );
  }
}
