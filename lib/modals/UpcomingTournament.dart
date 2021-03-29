import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingTournament {
  String tournamentName;
  String matchLocation;
  String startingDate;
  int entryFees;
  int contactNumber;
  String creatorUID;
  String tournamentUID;

  UpcomingTournament({
    this.contactNumber,
    this.creatorUID,
    this.entryFees,
    this.matchLocation,
    this.startingDate,
    this.tournamentName,
    this.tournamentUID,
  });

  factory UpcomingTournament.from(DocumentSnapshot upcomingTournamentData) {
    return UpcomingTournament(
        startingDate: upcomingTournamentData.data()['startingDate'],
        contactNumber: upcomingTournamentData.data()['contactNumber'],
        creatorUID: upcomingTournamentData.data()['userUID'],
        entryFees: upcomingTournamentData.data()['entryFees'],
        tournamentName: upcomingTournamentData.data()['tournamentName'],
        matchLocation: upcomingTournamentData.data()['location'],
        tournamentUID: upcomingTournamentData.data()['utID']);
  }
}
