import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umiperer/modals/Match.dart';


final userRef = FirebaseFirestore.instance.collection('users');

class DataStreams{

  DataStreams({this.match,this.user});

  final CricketMatch match;
  final User user;


  Stream<DocumentSnapshot> getGeneralMatchDataStream(){
    ///this contain following generalMatch data:
    ///currentBatsmen1 [onStrike]
    ///currentBatsmen2
    ///currentBowler
    ///currentBattingTeam
    ///currentBowlingTeam
    ///firstBattingTeam
    ///firstBowlingTeam
    ///secondBowlingTeam
    ///secondBattingTeam
    ///inningNumber
    ///isMatchStarted
    ///matchId
    ///overCount
    ///playerCount
    ///team1name
    ///team2name
    ///teamAPlayers
    ///teamBPlayers
    ///timeStamp
    ///tossWinner
    ///whatChoose [byWinningTossTeam]
    Stream<DocumentSnapshot> generalMatchDataStream;
    generalMatchDataStream =  userRef.doc(user.uid).collection('createdMatches').doc(match.getMatchId()).snapshots();
    return generalMatchDataStream;
  }

  ///firstInning>scoreBoardData or secondInning>scoreBoardData
  Stream<DocumentSnapshot> getCurrentInningScoreBoardDataStream(){
    if(match.getInningNo()==1){

      Stream<DocumentSnapshot> firstInningDataStream = userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('FirstInning')
          .doc("scoreBoardData").snapshots();

    return firstInningDataStream;
    } else{

      Stream<DocumentSnapshot> secondInningDataStream = userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('SecondInning')
          .doc("scoreBoardData").snapshots();

      return secondInningDataStream;
    }
  }

  ///getting particular over data
  Stream<DocumentSnapshot> getFullOverDataStream({int overNumber}){
    if(match.getInningNo()==1){
      Stream<DocumentSnapshot> getOversData1 = userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('inning1overs')
          .doc("over$overNumber")
          .snapshots();
      return getOversData1;
    }
    else{
      Stream<DocumentSnapshot> getOversData2 = userRef.doc(user.uid).
      collection('createdMatches')
          .doc(match.getMatchId())
          .collection('inning2overs')
          .doc("over$overNumber")
          .snapshots();
      return getOversData2;
    }
  }

  ///getting particularBatsmenData
  Stream<DocumentSnapshot> getBatsmenDataStream({String batsmenName}){
    if(match.getInningNo()==1){
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('FirstInning')
          .doc("BattingTeam")
          .collection("Players")
          .doc(batsmenName)
          .snapshots();

      return batsmenStream;
    }
    else{
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('SecondInning')
          .doc("BattingTeam")
          .collection("Players")
          .doc(batsmenName)
          .snapshots();

      return batsmenStream;
    }
  }

  Stream<DocumentSnapshot> getBowlerDataStream({String bowlerName}){
    if(match.getInningNo()==1){
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('FirstInning')
          .doc("BowlingTeam")
          .collection("Players")
          .doc(bowlerName)
          .snapshots();

      return batsmenStream;
    }
    else{
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(user.uid)
          .collection('createdMatches')
          .doc(match.getMatchId())
          .collection('SecondInning')
          .doc("BowlingTeam")
          .collection("Players")
          .doc(bowlerName)
          .snapshots();

      return batsmenStream;
    }
  }

















}