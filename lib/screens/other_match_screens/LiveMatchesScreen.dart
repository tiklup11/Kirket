import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/screens/other_match_screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/live_match_card.dart';

///mqd

class LiveMatchesScreen extends StatefulWidget {
  LiveMatchesScreen({this.currentUser, this.catName});
  final User currentUser;
  final String catName;

  @override
  _LiveMatchesScreenState createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return buildCards();
  }

  buildCards() {
    final userId = "V3lwRvXi2pXYFOnaA9JAC2lgvY42"; //sourabhUID
    //  '4VwUugdc6XVPJkR2yltZtFGh4HN2'; //pulkitUID
    return StreamBuilder<QuerySnapshot>(
        stream: matchesRef
            .where('cat', isEqualTo: widget.catName)
            .where(
              'isLive',
              isEqualTo: true,
            )
            .where(
              'isSecondInningEnd',
              isEqualTo: false,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: CircularProgressIndicator(),
            );
          } else {
            List<LiveMatchCard> listOfLiveMatches = [];

            final allMatchData = snapshot.data.docs;

            if (allMatchData.isEmpty) {
              print("HELLO");
              return ZeroDocScreen(
                iconData: Icons.live_tv_rounded,
                textMsg:
                    "Live matches scores will be shown here. To create your match, go to MyMatches.",
              );
            }

            allMatchData.forEach((match) {
              final matchId = match.id;

              CricketMatch cricketMatch = CricketMatch.from(match);

              listOfLiveMatches.add(LiveMatchCard(
                currentUser: widget.currentUser,
                match: cricketMatch,
                creatorUID: userId,
                matchUID: matchId,
              ));
            });

            return ListView.builder(
                itemCount: listOfLiveMatches.length,
                itemBuilder: (context, index) {
                  return listOfLiveMatches[index];
                });
          }
        });
  }
}
