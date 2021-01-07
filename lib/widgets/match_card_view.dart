import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/live_score_page.dart';

class LiveMatchCard extends StatelessWidget {
  LiveMatchCard({this.match});

  final CricketMatch match;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4,left: 10,right: 10),
      height: 130,
      child: Card(
        child: MaterialButton(
          onPressed: () {
            //TODO: navigate passed on [isLiveMatch]
            print('HEELLO');

            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LiveScorePage();
            }));
          },
          child: Container(
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
                    Text(match.getTeam1Name())
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
                      match.getTeam2Name(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
