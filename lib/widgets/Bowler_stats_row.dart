import 'package:flutter/material.dart';
import 'package:umiperer/modals/Bowler.dart';

class BowlerStatsRow extends StatelessWidget {
  BowlerStatsRow({this.bowler,@required this.isThisSelectBowlerBtn});
  final Bowler bowler;
  final bool isThisSelectBowlerBtn;

  @override
  Widget build(BuildContext context) {
    return bowlerStatsRow();
  }

  bowlerStatsRow() {
    final TextStyle textStyle = TextStyle(color: Colors.black);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isThisSelectBowlerBtn?
        Colors.blueGrey.withOpacity(0.5):Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 120,
            child: Text(
              bowler.playerName,
              style: textStyle,
              maxLines: 2,
            ),
          ),
          Container(
              width: 30,
              child: Text(
                bowler.overs,
                style: textStyle,
              )),
          Container(
              width: 30,
              child: Text(
                bowler.median,
                style: textStyle,
              )),
          Container(
              width: 30,
              child: Text(
                bowler.runs,
                style: textStyle,
              )),
          Container(
              width: 30,
              child: Text(
                bowler.wickets,
                style: textStyle,
              )),
          Container(
              width: 30,
              child: Text(
                bowler.economy,
                style: textStyle,
              )),
        ],
      ),
    );
  }
}
