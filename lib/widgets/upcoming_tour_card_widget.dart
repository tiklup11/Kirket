import 'package:flutter/material.dart';
import 'package:umiperer/modals/UpcomingTournament.dart';
import 'package:umiperer/modals/size_config.dart';

class UpcomingTournamentCard extends StatefulWidget {

  UpcomingTournamentCard({this.upcomingTournament,this.showBottomModalSheet});
  final UpcomingTournament upcomingTournament;
  final Function showBottomModalSheet;

  @override
  _UpcomingTournamentCardState createState() => _UpcomingTournamentCardState();
}

class _UpcomingTournamentCardState extends State<UpcomingTournamentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: cardV()
    );
  }

  Container cardV(){

    final spaceV = SizedBox(height: (4*SizeConfig.oneH).roundToDouble(),);
    final spaceH = SizedBox(width: (5*SizeConfig.oneW).roundToDouble(),);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular((8*SizeConfig.oneW).roundToDouble()),
        // image: DecorationImage(image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover,),
      ),
      margin: EdgeInsets.only(top: (6*SizeConfig.oneH).roundToDouble(), left: (10*SizeConfig.oneW).roundToDouble(),
          right: (10*SizeConfig.oneW).roundToDouble()),
      height: (170*SizeConfig.oneH).roundToDouble(),
      child: Card(
        child: Padding(
          padding: EdgeInsets.only(top: (14*SizeConfig.oneH).roundToDouble(),left: (12*SizeConfig.oneW).roundToDouble(),right: (12*SizeConfig.oneW).roundToDouble()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.upcomingTournament.tournamentName.toUpperCase()}',style: TextStyle(fontSize: (24*SizeConfig.oneW).roundToDouble(),color: Colors.black,fontWeight: FontWeight.w500,),maxLines: 2,),
                  spaceV,
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      spaceH,
                      Text("LOCATION : ${widget.upcomingTournament.matchLocation}",style: TextStyle(color: Colors.black),),
                    ],
                  ),
                  spaceV,
                  Row(
                    children: [
                      Icon(Icons.date_range),
                      spaceH,
                      Text("STARTING From : ${widget.upcomingTournament.startingDate}",style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
              MaterialButton  (
                minWidth: double.infinity,
                animationDuration: Duration(milliseconds: 1),
                elevation: 0,
                highlightElevation: 0,
                color: Colors.blueGrey.shade400,
                child: Text(
                    "View Details"),
                onPressed:widget.showBottomModalSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
