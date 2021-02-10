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
      margin: EdgeInsets.only(top: (4*SizeConfig.one_H).roundToDouble(),
          left: (10*SizeConfig.one_W).roundToDouble(),
          right: (10*SizeConfig.one_W).roundToDouble()),
      height: (130*SizeConfig.one_H).roundToDouble(),
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
            padding: EdgeInsets.symmetric(horizontal: (14*SizeConfig.one_W).roundToDouble()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/team1.png',
                      scale: (17*SizeConfig.one_W).roundToDouble(),
                    ),
                    Text(match.getTeam1Name())
                  ],
                ),
                Text(
                  "V/S",
                  style: TextStyle(
                    fontSize: (25*SizeConfig.one_W).roundToDouble(),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/team2.png',
                      scale: (17*SizeConfig.one_W).roundToDouble(),
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
