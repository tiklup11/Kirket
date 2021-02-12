import 'package:flutter/material.dart';
import 'package:umiperer/modals/Batsmen.dart';
import 'package:umiperer/modals/size_config.dart';

///mqd
class BatsmenScoreRow extends StatelessWidget {

  BatsmenScoreRow({this.batsmen,@required this.isOnStrike,@required this.isThisSelectBatsmenBtn});

  final Batsmen batsmen;
  final bool isOnStrike;
  final bool isThisSelectBatsmenBtn;

  Color whatColor(){
    if(isThisSelectBatsmenBtn){
      return Colors.blueGrey.withOpacity(0.5);
    }
    if(isOnStrike){
      return ThemeData.light().primaryColor.withOpacity(0.3);
    }
    return Colors.white;
  }
  @override
  Widget build(BuildContext context) {

    return batsmanScoreRow();
  }

  batsmanScoreRow() {
    final TextStyle textStyle = TextStyle(color: Colors.black);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((4*SizeConfig.oneW).roundToDouble()),
        color: whatColor(),
      ),
      padding: EdgeInsets.symmetric(vertical: (5*SizeConfig.oneH).roundToDouble(),horizontal: (6*SizeConfig.oneW).roundToDouble()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: (120*SizeConfig.oneW).roundToDouble(),
            child:
            batsmen.isOnStrike?
                Text("${batsmen.playerName} 🏏"):
            Text(
              batsmen.playerName,
              style: textStyle,
              maxLines: 2,
            ),
          ),
          Container(
              width: (30*SizeConfig.oneW).roundToDouble(),
              child: Text(
                batsmen.runs,
                style: textStyle,
              )),
          Container(
              width: (30*SizeConfig.oneW).roundToDouble(),

              child: Text(
                batsmen.balls,
                style: textStyle,
              )),
          Container(
              width: (30*SizeConfig.oneW).roundToDouble(),
              child: Text(
                batsmen.noOf4s,
                style: textStyle,
              )),
          Container(
              width: (30*SizeConfig.oneW).roundToDouble(),
              child: Text(
                batsmen.noOf6s,
                style: textStyle,
              )),
          Container(
              width: (34*SizeConfig.oneW).roundToDouble(),
              child: Text(
                batsmen.sR,
                style: textStyle,
              )),
        ],
      ),
    );
  }
}
