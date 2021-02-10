import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:uuid/uuid.dart';

///media querydone
final usersRefe = FirebaseFirestore.instance.collection('users');

class FillNewMatchDetailsPage extends StatelessWidget {
   FillNewMatchDetailsPage({this.user});
   final User user;

  @override
  Widget build(BuildContext context) {
    return MatchDetailsForm(user: user,);
  }
}

class MatchDetailsForm extends StatefulWidget {
  MatchDetailsForm({this.user});
  final User user;

  @override
  MatchDetailsFormState createState() => MatchDetailsFormState();
}


class MatchDetailsFormState extends State<MatchDetailsForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  CricketMatch newMatch;
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

    if (newMatch.getOverCount()!=null && newMatch.getPlayerCount()!=null &&
    newMatch.getTeam1Name()!=null && newMatch.getTeam2Name()!=null && newMatch.getLocation()!=null &&
        newMatch.getOverCount()!='' && newMatch.getPlayerCount()!='' &&
        newMatch.getTeam1Name()!='' && newMatch.getTeam2Name()!='' && newMatch.getLocation()!=''
    ) {
      // print('QWWWWWWWWW:::   ${newMatch.getTeam1Name()}');
      generateIdForMatch();
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

  generateIdForMatch(){
    final String matchId = uuid.v1();
    newMatch.setMatchId(matchId);
  }

  uploadMatchDataToCloud(){

    print("QQQQQQQQQQQQQQQ:::  ${widget.user.email}");
    print("QQQQQQQQQQQQQQQ:::  ${newMatch.getMatchId()}");

    usersRefe.doc(widget.user.uid).collection("createdMatches").doc(newMatch.getMatchId()).set({

      'matchId':newMatch.getMatchId(),
      'team1name': newMatch.getTeam1Name(),
      'team2name': newMatch.getTeam2Name(),
      'overCount': newMatch.getOverCount(),
      'playerCount': newMatch.getPlayerCount(),
      'matchLocation': newMatch.getLocation(),
      'timeStamp': DateTime.now(),
      'tossWinner': null,
      'whatChoose': null, //bat or ball
      'isMatchStarted': false,
      'currentOverNumber': 1,
      'inningNumber':1,
      'strikerBatsmen': null,
      'nonStrikerBatsmen':null,
      'currentBowler': null,
      'totalRuns': 0,
      'wicketsDownOfInning1':0,
      'currentBallNo': 0,

    });

    ///making everyOver doc inside Overs COllections inside first innings collections
    for(int i=0;i<newMatch.getOverCount();i++){

      var completeOverData = {"1":null,"2":null,"3":null,"4":null,"5":null,"6":null};

      usersRefe.doc(widget.user.uid).collection("createdMatches").doc(newMatch.getMatchId()).collection('inning1overs')
          .doc("over${i+1}").set({

        "overNo": i+1,
        "currentBall": 1,
        "fullOverData":completeOverData,
        "isThisCurrentOver":false,
        "bowlerName":null

      });

      usersRefe.doc(widget.user.uid).collection("createdMatches").doc(newMatch.getMatchId()).collection('inning2overs')
          .doc("over${i+1}").set({

        "overNo": i+1,
        "currentBall": 1,
        "fullOverData":completeOverData,
        "isThisCurrentOver":false,
        "bowlerName":null

      });
    }

    ///matchDoc > FirstInningCollection > scoreBoardDataDoc >
    usersRefe.doc(widget.user.uid).collection('createdMatches').doc(newMatch.getMatchId())
    .collection('FirstInning').doc('scoreBoardData').set({
      "ballOfTheOver":0,
      "currentOverNo":0,
      "totalRuns":0,
      "wicketsDown":0
    });

    usersRefe.doc(widget.user.uid).collection('createdMatches').doc(newMatch.getMatchId())
        .collection('SecondInning').doc('scoreBoardData').set({
      "ballOfTheOver":0,
      "currentOverNo":0,
      "totalRuns":0,
      "wicketsDown":0,
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newMatch = CricketMatch();
  }

  @override
  Widget build(BuildContext context) {
     final sizedBoxSpace = SizedBox(height: 24);

    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Match Details"),
      ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: EdgeInsets.symmetric(horizontal: (16*SizeConfig.one_W).roundToDouble()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    filled: true,
                    icon: Icon(Icons.whatshot_rounded),
                    hintText: "Enter team 1 name",
                    labelText:
                    "Team 1",
                  ),
                  onChanged: (value) {
                    // person.name = value;
                    newMatch.setTeam1Name(value);
                  },
                  validator: (value){
                   if (value.isEmpty) {
                      return 'Enter last Name';
                    }
                   return null;
                      },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.sports_baseball_sharp),
                    hintText: "Enter team 2 name",
                    labelText: "Team 2",
                    // prefixText: '+1 ',
                  ),
                  // keyboardType: TextInputType.phone,

                  onChanged: (value) {
                    newMatch.setTeam2Name(value);
                  },
                  // TextInputFormatters are applied in sequence.
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.create),
                    hintText: "Players in one team",
                    labelText:
                    "Players Count",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    newMatch.setPlayerCount(int.parse(value));
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: const Icon(Icons.sports_handball),
                    hintText: "Number of overs",
                    labelText:
                    "Overs Count",
                  ),
                  keyboardType: TextInputType.number,
                  // onEditingComplete: ,
                  onChanged: (value) {
                    newMatch.setOverCount(int.parse(value));
                    print("OVER COUNTTTTTTT:: $value");
                  },
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: Icon(Icons.location_on),
                    hintText: "Enter Location",
                    labelText:
                    "Match Location",
                  ),
                  // onEditingComplete: ,
                  onChanged: (value) {
                    newMatch.setLocation(value);
                    print("Location:: $value");
                  },
                ),
                sizedBoxSpace,
                Center(
                  child: MaterialButton(
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.black12,
                    child: Text(
                        "Create Match"),
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
