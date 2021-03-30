import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/other_match_screens/fill_new_match_details_screen.dart';
import 'package:umiperer/screens/other_match_screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';

///MQD

class MyMatchesScreen extends StatefulWidget {
  MyMatchesScreen({this.user});
  final User user;

  @override
  _MyMatchesScreenState createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Bounce(
          duration: Duration(milliseconds: 120),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FillNewMatchDetailsPage(
                user: widget.user,
              );
            }));
          },
          child: FloatingActionButton.extended(
            heroTag: "fab",
            label: Text(
              "New Match",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            icon: Icon(Icons.add),
            backgroundColor: Colors.blueAccent.withOpacity(0.7),
            // backgroundColor: Colors.blueAccent.shade400,
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(width: 20,),
                  Text(
                    "Your Matches",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            matchListView(context),
          ],
        ),
      ),
    );
  }

  Widget matchListView(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 14),
        child: StreamBuilder<QuerySnapshot>(
            stream: matchesRef
                .where('creatorUid', isEqualTo: widget.user.uid)
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              } else {
                final List<MatchCardForCounting> matchCards = [];
                final matchesData = snapshot.data.docs;

                if (matchesData.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ZeroDocScreen(
                          showLearnMore: false,
                          dialogText: "You can control the match visiblity",
                          textMsg:
                              "Tab + to create your own match and start scoring.",
                          iconData: Icons.calculate_outlined,
                        ),
                      ),
                    ],
                  );
                }

                for (var matchData in matchesData) {
                  CricketMatch match = CricketMatch.from(matchData);

                  matchCards.add(MatchCardForCounting(
                    match: match,
                    user: widget.user,
                  ));
                }

                return ListView.builder(
                    // physics: ScrollPhysics(),
                    itemCount: matchCards.length,
                    itemBuilder: (context, int) {
                      return matchCards[int];
                    });
              }
            }),
      ),
    );
  }

  fabBtn({Function onPressed, String btnText}) {
    // ignore: missing_required_param
    return Bounce(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        width: double.infinity,
        child: Center(child: Text(btnText)),
      ),
    );
  }

  void _modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: (140 * SizeConfig.oneH).roundToDouble(),
            color: Color(0xFF737373),
            // color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            (8 * SizeConfig.oneW).roundToDouble()),
                        topRight: Radius.circular(
                            (8 * SizeConfig.oneW).roundToDouble()))),
                child: Column(
                  children: [
                    fabBtn(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FillNewMatchDetailsPage(
                              user: widget.user,
                            );
                          }));
                        },
                        btnText: "CREATE MATCH"),
                    fabBtn(
                        onPressed: () {
                          Navigator.pop(context);
                          showAlertDialog(context: context);
                          // print("pressed");
                        },
                        btnText: "CREATE TOURNAMENT")
                  ],
                )),
          );
        });
  }

  showAlertDialog({BuildContext context}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Okays"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Coming soon"),
      content: Text("This feature is coming soon.."),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
