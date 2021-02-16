import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/toss_page.dart';
import 'package:umiperer/widgets/admin_card.dart';

final liveMatchesRef = FirebaseFirestore.instance.collection('liveMatchesData');

class AdminAccessPage extends StatefulWidget {

  AdminAccessPage({this.user,});

  // final CricketMatch match;
  final User user;

  @override
  _AdminAccessPageState createState() => _AdminAccessPageState();
}

class _AdminAccessPageState extends State<AdminAccessPage> {

  String matchUID;
  String creatorUID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Access"),),
      body: matchesData(),
    );
  }

  Widget matchesData(){

    return StreamBuilder<QuerySnapshot>(
        stream:liveMatchesRef.snapshots(),
        builder: (context,snapshot){

          if(!snapshot.hasData){return Container(child: CircularProgressIndicator(),);}
          else{

            final liveMatchesData = snapshot.data.docs;

            for (var liveMatchData in liveMatchesData) {
              matchUID = liveMatchData.data()['matchId'];
              creatorUID= liveMatchData.data()['userId'];
            }

            return StreamBuilder<QuerySnapshot>(
                stream: usersRef.doc(creatorUID).collection('createdMatches').snapshots(),
                builder: (context,snapshot){

                  if(!snapshot.hasData){
                    return Container(child: CircularProgressIndicator(),);
                  }else{

                    List<AdminCard> listOfAllMatches = [];

                    final allMatchData = snapshot.data.docs;

                    allMatchData.forEach((match) {
                      CricketMatch cricketMatch = CricketMatch();

                      final matchData = match.data();

                      final team1Name = matchData['team1name'];
                      final team2Name = matchData['team2name'];
                      final isLive = matchData['isLive'];

                      cricketMatch.setTeam1Name(team1Name);
                      cricketMatch.setTeam2Name(team2Name);
                      cricketMatch.isMatchLive = false;

                      listOfAllMatches.add(AdminCard(match: cricketMatch,creatorUID: creatorUID,matchUID: matchUID,));

                    });

                    return ListView.builder(
                        itemCount: listOfAllMatches.length,
                        itemBuilder: (context,index){
                          return listOfAllMatches[index];
                        });
                  }
                });
          }
        });
  }
}
