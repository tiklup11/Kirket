

class CricketOver{

  CricketOver();

  String _bowlerName;
  String _batsmen1Name;
  String _batsmen2Name;
  int _overNumber;
  int _currentBallNumber=1; //we may just change it becoz of baby overs
  bool _isBatsmen1onStrike;



  void setBowlerName(String value){_bowlerName=value;}

  String getBowlerName(){return _bowlerName;}

  void setBatsmen1Name(String value){_batsmen1Name=value;}

  String getBatsmen1Name(){return _batsmen1Name;}

  void setBatsmen2Name(String value){_batsmen2Name=value;}

  String getBatsmen2Name(){return _batsmen2Name;}

  void isBatmen1onStrike(bool value){_isBatsmen1onStrike=value;}

  bool getIsBatmen1onStrike(){return _isBatsmen1onStrike;}

  int getCurrentBallNo(){return _currentBallNumber;}

  void setCurrentBallNo(int value){_currentBallNumber=value;}

  int getCurrentOverNo(){return _overNumber;}

  void setCurrentOverNo(int value){_overNumber=value;}
}