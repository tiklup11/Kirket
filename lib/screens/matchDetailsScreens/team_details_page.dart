import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/headline_widget.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          //matchINFO
          HeadLineWidget(
            headLineString: "INFO",
          ),
          matchInfo(),
        ],
      ),
    );
  }

  matchInfo() {
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
          dataTable(
            dataType: "Team 1",
            dataInfo: widget.match.getTeam1Name(),
          ),
          dataTable(dataType: "Team 2", dataInfo: widget.match.getTeam2Name()),
          dataTable(
              dataType: "Player in each team",
              dataInfo: widget.match.getPlayerCount().toString()),
          dataTable(
              dataType: "No. of Overs",
              dataInfo: widget.match.getOverCount().toString()),
          dataTable(dataType: "Location", dataInfo: widget.match.getLocation()),
        ],
      ),
    );
  }

  dataTable({String dataType, String dataInfo}) {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.symmetric(
                vertical: (3 * SizeConfig.oneW).roundToDouble()),
            width: (220 * SizeConfig.oneW).roundToDouble(),
            child: Text(
              dataType,
              style: TextStyle(color: Colors.black54),
            )),
        // SizedBox(width: 20,),
        SizedBox(
            width: SizeConfig.setWidth(120),
            child: Text(
              dataInfo,
              maxLines: 3,
            ))
      ],
    );
  }
}
