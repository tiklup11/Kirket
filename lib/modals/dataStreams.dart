import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';



final userRef = FirebaseFirestore.instance.collection('users');

class DataStreams{

  DataStreams({this.matchId,this.userUID});

  final String matchId;
  final String userUID;


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
    generalMatchDataStream =  userRef.doc(userUID).collection('createdMatches').doc(matchId).snapshots();
    return generalMatchDataStream;
  }

  ///firstInning>scoreBoardData or secondInning>scoreBoardData
  Stream<DocumentSnapshot> getCurrentInningScoreBoardDataStream(
      {@required int inningNo}){
    if(inningNo==1){

      Stream<DocumentSnapshot> firstInningDataStream = userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData").snapshots();

    return firstInningDataStream;
    } else{

      Stream<DocumentSnapshot> secondInningDataStream = userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData").snapshots();

      return secondInningDataStream;
    }
  }

  ///getting particular over data
  Stream<DocumentSnapshot> getFullOverDataStream({int inningNo,int overNumber}){

      Stream<DocumentSnapshot> getOversData1 = userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('inning${inningNo}overs')
          .doc("over$overNumber")
          .snapshots();
      return getOversData1;


  }

  ///getting particularBatsmenData
  Stream<DocumentSnapshot> getBatsmenDataStream({String batsmenName,@required int inningNo}){
    if(inningNo==1){
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("BattingTeam")
          .collection("Players")
          .doc(batsmenName)
          .snapshots();

      return batsmenStream;
    }
    else{
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("BattingTeam")
          .collection("Players")
          .doc(batsmenName)
          .snapshots();

      return batsmenStream;
    }
  }

  Stream<DocumentSnapshot> getBowlerDataStream({String bowlerName,@required int inningNo}){
    if(inningNo==1){
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("BowlingTeam")
          .collection("Players")
          .doc(bowlerName)
          .snapshots();

      return batsmenStream;
    }
    else{
      Stream<DocumentSnapshot> batsmenStream =  userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("BowlingTeam")
          .collection("Players")
          .doc(bowlerName)
          .snapshots();

      return batsmenStream;
    }
  }

  //change to something else
  Stream<DocumentSnapshot> thatOverDocsStream({int inningNumber, int overNumber}){

      final allOversDocStream =  userRef.doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('inning{$inningNumber}overs')
          .doc("over$overNumber")
          .snapshots();

      return allOversDocStream;
  }


  Stream<QuerySnapshot> batsmenData({int inningNumber}){
    final inningBattingData =  userRef.doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${inningNumber}InningBattingData').snapshots();
    return inningBattingData;
  }

  Stream<QuerySnapshot> bowlersData({int inningNumber}){
    final inningBattingData =  userRef.doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${inningNumber}InningBowlingData').snapshots();

    return inningBattingData;
  }
}