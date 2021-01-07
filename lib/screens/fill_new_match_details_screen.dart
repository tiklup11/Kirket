import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:umiperer/modals/Match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/screens/init_cricket_match_page.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';


final usersRef = FirebaseFirestore.instance.collection('users');

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


    if (newMatch.getOverCount()!=null && newMatch.getPlayerCount()!=null &&
    newMatch.getTeam1Name()!=null && newMatch.getTeam2Name()!=null &&
        newMatch.getOverCount()!='' && newMatch.getPlayerCount()!='' &&
        newMatch.getTeam1Name()!='' && newMatch.getTeam2Name()!=''
    )

    {
      // print('QWWWWWWWWW:::   ${newMatch.getTeam1Name()}');
      generateIdForMatch();
      //TODO: 1.Upload Match Details on firebase
      uploadMatchDataToCloud();
      //2. Navigate to a screen and pass Match
      Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context){
      //   return CounterPage();
      // },
      // ),
      // );
      //TODO: show toast msg instead
      // showInSnackBar("Match Created");

      print('exiting handling sub');
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

    usersRef.doc(widget.user.uid).collection("createdMatches").doc(newMatch.getMatchId()).set({

      'matchId':newMatch.getMatchId(),
      'team1name': newMatch.getTeam1Name(),
      'team2name': newMatch.getTeam2Name(),
      'overCount': newMatch.getOverCount(),
      'playerCount': newMatch.getPlayerCount(),
      'timeStamp': DateTime.now()

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newMatch = CricketMatch(matchStatus: STATUS_MY_MATCH);
  }

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);

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
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                Center(
                  child: RaisedButton(
                    child: Text(
                        "Create Match"),
                    onPressed: (){
                      _handleSubmitted();
                      //TODO: take to SCORE_COUNTER_PAGE
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
