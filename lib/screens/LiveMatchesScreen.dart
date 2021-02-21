import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/live_match_card.dart';

///mqd
final liveMatchesRef = FirebaseFirestore.instance.collection('liveMatchesData');

class LiveMatchesScreen extends StatefulWidget {
  @override
  _LiveMatchesScreenState createState() => _LiveMatchesScreenState();
}

class _LiveMatchesScreenState extends State<LiveMatchesScreen> {

  @override
  Widget build(BuildContext context) {
    return buildCards();
  }

  buildCards(){

    final userId =  "V3lwRvXi2pXYFOnaA9JAC2lgvY42"; //sourabhUID
    // '4VwUugdc6XVPJkR2yltZtFGh4HN2'; //pulkitUID
            return StreamBuilder<QuerySnapshot>(
                stream: usersRef.doc(userId).collection('createdMatches').where('isLive',isEqualTo: true).snapshots(),
                builder: (context,snapshot){

                  if(!snapshot.hasData){
                    return Container(child: CircularProgressIndicator(),);
                  }else{
                    List<LiveMatchCard> listOfLiveMatches = [];

                    final allMatchData = snapshot.data.docs;

                    if(allMatchData.isEmpty){
                      return ZeroDocScreen(iconData: Icons.live_tv_rounded,textMsg: "Live matches score will be displayed here",);
                    }

                    allMatchData.forEach((match) {

                      final matchId = match.id;
                      CricketMatch cricketMatch = CricketMatch();

                      final matchData = match.data();

                    ///getting data from firebase and setting it to the CricketMatch object
                    final team1Name = matchData['team1name'];
                    final team2Name = matchData['team2name'];
                    final oversCount = matchData['overCount'];
                    // final matchId = matchData['matchId'];
                    final playerCount = matchData['playerCount'];
                    final tossWinner = matchData['tossWinner'];
                    final batOrBall = matchData['whatChoose'];
                    final location = matchData['matchLocation'];
                    final isMatchStarted = matchData['isMatchStarted'];
                    final currentOverNumber = matchData['currentOverNumber'];
                    final firstBattingTeam = matchData['firstBattingTeam'];
                    final firstBowlingTeam = matchData['firstBowlingTeam'];
                    final secondBattingTeam = matchData['secondBattingTeam'];
                    final secondBowlingTeam = matchData['secondBowlingTeam'];
                    final isFirstInningStarted = matchData['isFirstInningStarted'];
                    final isFirstInningEnd = matchData['isFirstInningEnd'];
                    final isSecondStartedYet = matchData['isSecondStartedYet'];
                    final isSecondInningEnd = matchData['isSecondInningEnd'];
                    final totalRunsOfInning1 = matchData['totalRunsOfInning1'];
                    final totalRunsOfInning2 = matchData['totalRunsOfInning2'];
                    final totalWicketsOfInning1 = matchData['totalWicketsOfInning1'];
                    final totalWicketsOfInning2 = matchData['totalWicketsOfInning2'];
                    final nonStriker = matchData['nonStrikerBatsmen'];
                    final striker = matchData['strikerBatsmen'];
                    final inningNo = matchData['inningNumber'];
                    final currentBallNo = matchData['currentBallNo'];
                    final winningMsg = matchData['winningMsg'];

                    cricketMatch.nonStrikerBatsmen = nonStriker;
                    cricketMatch.strikerBatsmen = striker;

                    cricketMatch.winningMsg = winningMsg;

                    cricketMatch.isSecondInningEnd = isSecondInningEnd;
                    cricketMatch.isSecondInningStartedYet = isSecondStartedYet;
                    cricketMatch.isFirstInningEnd = isFirstInningEnd;
                    cricketMatch.isFirstInningStartedYet = isFirstInningStarted;


                    cricketMatch.totalRunsOf1stInning = totalRunsOfInning1;
                    cricketMatch.totalRunsOf2ndInning = totalRunsOfInning2;
                    cricketMatch.totalWicketsOf1stInning = totalWicketsOfInning1;
                    cricketMatch.totalWicketsOf2ndInning = totalWicketsOfInning2;

                    cricketMatch.firstBattingTeam = firstBattingTeam;
                    cricketMatch.firstBowlingTeam = firstBowlingTeam;
                    cricketMatch.secondBattingTeam = secondBattingTeam;
                    cricketMatch.secondBowlingTeam = secondBowlingTeam;
                    cricketMatch.setInningNo(inningNo);
                    cricketMatch.setMatchId(matchId);


                    final totalRuns = matchData['totalRuns'];
                    final wicketsDown = matchData['wicketsDown'];

                      cricketMatch.totalRuns = totalRuns;
                      cricketMatch.wicketDown=wicketsDown;

                    if (firstBattingTeam != null &&
                        firstBowlingTeam != null &&
                        secondBattingTeam != null &&
                        secondBowlingTeam != null) {
                      cricketMatch.setFirstInnings();
                    }

                    cricketMatch.currentOver.setCurrentOverNo(currentOverNumber);
                    cricketMatch.currentOver.setCurrentBallNo(currentBallNo);
                    cricketMatch.setTeam1Name(team1Name);
                    cricketMatch.setTeam2Name(team2Name);
                    cricketMatch.setMatchId(matchId);
                    cricketMatch.setPlayerCount(playerCount);
                    cricketMatch.setLocation(location);
                    cricketMatch.setTossWinner(tossWinner);
                    cricketMatch.setBatOrBall(batOrBall);
                    cricketMatch.setOverCount(oversCount);
                    cricketMatch.setIsMatchStarted(isMatchStarted);

                    listOfLiveMatches.add(LiveMatchCard(match: cricketMatch,creatorUID: userId,matchUID: matchId,));
                    });

                    return ListView.builder(
                        itemCount: listOfLiveMatches.length,
                        itemBuilder: (context,index){
                      return listOfLiveMatches[index];
                    });
                  }

                });
          }
  }




