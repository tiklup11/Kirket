import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/other_match_screens/first_in_sc.dart';
import 'package:umiperer/screens/matchDetailsScreens/score_counting_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';
import 'package:umiperer/screens/other_match_screens/second_inn_sc.dart';
import 'package:umiperer/modals/ShareMatch.dart';
import 'package:umiperer/services/database_updater.dart';

class MatchDetails extends StatefulWidget {
  MatchDetails({this.match, this.user});

  final CricketMatch match;
  final User user;

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  List tabBarView;

  @override
  void initState() {
    //  implement initState
    super.initState();
    tabBarView = [
      TeamDetails(
        match: widget.match,
      ),
      ScoreCountingPage(
        user: widget.user,
        match: widget.match,
      ),
      FirstInningScoreCard(creatorUID: widget.user.uid, match: widget.match),
      widget.match.getInningNo() == 1
          ? Container(
              color: Colors.white,
              child: Center(
                child: zeroData(
                    msg: "2nd Inning not started yet",
                    iconData: Icons.sports_cricket_outlined),
              ),
            )
          : SecondInningScoreCard(
              creatorUID: widget.user.uid, match: widget.match)
      // BallByBallPage()
      // Overs(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Info",
      "Scoring",
      "1st Inn",
      "2nd Inn"
      // "BallByBall"
      // "Overs"
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  ShareMatch(widget.match).shareMatch(context);
                }),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  DatabaseController.showDeleteDialog(
                      context: context,
                      catName: widget.match.category,
                      matchId: widget.match.getMatchId());
                }),
          ],
          automaticallyImplyLeading: false,
          title: Text(
            "${widget.match.getTeam1Name().toUpperCase()} v ${widget.match.getTeam2Name().toUpperCase()}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabBarView) tab,
          ],
        ),
      ),
    );
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
