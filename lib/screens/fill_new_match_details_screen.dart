import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/new_category_dialog.dart';
import 'package:uuid/uuid.dart';

///media querydone

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
        newMatch.getOverCount().toString()!='' && newMatch.getPlayerCount().toString()!='' &&
        newMatch.getTeam1Name()!='' && newMatch.getTeam2Name()!='' && newMatch.getLocation()!='' ) {
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


    ///making everyOver doc inside Overs Collections inside first innings collections
    for(int i=0;i<newMatch.getOverCount();i++){

      var completeOverData = {"1":null,"2":null,"3":null,"4":null,"5":null,"6":null};

      matchesRef.doc(newMatch.getMatchId()).collection('inning1overs')
          .doc("over${i+1}").set({
        "overNo": i+1,
        "currentBall": 1,
        "fullOverData":completeOverData,
        "isThisCurrentOver":false,
        "bowlerName":null,
        "overLength":6
      });

      matchesRef.doc(newMatch.getMatchId()).collection('inning2overs')
          .doc("over${i+1}").set({
        "overNo": i+1,
        "currentBall": 1,
        "fullOverData":completeOverData,
        "isThisCurrentOver":false,
        "bowlerName":null,
        "overLength":6

      });
    }

    ///matchDoc > FirstInningCollection > scoreBoardDataDoc >
    matchesRef.doc(newMatch.getMatchId())
        .collection('FirstInning').doc('scoreBoardData').set({
      "ballOfTheOver":0,
      "currentOverNo":0,
      "totalRuns":0,
      "wicketsDown":0,
      // "dummyBallOfTheOver":0,
    });

    matchesRef.doc(newMatch.getMatchId())
        .collection('SecondInning').doc('scoreBoardData').set({
      "ballOfTheOver":0,
      "currentOverNo":0,
      "totalRuns":0,
      "wicketsDown":0,
      // "dummyBallOfTheOver":0,
    });

    matchesRef.doc(newMatch.getMatchId()).set({

      'creatorUid':widget.user.uid,
      'isFirstInningStarted':false,
      'isFirstInningEnd':false,
      'isSecondStartedYet':false,
      "isSecondInningEnd":false,
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
      'totalRunsOfCurrentInning': 0,
      'totalWicketsOfInning1':0,
      'totalWicketsOfInning2':0,
      'totalRunsOfInning1':0,
      'totalRunsOfInning2':0,
      'currentBallNo': 0,
      'realBallNo':0,
      'winningMsg':null,
      'isLive':false,
      'isLiveChatOn':true,
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
     final sizedBoxSpace = SizedBox(height: (24*SizeConfig.oneH).roundToDouble());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text("Fill Match Details",style: TextStyle(color: Colors.black),),
      ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: (16*SizeConfig.oneW).roundToDouble()),
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                sizedBoxSpace,
                TextFormField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(),
                    icon: Icon(Icons.whatshot_rounded,),
                    hintText: "Enter team 1 name",
                    labelText:
                    "Team 1",
                  ),
                  onChanged: (value) {
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
                    border: new OutlineInputBorder(),
                    icon: Icon(Icons.sports_baseball_sharp,),
                    hintText: "Enter team 2 name",
                    labelText: "Team 2",
                  ),
                  onChanged: (value) {
                    newMatch.setTeam2Name(value);
                  },
                ),
                sizedBoxSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  SizedBox(
                    width: SizeConfig.setWidth(180),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(),
                        icon: Icon(Icons.create),
                        hintText: "Players in one team",
                        labelText:
                        "Players Count",
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        newMatch.setPlayerCount(int.parse(value));
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: SizeConfig.setWidth(140),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: new OutlineInputBorder(),
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
                  ),
                  ],
                ),
                sizedBoxSpace,
                TextFormField(
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(),
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
                categoryWidget(),
                sizedBoxSpace,
                createMatchBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _currentSelectedValue;

  categoryWidget(){

    var _currencies = [
      "Create new Category",
      "AKPL",
      "Karhi Local",
      "College"
    ];

    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Select a Category",
            icon: Icon(Icons.category_outlined),
              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
              hintText: 'Please select expense',
              border: OutlineInputBorder(),
          ),
          isEmpty: _currentSelectedValue == "",
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _currentSelectedValue,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _currentSelectedValue = newValue;
                  state.didChange(newValue);
                  if(newValue=="Create new Category"){
                    openCreateNewCategoryDialog();
                  }
                });
              },
              items: _currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  openCreateNewCategoryDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return CreateNewCategoryDialog(
            areWeAddingBatsmen: true,
            user: widget.user,
          );
        });
  }

  createMatchBtn(){
    return Bounce(
      onPressed: (){
        _handleSubmitted();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12,width: 2)
        ),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.setWidth(100)),
        height: SizeConfig.setHeight(40),
        child: Center(
          child: Text(
              "Create Match"),
        ),
      ),
    );
  }
}
