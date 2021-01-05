import 'package:flutter/material.dart';
import 'package:umiperer/screens/live_score_page.dart';
import 'package:umiperer/screens/score_counter_page.dart';

class MatchCard extends StatelessWidget {
  MatchCard({this.team1Name,this.team2Name, @required this.isThisLive});

  final String team1Name;
  final String team2Name;
  final bool isThisLive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4),
      height: 130,
      child: Card(
        child: MaterialButton(
          onPressed: (){
            //TODO: navigate passed on [isLiveMatch]
            print('HEELLO');
            isThisLive?
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return LiveScorePage();
                })):
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ScoreCounterPage();
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
                    Image.asset('assets/images/team1.png',scale: 17,),
                    Text(team1Name)
                  ],
                ),
                Text("V/S", style: TextStyle(fontSize: 25,),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/team2.png',scale: 17,),
                    Text(team2Name),
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