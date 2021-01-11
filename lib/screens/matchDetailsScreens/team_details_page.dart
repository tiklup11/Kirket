import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';


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

  List<Widget> teamAPlayers = [];

  List<Widget> teamBPlayers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buildPlayersName();
  }

  buildPlayersName(){
    for(int i=0;i<widget.match.getPlayerCount();i++){

      teamAPlayers.add(Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Text(widget.match.team1List[i]),),);

      teamBPlayers.add(Container(
          margin: EdgeInsets.symmetric(vertical: 4),
          child: Text(widget.match.team2List[i]),),);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.black12,
      child: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text(
              "SQUADS",
            ),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              setState(
                () {
                  isListACollapsed = (!isListACollapsed);
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Team ${widget.match.getTeam1Name()}'),
                isListACollapsed
                    ? Icon(Icons.keyboard_arrow_up_sharp)
                    : Icon(Icons.keyboard_arrow_down_sharp)
              ],
            ),
          ),
          isListACollapsed
              ? Container()
              : Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // shrinkWrap: true,
                    children: teamAPlayers,
                  ),
              ),

          //for team B
          FlatButton(
            color: Colors.white,
            onPressed: () {
              setState(() {
                isListBCollapsed = (!isListBCollapsed);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Team ${widget.match.getTeam2Name()}'),
                isListBCollapsed
                    ? Icon(Icons.keyboard_arrow_up_sharp)
                    : Icon(Icons.keyboard_arrow_down_sharp)
              ],
            ),
          ),
          isListBCollapsed
              ? Container()
              : Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: teamBPlayers,
                  ),
                ),

          //matchINFO
          Container(
            padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
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
      padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
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
            width: 220,
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
