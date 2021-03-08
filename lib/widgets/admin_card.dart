import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/main.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 40,
        child: Container(
          padding: EdgeInsets.all(8),
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
              TextButton(
                child:
                    widget.match.isMatchLive ? Text("TurnOFF") : Text("TurnON"),
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
        ),
      ),
    );
  }

  setIsLive(bool value) {
    // print("Setting isLive to $value");
    matchesRef.doc(widget.match.getMatchId()).update({"isLive": value});
  }
}
