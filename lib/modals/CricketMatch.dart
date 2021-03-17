import 'package:cloud_firestore/cloud_firestore.dart';

class CricketMatch {
  String team1Name;
  String team2Name;
  String category;

  int oversCount;
  int playersCount;
  int inningNumber;

  bool isLiveChatOn;
  bool isMatchLive;

  String matchId;
  String creatorUid;
  String location;
  bool isMatchStarted;

  String tossWinner;
  String chooseToBatOrBall;

  factory CricketMatch.from(DocumentSnapshot doc) {
    final data = doc.data();
    return CricketMatch(
        category: data['cat'],
        chooseToBatOrBall: data['whatChoose'],
        creatorUid: data['creatorUid'],
        inningNumber: data['inningNumber'],
        isFirstInningEnd: data['isFirstInningEnd'],
        isFirstInningStartedYet: data['isFirstInningStarted'],
        isMatchLive: data['isLive'],
        isLiveChatOn: data['isLiveChatOn'],
        isMatchStarted: data['isMatchStarted'],
        oversCount: data['overCount'],
        playersCount: data['playerCount'],
        team1Name: data['team1name'],
        team2Name: data['team2name'],
        tossWinner: data['tossWinner'],
        isSecondInningStartedYet: data['isSecondStartedYet'],
        isSecondInningEnd: data['isSecondInningEnd'],
        location: data['matchLocation'],
        matchId: data['matchId'],
        winningMsg: data['winningMsg']);
  }

  CricketMatch({
    this.category,
    this.chooseToBatOrBall,
    this.creatorUid,
    this.inningNumber,
    this.isFirstInningEnd,
    this.isFirstInningStartedYet,
    this.isLiveChatOn,
    this.isMatchLive,
    this.isMatchStarted,
    this.isSecondInningEnd,
    this.isSecondInningStartedYet,
    this.matchId,
    this.location,
    this.oversCount,
    this.playersCount,
    this.team1Name,
    this.team2Name,
    this.tossWinner,
    this.winningMsg,
  });

  String getCurrentBattingTeam() {
    if (inningNumber == 1) {
      return getFirstBattingTeam();
    } else {
      return getSecondBattingTeam();
    }
  }

  String _firstBattingTeam;
  setFirstBattingTeam(String val) {
    _firstBattingTeam = val;
  }

  getFirstBattingTeam() {
    if (getTossWinner() == getTeam1Name() && getChoosedOption() == 'Bat' ||
        getTossWinner() == getTeam2Name() && getChoosedOption() == 'Bowl') {
      _firstBattingTeam = getTeam1Name();
    } else {
      _firstBattingTeam = getTeam2Name();
    }
    return _firstBattingTeam;
  }

  String _firstBowlingTeam;
  setFirstBowlingTeam(String val) {
    _firstBowlingTeam = val;
  }

  getFirstBowlingTeam() {
    if (getTossWinner() == getTeam1Name() && getChoosedOption() == 'Bowl' ||
        getTossWinner() == getTeam2Name() && getChoosedOption() == 'Bat') {
      _firstBowlingTeam = getTeam1Name();
    } else {
      _firstBowlingTeam = getTeam2Name();
    }
    return _firstBowlingTeam;
  }

  String _secondBattingTeam;
  setSecondBattingTeam(String val) {
    _secondBattingTeam = val;
  }

  getSecondBattingTeam() {
    if (getTossWinner() == getTeam1Name() && getChoosedOption() == 'Bat' ||
        getTossWinner() == getTeam2Name() && getChoosedOption() == 'Bowl') {
      _secondBattingTeam = getTeam2Name();
    } else {
      _secondBattingTeam = getTeam1Name();
    }
    return _secondBattingTeam;
  }

  String _secondBowlingTeam;
  setSecondBowlingTeam(String val) {
    _secondBowlingTeam = val;
  }

  getSecondBowlingTeam() {
    if (getTossWinner() == getTeam1Name() && getChoosedOption() == 'Bat' ||
        getTossWinner() == getTeam2Name() && getChoosedOption() == 'Bowl') {
      _secondBowlingTeam = getTeam1Name();
    } else {
      _secondBowlingTeam = getTeam2Name();
    }
    return _secondBowlingTeam;
  }

  String winningMsg;

  bool isFirstInningEnd;
  bool isFirstInningStartedYet;
  bool isSecondInningStartedYet;
  bool isSecondInningEnd;

