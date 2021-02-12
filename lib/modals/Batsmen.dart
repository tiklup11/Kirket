import 'package:flutter/cupertino.dart';

class Batsmen{

  String playerName;
  String runs;
  String balls;
  String noOf4s;
  String noOf6s;
  String sR;
  bool isOnStrike;
  bool isClickable;

  Batsmen(
      {this.playerName,
      this.runs,
      this.balls,
      this.noOf4s,
      this.noOf6s,
      this.sR,
      this.isOnStrike,
      @required this.isClickable});
}