

import 'package:flutter/cupertino.dart';

class CricketMatch{

  CricketMatch({@required this.matchStatus});

  String _team1Name;
  String _team2Name;
  int _oversCount;
  int _playersCount;
  String _matchId;
  String _location;

  String _tossWinner;
  String _chooseToBatOrBall;

  //this will decide weather match is []
  String matchStatus;

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