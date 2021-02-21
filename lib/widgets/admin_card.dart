import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';

class AdminCard extends StatefulWidget {

  AdminCard({this.match,this.creatorUID,});
  final CricketMatch match;
  final String creatorUID;

  @override
  _AdminCardState createState() => _AdminCardState();
}

class _AdminCardState extends State<AdminCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all((10*SizeConfig.oneW).roundToDouble()),
      margin: EdgeInsets.all((8*SizeConfig.oneH).roundToDouble()),
      height: (100*SizeConfig.oneH).roundToDouble(),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular((10*SizeConfig.oneW).roundToDouble())
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("${widget.match.getTeam1Name()}   VS    ${widget.match.getTeam2Name()}"),
            ],
          ),
          MaterialButton(
            minWidth: double.infinity,
            elevation: 0,
            highlightElevation: 0,
            color: Colors.blueGrey.shade400,
            child: Text(
                widget.match.isMatchLive?
                "Turn Off": "Turn On"
            ),
            onPressed: (){

              widget.match.isMatchLive?setIsLive(false):setIsLive(true);

            },
          ),
        ],
      ),
    );
  }

  setIsLive(bool value) {
      usersRef.doc(widget.creatorUID).collection('createdMatches').doc(widget.match.getMatchId()).update(
       {
        "isLive": value
       });
  }
}
