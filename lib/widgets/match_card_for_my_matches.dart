import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/ShareMatch.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
import 'package:umiperer/screens/other_match_screens/toss_page.dart';
import 'package:umiperer/services/database_updater.dart';

///mqd

class MatchCardForCounting extends StatefulWidget {
  MatchCardForCounting({this.match, this.user});

  final CricketMatch match;
  final User user;

  @override
  _MatchCardForCountingState createState() => _MatchCardForCountingState();
}

class _MatchCardForCountingState extends State<MatchCardForCounting> {
  bool loadingAd = false;

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  dividerWidget() {
    return Container(
      color: Colors.black12,
      height: 2,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        margin: EdgeInsets.only(
            left: (16 * SizeConfig.oneW).roundToDouble(),
            right: (16 * SizeConfig.oneW).roundToDouble(),
            bottom: SizeConfig.setHeight(16)),
        // padding: EdgeInsets.only(top: (6*SizeConfig.oneH).roundToDouble(),left: 12,right: 12),
        child: Column(
          children: [
            liveWidget(),
            dividerWidget(),
            //TEAM A vs TEAM B
            topRow(),
            dividerWidget(),
            // live - on/off - continue
            Container(
              margin: EdgeInsets.only(bottom: 14, top: 14),
              padding: EdgeInsets.symmetric(
                  horizontal: (0 * SizeConfig.oneW).roundToDouble()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [mainBtn(), moreOptionsBtn()],
              ),
            ),
          ],
        ));
  }

  liveWidget() {
    return widget.match.isMatchLive
        ? Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (20 * SizeConfig.oneW).roundToDouble(),
                vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LIVE",
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Text(
                  "CATEGORY : ${widget.match.category.toUpperCase()}",
                  style: TextStyle(
                      color: Colors.black26, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (20 * SizeConfig.oneW).roundToDouble(),
                vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "NOT LIVE : Go to MORE OPTIONS",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "CATEGORY : ${widget.match.category.toUpperCase()}",
                  style: TextStyle(
                      color: Colors.black26, fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
  }

  moreOptionsBtn() {
    return Bounce(
      onPressed: () {
        _modalBottomSheetMenuOptions(context);
      },
      child: Container(
        height: (35 * SizeConfig.oneH).roundToDouble(),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black12),
          color: Colors.blueAccent.withOpacity(0.6),
          borderRadius: BorderRadius.circular(7.0),
        ),
        width: (120 * SizeConfig.oneW).roundToDouble(),
        padding: EdgeInsets.symmetric(
            horizontal: (20 * SizeConfig.oneW).roundToDouble()),
        child: Center(child: Text("MORE..")),
      ),
    );
  }

  mainBtn() {
    return Bounce(
      onPressed: () {
        if (widget.match.getTossWinner() == null &&
            widget.match.getChoosedOption() == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TossScreen(
                  match: widget.match,
                  user: widget.user,
                );
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return MatchDetails(
                  match: widget.match,
                  user: widget.user,
                );
              },
            ),
          );
        }
      },
      child: Container(
        height: (35 * SizeConfig.oneH).roundToDouble(),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black12),
          color: Colors.blueAccent.withOpacity(0.6),
          borderRadius: BorderRadius.circular(7.0),
        ),
        width: (180 * SizeConfig.oneW).roundToDouble(),
        padding: EdgeInsets.symmetric(
            horizontal: (20 * SizeConfig.oneW).roundToDouble()),
        child: btnLogic(),
      ),
    );
  }

  topRow() {
    return Container(
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.black12,width: 2),
          // color: Colors.black12,
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(bottom: (8 * SizeConfig.oneW).roundToDouble()),
      padding: EdgeInsets.symmetric(
          horizontal: (14 * SizeConfig.oneW).roundToDouble(),
          vertical: (14 * SizeConfig.oneH).roundToDouble()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // textBaseline: TextBaseline.values,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/team1.png',
                    scale: (17 * SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Text(
                  widget.match.getTeam1Name().toUpperCase(),
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Text(
            "VS",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: (25 * SizeConfig.oneW).roundToDouble(),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Image.asset(
                    'assets/images/team2.png',
                    scale: (17 * SizeConfig.oneW).roundToDouble(),
                  ),
                ),
                Text(widget.match.getTeam2Name().toUpperCase(),
                    maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  btnLogic() {
    if (widget.match.isSecondInningEnd) {
      return Center(child: Text("Ended - View Score"));
    }
    if (widget.match.getIsMatchStarted()) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Continue"),
          Icon(
            Icons.arrow_forward,
            size: (16 * SizeConfig.oneW).roundToDouble(),
          )
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Start Match"),
          Icon(
            Icons.arrow_forward,
            size: (16 * SizeConfig.oneW).roundToDouble(),
          )
        ],
      );
    }
  }

  void toggleLiveOnOff(bool value) {
    print("TURN ON");
    matchesRef.doc(widget.match.getMatchId()).update({"isLive": value});
  }

  void toggleLiveChat(bool value) {
    matchesRef.doc(widget.match.getMatchId()).update({"isLiveChatOn": value});
  }

  void _modalBottomSheetMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: (260 * SizeConfig.oneH).roundToDouble(),
          color: Color(0xFF737373),
          // color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular((8 * SizeConfig.oneW).roundToDouble()),
                    topRight: Radius.circular(
                        (8 * SizeConfig.oneW).roundToDouble()))),
            child: Column(
              children: [
                fabBtn(
                    iconData: widget.match.isMatchLive
                        ? Icons.toggle_on_outlined
                        : Icons.toggle_off_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      widget.match.isMatchLive
                          ? toggleLiveOnOff(false)
                          : toggleLiveOnOff(true);
                    },
                    btnText: widget.match.isMatchLive
                        ? "TURN OFF LIVE"
                        : "TURN ON LIVE"),
                fabBtn(
                    iconData: widget.match.isLiveChatOn
                        ? Icons.toggle_on_outlined
                        : Icons.toggle_off_outlined,
                    onPressed: () {
                      widget.match.isLiveChatOn
                          ? toggleLiveChat(false)
                          : toggleLiveChat(true);
                      Navigator.pop(context);
                      // print("pressed");
                    },
                    btnText: widget.match.isLiveChatOn
                        ? "TURN OFF LIVE CHAT"
                        : "TURN ON LIVE CHAT"),
                fabBtn(
                    iconData: Icons.share_outlined,
                    onPressed: () {
                      Navigator.pop(context);
                      ShareMatch(widget.match).shareMatch(context);
                    },
                    btnText: "SHARE MATCH"),
                fabBtn(
                    iconData: Icons.delete,
                    onPressed: () {
                      DatabaseController.showDeleteDialog(
                          context: context,
                          catName: widget.match.category,
                          matchId: widget.match.getMatchId());
                      // print("pressed");
                    },
                    btnText: "DELETE MATCH")
              ],
            ),
          ),
        );
      },
    );
  }

  fabBtn(
      {Function onPressed,
      String btnText,
      double btnWidth,
      IconData iconData}) {
    if (btnWidth == null) {
      btnWidth = double.infinity;
    }

    return Bounce(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.blueAccent.withOpacity(0.6)),
        margin: EdgeInsets.only(left: 24, right: 24, top: 10),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        width: btnWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(btnText),
            iconData != null ? Icon(iconData) : Container(),
          ],
        ),
      ),
    );
  }
}
