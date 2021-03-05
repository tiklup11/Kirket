import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/widgets/admin_card.dart';
import 'package:umiperer/widgets/back_button_widget.dart';

///mqd
// final liveMatchesRef = FirebaseFirestore.instance.collection('liveMatchesData');

class AdminAccessPage extends StatefulWidget {

  AdminAccessPage({this.user,});

  // final CricketMatch match;
  final User user;

  @override
  _AdminAccessPageState createState() => _AdminAccessPageState();
}

class _AdminAccessPageState extends State<AdminAccessPage> {

  String matchUID;
  String creatorUID = "V3lwRvXi2pXYFOnaA9JAC2lgvY42";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CustomBackButton(),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Admin Access',style: TextStyle(color: Colors.black),),
      ),
      body: matchesData(),
    );
  }

  Widget matchesData(){
     //sourabhUID

   return StreamBuilder<QuerySnapshot>(
                stream: matchesRef.snapshots(),
                builder: (context,snapshot){

                  if(!snapshot.hasData){
                    return Container(child: Center(child: CircularProgressIndicator()),);
                  }else{

                    List<AdminCard> listOfAllMatches = [];

                    final allMatchData = snapshot.data.docs;

                    allMatchData.forEach((match) {
                      print("Admin ");
                      CricketMatch cricketMatch = CricketMatch();

                      cricketMatch.setMatchId(match.id);
                      final matchData = match.data();

                      final team1Name = matchData['team1name'];
                      final team2Name = matchData['team2name'];
                      final isLive = matchData['isLive'];

                      cricketMatch.setTeam1Name(team1Name);
                      cricketMatch.setTeam2Name(team2Name);
                      cricketMatch.isMatchLive = isLive;

                      listOfAllMatches.add(AdminCard(match: cricketMatch,creatorUID: creatorUID,));
                    });

                    return ListView.builder(
                        itemCount: listOfAllMatches.length,
                        itemBuilder: (context,index){
                          return listOfAllMatches[index];
                        });
                  }
                });
  }
}
