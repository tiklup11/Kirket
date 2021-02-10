import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';

///MQD
//this tab is under MatchDetails
class TeamDetails extends StatefulWidget {
  TeamDetails({this.match});

  final CricketMatch match;
  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {

  bool isListACollapsed = true;
  bool isListBCollapsed = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black12,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //matchINFO
          Container(
            margin: EdgeInsets.only(top: (22*SizeConfig.one_H).roundToDouble(),bottom: (2*SizeConfig.one_H).roundToDouble()),
            padding: EdgeInsets.only(left: (16*SizeConfig.one_W).roundToDouble(),
                top: (4*SizeConfig.one_W).roundToDouble(),
                bottom: (4*SizeConfig.one_H).roundToDouble()),
            child: Text(
              "INFO",
            ),
          ),
          matchInfo(),
        ],
      ),
    );
  }

  matchInfo() {
    return Container(
      padding: EdgeInsets.only(left: (16*SizeConfig.one_W).roundToDouble(), top: (10*SizeConfig.one_H).roundToDouble(),
          bottom: (10*SizeConfig.one_H).roundToDouble()),
      color: Colors.white,
      child: Column(
        children: [
          dataTable(dataType: "Team 1", dataInfo: widget.match.getTeam1Name()),
          dataTable(dataType: "Team 2", dataInfo: widget.match.getTeam2Name()),
          dataTable(
              dataType: "Player in each team",
              dataInfo: widget.match.getPlayerCount().toString()),
          dataTable(
              dataType: "No. of Overs",
              dataInfo: widget.match.getOverCount().toString()),
          dataTable(
              dataType: "Location",
              dataInfo: widget.match.getLocation()),
        ],
      ),
    );
  }

  dataTable({String dataType, String dataInfo}) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 3),
            width: (220*SizeConfig.one_W).roundToDouble(),
            child: Text(
              dataType,
              style: TextStyle(color: Colors.black54),
            )),
        // SizedBox(width: 20,),
        Text(dataInfo)
      ],
    );
  }
}
