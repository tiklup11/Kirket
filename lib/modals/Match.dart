import 'package:umiperer/screens/profile_page.dart';

class Match{

  Match();

  String _team1Name;
  String _team2Name;
  int _oversCount;
  int _playersCount;
  String _matchId;

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