import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:umiperer/main.dart';

class DatabaseController {
  /*when updating any thing we will these doc refs,
   * 
   */
  static DocumentReference getScoreBoardDocRef({String matchId, int inningNo}) {
    return matchesRef
        .doc(matchId)
        .collection("Inning$inningNo")
        .doc("scoreBoardData");
  }

  static DocumentReference getGeneralMatchDoc({String matchId}) {
    return matchesRef.doc(matchId);
  }

  static DocumentReference getOverDoc(
      {String matchId, int inningNo, int overNo}) {
    return matchesRef
        .doc(matchId)
        .collection("inning${inningNo}overs")
        .doc("over$overNo");
  }

  static DocumentReference getBatsmenDocRef(
      {int inningNo, String matchId, String batsmenName}) {
    return matchesRef
        .doc(matchId)
        .collection("${inningNo}InningBattingData")
        .doc(batsmenName);
  }

  static DocumentReference getBowlerDocRef(
      {int inningNo, String matchId, String bowlerName}) {
    return matchesRef
        .doc(matchId)
        .collection("${inningNo}InningBowlingData")
        .doc(bowlerName);
  }

  /*
   * collection ref gives all docs under that collection,
   * later when we use streamBuilder we will use these refs
   * for getting snapshots 
   */
  static CollectionReference getBatsmenCollRef({int inningNo, String matchId}) {
    print('Inning: $inningNo');
    print('id: $matchId');
    return matchesRef.doc(matchId).collection('${inningNo}InningBattingData');
  }

  static CollectionReference getBowlersCollRef({int inningNo, String matchId}) {
    return matchesRef.doc(matchId).collection('${inningNo}InningBowlingData');
  }

  static CollectionReference getOversCollRef({int inningNo, String matchId}) {
    return matchesRef.doc(matchId).collection('inning${inningNo}overs');
  }

  static void deleteMatch(
      {@required String matchId, @required String catName}) async {
    ///when we delete a collection,
    ///inner collections are not deleted, so we have to delete inner collections also

    categoryRef.doc(catName).update({"count": FieldValue.increment(-1)});

    final batsmen1Ref =
        await matchesRef.doc(matchId).collection("1InningBattingData").get();
    for (var docs in batsmen1Ref.docs) {
      docs.reference.delete();
    }

    final batsmen2Ref =
        await matchesRef.doc(matchId).collection("2InningBattingData").get();
    for (var docs in batsmen2Ref.docs) {
      docs.reference.delete();
    }

    final bowler1Ref =
        await matchesRef.doc(matchId).collection("1InningBowlingData").get();
    for (var docs in bowler1Ref.docs) {
      docs.reference.delete();
    }

    final bowler2Ref =
        await matchesRef.doc(matchId).collection("2InningBowlingData").get();
    for (var docs in bowler2Ref.docs) {
      docs.reference.delete();
    }

    matchesRef
        .doc(matchId)
        .collection("Inning1")
        .doc("scoreBoardData")
        .delete();

    matchesRef
        .doc(matchId)
        .collection("Inning2")
        .doc("scoreBoardData")
        .delete();

    final overs1Ref =
        await matchesRef.doc(matchId).collection("inning1overs").get();
    for (var docs in overs1Ref.docs) {
      docs.reference.delete();
    }

    final overs2Ref =
        await matchesRef.doc(matchId).collection("inning2overs").get();
    for (var docs in overs2Ref.docs) {
      docs.reference.delete();
    }

    final chatCollection =
        await matchesRef.doc(matchId).collection("chatData").get();
    for (var docs in chatCollection.docs) {
      docs.reference.delete();
    }

    matchesRef.doc(matchId).delete();
  }
}
