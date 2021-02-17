import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Ball.dart';
import 'package:umiperer/modals/constants.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class RunUpdater {
  RunUpdater({this.matchId, this.userUID, @required this.context,this.setIsUploadingDataToFalse}){
    matchDocReference = userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId);
  }

  final String matchId;
  final String userUID;
  final BuildContext context;
  final Function setIsUploadingDataToFalse;

  DocumentReference matchDocReference;

  //[1,2,3,4,5,6]
  void updateNormalRuns({Ball ballData}) async{

    //1. generalMatchData
    await matchDocReference.update({
      "currentBallNo": FieldValue.increment(1),
      "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
    });

    //2. scoreBoardData
    if(ballData.inningNo==1){
      await matchDocReference.collection('FirstInning').doc("scoreBoardData").update(
          {
            "ballOfTheOver":FieldValue.increment(1),
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }
    if(ballData.inningNo==2){
      await matchDocReference.collection('SecondInning').doc("scoreBoardData").update(
          {
            "ballOfTheOver":FieldValue.increment(1),
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }
    
    //3. batsmenData
    if(ballData.runScoredOnThisBall==6){
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "balls": FieldValue.increment(1),
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
            "noOf6s": FieldValue.increment(1),
          });
    }else if(ballData.runScoredOnThisBall==4){
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "balls": FieldValue.increment(1),
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
            "noOf4s": FieldValue.increment(1),
          });
    }else{
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "balls": FieldValue.increment(1),
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }

    //4.bowlerData
    await matchDocReference.collection('${ballData.inningNo}InningBowlingData').doc(ballData.bowlerName).update(
        {
          "ballOfTheOver": FieldValue.increment(1),
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        });

    //5. particular over data
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
        {
          "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
          "currentBall":FieldValue.increment(1)
        });
    setIsUploadingDataToFalse();

  }

  //bye and legBye
  void updateLegByeAndBye({Ball ballData}) async{

    //1. generalMatchData
    await matchDocReference.update({
      "currentBallNo": FieldValue.increment(1),
      "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
    });

    //2. scoreBoardData
    if(ballData.inningNo==1){
      await matchDocReference.collection('FirstInning').doc("scoreBoardData").update(
          {
            "ballOfTheOver":FieldValue.increment(1),
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }
    if(ballData.inningNo==2){
      await matchDocReference.collection('SecondInning').doc("scoreBoardData").update(
          {
            "ballOfTheOver":FieldValue.increment(1),
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }

    //3. batsmenData
    await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "balls": FieldValue.increment(1),
          });

    //4.bowlerData
    await matchDocReference.collection('${ballData.inningNo}InningBowlingData').doc(ballData.bowlerName).update(
        {
          "ballOfTheOver": FieldValue.increment(1),
        });

    //5. particular over data
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
    {
    "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
    "currentBall":FieldValue.increment(1)
    });
    setIsUploadingDataToFalse();
    return;

  }

  //[NB,wide,overThrow]
  void updateNoBallRuns({Ball ballData}) async{

    //1. generalMatchData
    await matchDocReference.update({
      "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
    });

    //2. scoreBoardData
    if(ballData.inningNo==1){
      await matchDocReference.collection('FirstInning').doc("scoreBoardData").update(
          {
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }
    if(ballData.inningNo==2){
      await matchDocReference.collection('SecondInning').doc("scoreBoardData").update(
          {
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }

    //3. batsmenData
    if(ballData.runScoredOnThisBall==7){
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
            "noOf6s": FieldValue.increment(1),
          });
    }else if(ballData.runScoredOnThisBall==5){
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
            "noOf4s": FieldValue.increment(1),
          });
    }else{
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }

    //4.bowlerData
    await matchDocReference.collection('${ballData.inningNo}InningBowlingData').doc(ballData.bowlerName).update(
        {
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        });

    //5. particular over data
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
        {
          "overLength": FieldValue.increment(1),
          "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
        });
    setIsUploadingDataToFalse();
  }

  void updateWideAndOverThrowRuns({Ball ballData}) async{
    //1. generalMatchData
    await matchDocReference.update({
      "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
      "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
    });

    //2. scoreBoardData
    if(ballData.inningNo==1){
      await matchDocReference.collection('FirstInning').doc("scoreBoardData").update(
          {
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }
    if(ballData.inningNo==2){
      await matchDocReference.collection('SecondInning').doc("scoreBoardData").update(
          {
            "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
          });
    }

    //3. batsmenData
      await matchDocReference.collection('${ballData.inningNo}InningBattingData').doc(ballData.batsmenName).update(
          {
            "runs": FieldValue.increment(ballData.runScoredOnThisBall),
          });

    //4.bowlerData
    await matchDocReference.collection('${ballData.inningNo}InningBowlingData').doc(ballData.bowlerName).update(
        {
          "runs": FieldValue.increment(ballData.runScoredOnThisBall),
        });

    //5. particular over data
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
        {
          "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
          "overLength": FieldValue.increment(1),
        });

    setIsUploadingDataToFalse();
  }

  ///wickets update
  void updateWicket({Ball ballData}) async{

    //1. generalData
    if(ballData.strikerName == ballData.batsmenName){
      await matchDocReference.update({
        "currentBallNo": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
        "totalWicketsOfInning${ballData.inningNo}":FieldValue.increment(1),
        "strikerBatsmen":null,
      });
    }else if(ballData.nonStrikerName==ballData.batsmenName){
      await matchDocReference.update({
        "currentBallNo": FieldValue.increment(1),
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "totalWicketsOfInning${ballData.inningNo}":FieldValue.increment(1),
        "nonStrikerBatsmen":null,
      });
    }

    //2. scoreBoardData
    if (ballData.inningNo == 1) {
      ///updating in SCOREBOARD_DATA
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update({
        "ballOfTheOver": FieldValue.increment(1),
        "wicketsDown":FieldValue.increment(1),
      });
    }else if(ballData.inningNo==2){
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update({"ballOfTheOver": FieldValue.increment(1),
        "wicketsDown":FieldValue.increment(1),
      });
    }

    //3. batsmenData
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${ballData.inningNo}InningBattingData')
        .doc(ballData.batsmenName)
        .update({
      "balls": FieldValue.increment(1),
      "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      "isOut":true,
      "isBatting":false,
      "isOnStrike":false,
    });

    //4. BowlerData
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${ballData.inningNo}InningBowlingData')
        .doc(ballData.bowlerName)
        .update({
      "ballOfTheOver": FieldValue.increment(1),
      "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      "wickets":FieldValue.increment(1),
    });

    //overData
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
        {
          "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
          "currentBall":FieldValue.increment(1)
        });

    setIsUploadingDataToFalse();

  }

  void updateWidePlusStump({Ball ballData}) async{

    //1. generalData
    if(ballData.strikerName == ballData.batsmenName){
      await matchDocReference.update({
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "totalWicketsOfInning${ballData.inningNo}":FieldValue.increment(1),
        "strikerBatsmen":null,
      });
    }else if(ballData.nonStrikerName==ballData.batsmenName){
      await matchDocReference.update({
        "totalRuns": FieldValue.increment(ballData.runScoredOnThisBall),
        "totalRunsOfInning${ballData.inningNo}":FieldValue.increment(ballData.runScoredOnThisBall),
        "wicketsDown": FieldValue.increment(1),
        "totalWicketsOfInning${ballData.inningNo}":FieldValue.increment(1),
        "nonStrikerBatsmen":null,
      });
    }

    //2. scoreBoardData
    if (ballData.inningNo == 1) {
      ///updating in SCOREBOARD_DATA
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('FirstInning')
          .doc("scoreBoardData")
          .update({
        "wicketsDown":FieldValue.increment(1),
      });
    }else if(ballData.inningNo==2){
      await userRef
          .doc(userUID)
          .collection('createdMatches')
          .doc(matchId)
          .collection('SecondInning')
          .doc("scoreBoardData")
          .update({
        "wicketsDown":FieldValue.increment(1),
      });
    }

    //3. batsmenData
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${ballData.inningNo}InningBattingData')
        .doc(ballData.batsmenName)
        .update({
      "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      "isOut":true,
      "isBatting":false,
      "isOnStrike":false,
    });

    //4. BowlerData
    await userRef
        .doc(userUID)
        .collection('createdMatches')
        .doc(matchId)
        .collection('${ballData.inningNo}InningBowlingData')
        .doc(ballData.bowlerName)
        .update({
      "runs": FieldValue.increment(ballData.runScoredOnThisBall),
      "wickets":FieldValue.increment(1),
    });

    //overData
    await matchDocReference.collection('inning${ballData.inningNo}overs').doc("over${ballData.currentOverNo}").update(
        {
          "fullOverData.${ballData.currentBallNo + 1}": ballData.runToShowOnUI,
          "overLength":FieldValue.increment(1)
        });

    setIsUploadingDataToFalse();

  }

}
