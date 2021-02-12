import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/live_score_page.dart';

///mqd
class LiveMatchCard extends StatelessWidget {
  LiveMatchCard({this.match});

  final CricketMatch match;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: (4*SizeConfig.oneH).roundToDouble(),
          left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble()),
      height: (130*SizeConfig.oneH).roundToDouble(),
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
            padding: EdgeInsets.symmetric(horizontal: (14*SizeConfig.oneW).roundToDouble()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/team1.png',
                      scale: (17*SizeConfig.oneW).roundToDouble(),
                    ),
                    Text(match.getTeam1Name())
                  ],
                ),
                Text(
                  "V/S",
                  style: TextStyle(
                    fontSize: (25*SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/team2.png',
                      scale: (17*SizeConfig.oneW).roundToDouble(),
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
