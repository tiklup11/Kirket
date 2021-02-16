import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:uuid/uuid.dart';
import 'package:umiperer/modals/UpcomingTournament.dart';

///media querydone
final upcomingTournamentCollectionRef = FirebaseFirestore.instance.collection('upcomingTournaments');

class AnnounceNewTournament extends StatelessWidget {
  AnnounceNewTournament({this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return TournamentEntryForm(user: user,);
  }
}

class TournamentEntryForm extends StatefulWidget {
  TournamentEntryForm({this.user});
  final User user;

  @override
  TournamentEntryFormState createState() => TournamentEntryFormState();
}


class TournamentEntryFormState extends State<TournamentEntryForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  UpcomingTournament tournament;
  var uuid = Uuid();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  void _handleSubmitted() {

    ///null checking and then generating MatchID, then uploading
    ///data to cloud.

    if (tournament.startingDate!=null && tournament.entryFees!=null &&
        tournament.tournamentName!=null && tournament.matchLocation!=null && tournament.contactNumber!=null &&
        tournament.startingDate.toString()!='' && tournament.contactNumber.toString()!='' &&
        tournament.tournamentName!='' && tournament.entryFees.toString()!='' && tournament.matchLocation!=''
    ) {
      // print('QWWWWWWWWW:::   ${newMatch.getTeam1Name()}');
      generateIdForUpcomingTournament();
      //TODO: 1.Upload Match Details on firebase
      uploadMatchDataToCloud();
      //2. Navigate to a screen and pass Match
      Navigator.pop(context);

      //TODO: show toast msg instead
      // showInSnackBar("Match Created");

      print('exiting handling sub');
      //buildPlayersName();
    } else {
      showInSnackBar(
        "Please fill all details",
      );
    }
  }

  ///generating a random ID
  generateIdForUpcomingTournament(){
    final String matchId = uuid.v1();
    tournament.upcomingTournamentId=matchId;
  }

  uploadMatchDataToCloud(){
    upcomingTournamentCollectionRef.doc(tournament.upcomingTournamentId).set({
      'utID':tournament.upcomingTournamentId,
      'tournamentName': tournament.tournamentName,
      'location': tournament.matchLocation,
      'entryFees': tournament.entryFees,
      'contactNumber': tournament.contactNumber,
      'startingDate': tournament.startingDate,
      'timeStamp': DateTime.now(),
      'userUID': widget.user.uid,
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tournament = UpcomingTournament();
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Fill Tournament Details"),
      ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.symmetric(horizontal: (16*SizeConfig.oneW).roundToDouble()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    icon: Icon(Icons.whatshot_rounded),
                    hintText: "Tournament Name",
                    labelText:
                    "Tournament Name",
                  ),
                  onChanged: (value) {
                    tournament.tournamentName=value;
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.location_on),
                    hintText: "Location",
                    labelText: "Location",
                    // prefixText: '+1 ',
                  ),
                  onChanged: (value) {
                    tournament.matchLocation=value;
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.attach_money_rounded),
                    hintText: "Entry Fees",
                    labelText:
                    "Entry Fees",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    tournament.entryFees=(int.parse(value));
                  },
                ),
                sizedBoxSpace,
                TextFormField
                  (
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.phone),
                    hintText: "Contact Number",
                    labelText:
                    "Contact Number",
                  ),
                  keyboardType: TextInputType.number,

                  onChanged: (value) {
                    tournament.contactNumber=(int.parse(value));
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.date_range),
                    hintText: "Starting Date",
                    labelText:
                    "Starting Date",
                  ),
                  onChanged: (value) {
                    tournament.startingDate=value;
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.blueGrey.shade400,
                    child: Text(
                        "Announce Tournament"),
                    onPressed: (){
                      _handleSubmitted();
                    },
                  ),
                ),
                sizedBoxSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
