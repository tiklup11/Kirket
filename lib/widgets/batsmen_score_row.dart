import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';

class BatsmenScoreRow extends StatelessWidget {

  BatsmenScoreRow({this.batsmen});
  final Batsmen batsmen;

  @override
  Widget build(BuildContext context) {
    return batsmanScoreRow();
  }

  batsmanScoreRow() {
    final TextStyle textStyle = TextStyle(color: Colors.black);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: Text(
            batsmen.playerName,
            style: textStyle,
            maxLines: 2,
          ),
        ),
        Container(
            width: 30,
            child: Text(
              batsmen.runs,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              batsmen.balls,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              batsmen.noOf4s,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              batsmen.noOf6s,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              batsmen.SR,
              style: textStyle,
            )),
      ],
    );
  }
}