  List<String> team1List = [];
  List<String> team2List = [];

  String getFinalResult() {
    String resultLine;

    // if (totalRunsOf1stInning != null &&
    //     totalWicketsOf2ndInning != null &&
    //     getInningNo() == 2) {
    //   if (totalRunsOf1stInning > totalRunsOf2ndInning) {
    //     resultLine =
    //         "${firstBattingTeam.toUpperCase()} won by ${totalRunsOf1stInning - totalRunsOf2ndInning} runs";
    //     return resultLine;
    //   }
    //   if (totalRunsOf1stInning < totalRunsOf2ndInning) {
    //     resultLine =
    //         "${secondBattingTeam.toUpperCase()} won by ${getPlayerCount() - 1 - totalWicketsOf2ndInning} wickets";
    //     return resultLine;
    //   }
    // }
    return null;
  }

  String getCurrentBowlingTeam() {
    if (inningNumber == 1) {
      return getFirstBowlingTeam();
    } else {
      return getSecondBowlingTeam();
    }
  }

  setFirstInnings() {
    if (((getTossWinner() == getTeam1Name()) &&
        (getChoosedOption() == "Bat"))) {
      _firstBattingTeam = getTeam1Name();
      _firstBowlingTeam = getTeam2Name();

      _secondBowlingTeam = getTeam1Name();
      _secondBattingTeam = getTeam2Name();
    } else if (((getTossWinner() == getTeam2Name()) &&
        (getChoosedOption() == "Bowl"))) {
      _firstBattingTeam = getTeam1Name();
      _firstBowlingTeam = getTeam2Name();

      _secondBowlingTeam = getTeam1Name();
      _secondBattingTeam = getTeam2Name();
    } else if (((getTossWinner() == getTeam1Name()) &&
        (getChoosedOption() == "Bowl"))) {
      _firstBattingTeam = getTeam2Name();
      _firstBowlingTeam = getTeam1Name();

      _secondBowlingTeam = getTeam2Name();
      _secondBattingTeam = getTeam1Name();
    } else if (((getTossWinner() == getTeam2Name()) &&
        (getChoosedOption() == "Bat"))) {
      _firstBattingTeam = getTeam2Name();
      _firstBowlingTeam = getTeam1Name();

      _secondBowlingTeam = getTeam2Name();
      _secondBattingTeam = getTeam1Name();
    }
    //notifyListeners();
  }

  List<String> getTeamListByTeamName(String teamName) {
    if (teamName == getTeam1Name()) {
      return getTeam1List();
    } else {
      return getTeam2List();
    }
  }

  void setInningNo(int value) {
    inningNumber = value;
    //notifyListeners();
  }

  int getInningNo() {
    return inningNumber;
  }

  List<String> getTeam1List() {
    return team1List;
  }

  List<String> getTeam2List() {
    return team2List;
  }

  bool getIsMatchStarted() {
    return isMatchStarted;
  }

  void setIsMatchStarted(bool value) {
    isMatchStarted = value;
    //notifyListeners();
  }

  String getLocation() {
    return location;
  }

  void setLocation(String value) {
    location = value;
    //notifyListeners();
  }

  String getTossWinner() {
    return tossWinner;
  }

  void setTossWinner(String value) {
    tossWinner = value;
    //notifyListeners();
  }

  String getChoosedOption() {
    return chooseToBatOrBall;
  }

  void setBatOrBall(String value) {
    chooseToBatOrBall = value;
    //notifyListeners();
  }

  void setIsMatchLive(String value) {
    setIsMatchLive(value);
    //notifyListeners();
  }

  void setMatchId(String value) {
    matchId = value;
    //notifyListeners();
  }

  String getMatchId() {
    return matchId;
  }

  void setTeam1Name(String value) {
    team1Name = value;
    //notifyListeners();
  }

  String getTeam1Name() {
    return team1Name;
  }

  String getTeam2Name() {
    return team2Name;
  }

  void setTeam2Name(String value) {
    team2Name = value;
    //notifyListeners();
  }

  int getOverCount() {
    return oversCount;
  }

  void setOverCount(int value) {
    oversCount = value;
    //notifyListeners();
  }

  int getPlayerCount() {
    return playersCount;
  }

  void setPlayerCount(int value) {
    playersCount = value;
    //notifyListeners();
  }
}
