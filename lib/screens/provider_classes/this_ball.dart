import 'package:flutter/material.dart';

class ThisBall extends ChangeNotifier {
  
  bool isWideBall = false;
  bool isLegBye = false;
  bool isBye = false;
  bool isOut = false;
  bool isNoBall = false;
  bool isOverThrow = false;
  bool isRunOut = false;

  setIsWideBall(bool to) {
    isWideBall = to;
    notifyListeners();
  }

  setIsBye(bool to) {
    isBye = to;
    notifyListeners();
  }

  setIsLegBye(bool to) {
    isLegBye = to;
    notifyListeners();
  }

  setIsOut(bool to) {
    isOut = to;
    notifyListeners();
  }

  setIsNoBall(bool to) {
    isNoBall = to;
    notifyListeners();
  }

  setIsRunOut(bool to) {
    isRunOut = to;
    notifyListeners();
  }

  setIsOverThrow(bool to) {
    isOverThrow= to;
    notifyListeners();
  }
}
