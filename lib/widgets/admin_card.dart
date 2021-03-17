import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/size_config.dart';

class AdminCard extends StatefulWidget {
  AdminCard({
    this.match,
    this.creatorUID,
  });
  final CricketMatch match;
  final String creatorUID;

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  bool isSwitched;

  @override
  Widget build(BuildContext context) {
    isSwitched = widget.match.isMatchLive;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(
          horizontal: (10 * SizeConfig.oneW).roundToDouble(),
          vertical: (10 * SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${widget.match.getTeam1Name()}   VS    ${widget.match.getTeam2Name()}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.black12,
            height: 2,
          ),
          TextButton(
            child: widget.match.isMatchLive ? Text("TurnOFF") : Text("TurnON"),
            onPressed: () {
              widget.match.isMatchLive ? setIsLive(false) : setIsLive(true);
            },
          )
          // FlutterSwitch(
          //   borderRadius: 10,
          //   showOnOff: true,
          //   activeColor: Colors.blueGrey,
          //   value: isSwitched,
          //   onToggle: (val) {
          //     setState(() {
          //       setIsLive(val);
          //       isSwitched = val;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  setIsLive(bool value) {
    // print("Setting isLive to $value");
    matchesRef.doc(widget.match.getMatchId()).update({"isLive": value});
  }
}
