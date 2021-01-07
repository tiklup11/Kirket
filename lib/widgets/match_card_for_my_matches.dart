import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/screens/live_score_page.dart';
import 'package:umiperer/screens/init_cricket_match_page.dart';
import 'package:umiperer/screens/upcoming_matches_screens.dart';

class MatchCardForCounting extends StatefulWidget {
  MatchCardForCounting({this.match});

  final CricketMatch match;

  @override
  _MatchCardForCountingState createState() => _MatchCardForCountingState();
}

class _MatchCardForCountingState extends State<MatchCardForCounting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 6,left: 10,right: 10),
      height: 145,
      child: Card(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/team1.png',
                        scale: 17,
                      ),
                      Text(widget.match.getTeam1Name())
                    ],
                  ),
                  Text(
                    "V/S",
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/team2.png',
                        scale: 17,
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: MaterialButton(
                elevation: 0,
                highlightElevation: 0,
                color: Colors.black12,
                minWidth: double.infinity,
                child: Text("Start Match"),
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return InitCricketMatch(match: widget.match,);
                  }));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  navigatorQuery(BuildContext context) {
    switch (widget.match.matchStatus) {
      case STATUS_MY_MATCH:
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return InitCricketMatch(match: widget.match,);
          }));
        }
        break;
      case STATUS_LIVE:
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LiveScorePage();
          }));
        }
        break;
      case STATUS_UPCOMING:
        {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UpcomingMatchesScreen();
          }));
        }
        break;
    }
  }
}
