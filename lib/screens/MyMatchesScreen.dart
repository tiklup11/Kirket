import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/screens/fill_new_match_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/widgets/match_card_for_my_matches.dart';
import 'package:umiperer/widgets/match_card_view.dart';

final usersRef = FirebaseFirestore.instance.collection('users');


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
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _modalBottomSheetMenu(context);
             print("FAB pressed");
            },
            child: Icon(Icons.add),
          ),
          body: matchListView(context),
        ),
    );
  }

  Widget matchListView(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
        stream: usersRef.doc(widget.user.uid).collection('createdMatches').orderBy('timeStamp',descending: true).snapshots(),
        builder: (context, snapshot){

          if(!snapshot.hasData){
            return CircularProgressIndicator();
          } else{
            final List<MatchCardForCounting> matchCards = [];
            final matchesData = snapshot.data.docs;
            for(var matchData in matchesData){

              final team1Name = matchData.data()['team1name'];
              final team2Name = matchData.data()['team2name'];
              // final oversCount = matchData.data()['oversCount'];
              final matchId = matchData.data()['matchId'];

              final CricketMatch match = CricketMatch(matchStatus: STATUS_MY_MATCH);
              match.setTeam1Name(team1Name);
              match.setTeam2Name(team2Name);
              match.setMatchId(matchId);

              matchCards.add(MatchCardForCounting(match: match));
            }

            return ListView.builder(
                itemCount: matchCards.length,
                itemBuilder: (context, int){
              return matchCards[int];
            }
            );
          }

        });
  }

  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: 120.0,
            color: Color(0xFF737373),
            // color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0))),
                child: Column(
                  children: [
                    FlatButton(
                      minWidth: double.infinity,
                        child: Text("Create match"),
                        onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return FillNewMatchDetailsPage(user: widget.user);
                        }));
                      print("pressed");
                    }),
                    FlatButton(
                        child: Text("Create Tournament"),
                        onPressed: (){
                          print("pressed");
                        }),
                  ],
                )),
          );
        }
    );
  }
}
