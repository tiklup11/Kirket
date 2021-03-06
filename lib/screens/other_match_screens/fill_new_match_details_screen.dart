import 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, QuerySnapshot;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:provider/provider.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CategoryController.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/new_category_dialog.dart';
import 'package:uuid/uuid.dart';

///media querydone
class FillNewMatchDetailsPage extends StatelessWidget {
  FillNewMatchDetailsPage({this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return MatchDetailsForm(
      user: user,
    );
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
  String selectedCat;

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
    if (newMatch.getOverCount() != null &&
        newMatch.getPlayerCount() != null &&
        newMatch.getTeam1Name() != null &&
        newMatch.getTeam2Name() != null &&
        newMatch.getLocation() != null &&
        newMatch.getOverCount().toString() != '' &&
        newMatch.getPlayerCount().toString() != '' &&
        newMatch.getTeam1Name() != '' &&
        newMatch.getTeam2Name() != '' &&
        newMatch.getLocation() != '' &&
        selectedCat != null &&
        selectedCat != "Create new Category" &&
        selectedCat.trim().length != 0) {
      generateIdForMatch();
      //Upload Match Details on firebase
      uploadMatchDataToCloud();
      increamentCatCount(selectedCat);
      //2. Navigate to a screen and pass Match
      Navigator.pop(context);
    } else {
      showInSnackBar(
        "Please fill all details",
      );
    }
  }

  //in the category collection, we are counting no of matches
  //in that particular category
  increamentCatCount(String catName) async {
    categoryRef.doc(catName).update({
      "count": FieldValue.increment(1),
    });
  }

  generateIdForMatch() {
    final String matchId = uuid.v1();
    newMatch.setMatchId(matchId);
  }

  uploadMatchDataToCloud() {
    for (int i = 0; i < newMatch.getOverCount(); i++) {
      var completeOverData = {
        "1": null,
        "2": null,
        "3": null,
        "4": null,
        "5": null,
        "6": null
      };

      matchesRef
          .doc(newMatch.getMatchId())
          .collection('inning1overs')
          .doc("over${i + 1}")
          .set({
        "overNo": i + 1,
        "currentBall": 1,
        "fullOverData": completeOverData,
        "isThisCurrentOver": false,
        "bowlerName": null,
        "overLength": 6
      });

      matchesRef
          .doc(newMatch.getMatchId())
          .collection('inning2overs')
          .doc("over${i + 1}")
          .set({
        "overNo": i + 1,
        "currentBall": 1,
        "fullOverData": completeOverData,
        "isThisCurrentOver": false,
        "bowlerName": null,
        "overLength": 6
      });
    }

    ///matchDoc > FirstInningCollection > scoreBoardDataDoc >
    matchesRef
        .doc(newMatch.getMatchId())
        .collection('Inning1')
        .doc('scoreBoardData')
        .set({
      "ballOfTheOver": 0,
      "currentOverNo": 0,
      "totalRuns": 0,
      "wicketsDown": 0,
      'strikerBatsmen': null,
      'nonStrikerBatsmen': null,
      'currentBowler': null,
      "dummyBallOfTheOver": 0,
    });

    matchesRef
        .doc(newMatch.getMatchId())
        .collection('Inning2')
        .doc('scoreBoardData')
        .set({
      "ballOfTheOver": 0,
      "currentOverNo": 0,
      "totalRuns": 0,
      "wicketsDown": 0,
      'strikerBatsmen': null,
      'nonStrikerBatsmen': null,
      'currentBowler': null,
      "dummyBallOfTheOver": 0,
      "totalRunsOfInning1": 0,
    });

    matchesRef.doc(newMatch.getMatchId()).set({
      'creatorUid': widget.user.uid,
      'isFirstInningStarted': false,
      'isFirstInningEnd': false,
      'isSecondStartedYet': false,
      "isSecondInningEnd": false,
      'matchId': newMatch.getMatchId(),
      'team1name': newMatch.getTeam1Name(),
      'team2name': newMatch.getTeam2Name(),
      'overCount': newMatch.getOverCount(),
      'playerCount': newMatch.getPlayerCount(),
      'matchLocation': newMatch.getLocation(),
      'timeStamp': DateTime.now(),
      'tossWinner': null,
      'whatChoose': null, //bat or ball
      'isMatchStarted': false,
      'inningNumber': 1,
      'winningMsg': null,
      'isLive': false,
      'isLiveChatOn': true,
      'cat': selectedCat,
    });
  }

  @override
  void initState() {
    super.initState();
    newMatch = CricketMatch();
  }

  @override
  Widget build(BuildContext context) {
    final sizedBoxSpace =
        SizedBox(height: (24 * SizeConfig.oneH).roundToDouble());

    return Consumer<CategoryController>(
      builder: (_, categoryController, child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(
            "Fill Match Details",
            style: TextStyle(color: Colors.black),
          ),
        ),
        key: _scaffoldKey,
        body: Form(
          key: _formKey,
          child: Scrollbar(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: (16 * SizeConfig.oneW).roundToDouble()),
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  sizedBoxSpace,
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(),
                      icon: Icon(
                        Icons.whatshot_rounded,
                      ),
                      hintText: "Enter team 1 name",
                      labelText: "Team 1",
                    ),
                    onChanged: (value) {
                      newMatch.setTeam1Name(value);
                    },
                    validator: (value) {
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
                      icon: Icon(
                        Icons.sports_baseball_sharp,
                      ),
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
                            hintText: "in one team",
                            labelText: "Players Number",
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
                            hintText: "in one Inning",
                            labelText: "Total Overs",
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
                      labelText: "Match Location",
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
      ),
    );
  }

  categoryWidget() {
    return Consumer<CategoryController>(
      builder: (_, categoryController, child) => FormField<String>(
        builder: (FormFieldState<String> state) {
          return StreamBuilder<QuerySnapshot>(
              stream: categoryRef
                  .where('creatorUid', isEqualTo: widget.user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                List<String> catList = ['Create new Category'];

                if (!snapshot.hasData) {
                  return Container(
                      child: Center(child: CircularProgressIndicator()));
                } else {
                  final catDocs = snapshot.data.docs;

                  catDocs.forEach((cat) {
                    catList.add(cat.data()['catName']);
                  });
                  print("LIST ----- $catList");

                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Select a Category",
                      icon: Icon(Icons.category_outlined),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      hintText: 'Please select expense',
                      border: OutlineInputBorder(),
                    ),
                    isEmpty: categoryController.selectedCategory == "",
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: categoryController.selectedCategory,
                        onChanged: (String newValue) async {
                          selectedCat = newValue;
                          categoryController.setSelectedCategory(to: newValue);
                          state.didChange(newValue);
                          if (newValue == "Create new Category") {
                            selectedCat = await openCreateNewCategoryDialog();
                          }
                        },
                        items: catList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              });
        },
      ),
    );
  }

  Future openCreateNewCategoryDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return CreateNewCategoryDialog(
            areWeAddingBatsmen: true,
            user: widget.user,
          );
        });
  }

  createMatchBtn() {
    return Bounce(
      onPressed: () {
        _handleSubmitted();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.setWidth(100)),
        height: SizeConfig.setHeight(40),
        child: Center(
          child: Text("Create Match"),
        ),
      ),
    );
  }
}
