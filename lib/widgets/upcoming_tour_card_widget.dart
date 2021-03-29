import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/UpcomingTournament.dart';
import 'package:umiperer/modals/size_config.dart';

class UpcomingTournamentCard extends StatefulWidget {
  UpcomingTournamentCard({this.upcomingTournament, this.showBottomModalSheet});
  final UpcomingTournament upcomingTournament;
  final Function showBottomModalSheet;

  @override
  _UpcomingTournamentCardState createState() => _UpcomingTournamentCardState();
}

class _UpcomingTournamentCardState extends State<UpcomingTournamentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(child: cardV());
  }

  Container cardV() {
    final spaceV = SizedBox(
      height: (4 * SizeConfig.oneH).roundToDouble(),
    );
    final spaceH = SizedBox(
      width: (5 * SizeConfig.oneW).roundToDouble(),
    );

    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 2)),
      margin: EdgeInsets.only(
        top: (16 * SizeConfig.oneH).roundToDouble(),
        left: (10 * SizeConfig.oneW).roundToDouble(),
        right: (10 * SizeConfig.oneW).roundToDouble(),
      ),
      height: (170 * SizeConfig.oneH).roundToDouble(),
      child: Padding(
        padding: EdgeInsets.only(
            top: (14 * SizeConfig.oneH).roundToDouble(),
            left: (12 * SizeConfig.oneW).roundToDouble(),
            right: (12 * SizeConfig.oneW).roundToDouble()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.upcomingTournament.tournamentName.toUpperCase()}',
                  style: TextStyle(
                    fontSize: (24 * SizeConfig.oneW).roundToDouble(),
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
                spaceV,
                Row(
                  children: [
                    Icon(Icons.location_on),
                    spaceH,
                    Text(
                      "LOCATION : ${widget.upcomingTournament.matchLocation}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                spaceV,
                Row(
                  children: [
                    Icon(Icons.date_range),
                    spaceH,
                    Text(
                        "STARTING From : ${widget.upcomingTournament.startingDate}",
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                // ignore: missing_required_param
                child: Bounce(
                  onPressed: widget.showBottomModalSheet,
                  child: Container(
                    height: (35 * SizeConfig.oneH).roundToDouble(),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black12),
                      color: Colors.blueAccent.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    width: (180 * SizeConfig.oneW).roundToDouble(),
                    padding: EdgeInsets.symmetric(
                        horizontal: (20 * SizeConfig.oneW).roundToDouble()),
                    child: Center(child: Text("View Details")),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
