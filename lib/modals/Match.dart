

import 'package:flutter/cupertino.dart';
import 'package:umiperer/modals/CricketOver.dart';

class CricketMatch{

  CricketMatch({@required this.matchStatus,

  });

  String _team1Name;
  String _team2Name;
  int _oversCount;
  int _playersCount;

  CricketOver currentOver = CricketOver();
  String _matchId;
  String _location;
  bool _isMatchStarted;
  bool isFirstOverStarted;
  String _tossWinner;
  String _chooseToBatOrBall;
  //this will decide weather match is []
  String matchStatus;

  String firstBattingTeam;
  String firstBowlingTeam;

  String secondBattingTeam;
  String secondBowlingTeam;

  String currentBowler;
  String currentBatsmen1;
  String currentBatsmen2;

  List<String> team1List=[];
  List<String> team2List=[];

  setFirstInnings() {
    if ( ((getTossWinner() == getTeam1Name()) && (getChoosedOption() == "Bat")))
    {
      firstBattingTeam = getTeam1Name();
      firstBowlingTeam = getTeam2Name();

      secondBowlingTeam = getTeam1Name();
      secondBattingTeam = getTeam2Name();

    } else if(((getTossWinner() == getTeam2Name()) && (getChoosedOption() == "Bowl")))
    {
      firstBattingTeam = getTeam1Name();
      firstBowlingTeam = getTeam2Name();

      secondBowlingTeam = getTeam1Name();
      secondBattingTeam = getTeam2Name();

    } else if(((getTossWinner() == getTeam1Name()) && (getChoosedOption() == "Bowl"))){
      firstBattingTeam = getTeam2Name();
      firstBowlingTeam=getTeam1Name();

      secondBowlingTeam = getTeam2Name();
      secondBattingTeam = getTeam1Name();
    }
     else if(((getTossWinner() == getTeam2Name()) && (getChoosedOption() == "Bat"))){
      firstBattingTeam = getTeam2Name();
      firstBowlingTeam=getTeam1Name();

      secondBowlingTeam = getTeam2Name();
      secondBattingTeam = getTeam1Name();
    }
  }


  List<String> getTeam1List(){
    return team1List;
  }

  List<String> getTeam2List(){
    return team2List;
  }

  bool getIsMatchStarted(){
    return _isMatchStarted;
  }

  void setIsMatchStarted(bool value){
    _isMatchStarted=value;
  }

  String getLocation(){
    return _location;
  }

  void setLocation(String value){
    _location=value;
  }

  String getTossWinner(){
    return _tossWinner;
  }

  void setTossWinner(String value){
    _tossWinner=value;
  }

  String getChoosedOption(){
    return _chooseToBatOrBall;
  }

  void setBatOrBall(String value){
    _chooseToBatOrBall=value;
  }

  void setIsMatchLive(String value){
    matchStatus = value;
  }

  String getIsMatchLive(){
    return matchStatus;
  }

  void setMatchId(String value){
    _matchId = value;
  }

  String getMatchId(){
    return _matchId;
  }

  void setTeam1Name(String value) {
    _team1Name = value;
  }

  String getTeam1Name(){
    return _team1Name;
  }

  String getTeam2Name(){
    return _team2Name;
  }

  void setTeam2Name(String value){
    _team2Name = value;
  }

  int getOverCount(){
    return _oversCount;
  }

  void setOverCount(int value){
    _oversCount = value;
  }

  int getPlayerCount(){
    return _playersCount;
  }
  void setPlayerCount(int value){
    _playersCount = value;
  }

  ///matchStatus will display the match is for LIVE score
  // String matchStatus;


}