import 'package:flutter/material.dart';
import 'package:umiperer/widgets/match_card_view.dart';

class LiveMatchesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MatchCard(team1Name: 'Gulawad',team2Name: "Somakhedi",isThisLive: true,),
        MatchCard(team1Name: 'Gulawad',team2Name: "Somakhedi",isThisLive: false,),
      ],
    );
  }
}




