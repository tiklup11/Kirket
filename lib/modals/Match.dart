
import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketOver.dart';

class CricketMatch extends ChangeNotifier{

  String _team1Name;
  String _team2Name;
  String category;

  int _oversCount;
  int _playersCount;
  int _inningNumber=1;

  int totalRunsOf1stInning;
  int totalRunsOf2ndInning;
  int totalWicketsOf1stInning;
  int totalWicketsOf2ndInning;
  int totalRuns;
  int wicketDown;

  bool isLiveChatOn;
  bool isMatchLive;


  CricketOver currentOver = CricketOver();
  String _matchId;
  String creatorUid;
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
  String nonStrikerBatsmen;
  String strikerBatsmen;

  String winningMsg;

  bool isFirstInningEnd;
  bool isFirstInningStartedYet;
  bool isSecondInningStartedYet;
  bool isSecondInningEnd;

  List<String> team1List=[];
  List<String> team2List=[];

  int getTotalRunsOf1stInning(){return totalRunsOf1stInning;}
  void setTotalRunsOf1stInning(int val){
    totalRunsOf1stInning=val;
    notifyListeners();
  }

  int getTotalRunsOf2ndInning(){return totalRunsOf2ndInning;}
  void setTotalRunsOf2ndInning(int val){
    totalRunsOf2ndInning=val;
    notifyListeners();
  }

  int getTotalWicketsOf1stInning(){return totalWicketsOf1stInning;}
  void setTotalWicketsOf1stInning(int val){
    totalWicketsOf1stInning=val;
    notifyListeners();
  }

  int getTotalWicketsOf2ndInning(){return totalWicketsOf2ndInning;}
  void setTotalWicketsOf2ndInning(int val){
    totalWicketsOf2ndInning=val;
    notifyListeners();
  }

  String getFinalResult(){

    String resultLine;

    if(totalRunsOf1stInning!=null && totalWicketsOf2ndInning!=null && getInningNo()==2) {
      if (totalRunsOf1stInning > totalRunsOf2ndInning) {
        resultLine =
        "${firstBattingTeam.toUpperCase()} won by ${totalRunsOf1stInning -
            totalRunsOf2ndInning} runs";
        return resultLine;
      }
      if (totalRunsOf1stInning < totalRunsOf2ndInning) {
        resultLine =
        "${secondBattingTeam.toUpperCase()} won by ${getPlayerCount() - 1 -
            totalWicketsOf2ndInning} wickets";
        return resultLine;
      }
    }
    return null;
  }

  String getCurrentBattingTeam(){
    if(getInningNo()==1){
      return firstBattingTeam;
    } else{
      return secondBattingTeam;
    }
  }
  String getCurrentBowlingTeam(){
    if(getCurrentBattingTeam()==getTeam1Name()){
      return getTeam2Name();
    }
    if(getCurrentBattingTeam()==getTeam2Name()){
      return getTeam1Name();
    }
    return null;
  }

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
    notifyListeners();

  }

  List<String> getTeamListByTeamName(String teamName){
    if(teamName==getTeam1Name()){
      return getTeam1List();
    } else {
      return getTeam2List();
    }
  }

  void setInningNo(int value){
    _inningNumber = value;
    notifyListeners();
  }

  int getInningNo(){return _inningNumber;}


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
    notifyListeners();
  }

  String getLocation(){
    return _location;
  }

  void setLocation(String value){
    _location=value;
    notifyListeners();
  }

  String getTossWinner(){
    return _tossWinner;
  }

  void setTossWinner(String value){
    _tossWinner=value;
    notifyListeners();
  }

  String getChoosedOption(){
    return _chooseToBatOrBall;
  }

  void setBatOrBall(String value){
    _chooseToBatOrBall=value;
    notifyListeners();
  }

  void setIsMatchLive(String value){
    matchStatus = value;
    notifyListeners();
  }

  void setMatchId(String value){
    _matchId = value;
    notifyListeners();
  }

  String getMatchId(){
    return _matchId;
  }

  void setTeam1Name(String value){
    _team1Name = value;
    notifyListeners();
  }

  String getTeam1Name(){
    return _team1Name;
  }

  String getTeam2Name(){
    return _team2Name;
  }

  void setTeam2Name(String value){
    _team2Name = value;
    notifyListeners();
  }

  int getOverCount(){
    return _oversCount;
  }

  void setOverCount(int value){
    _oversCount = value;
    notifyListeners();
  }

  int getPlayerCount(){
    return _playersCount;
  }

  void setPlayerCount(int value){
    _playersCount = value;
    notifyListeners();
  }
}