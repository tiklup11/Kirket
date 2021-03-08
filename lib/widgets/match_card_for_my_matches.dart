import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:share/share.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/matchDetailsScreens/matchDetailsHOME.dart';
import 'package:umiperer/screens/toss_page.dart';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RewardedVideoAd.instance.load(
        adUnitId: "ca-app-pub-7348080910995117/3729480926",
        targetingInfo: MobileAdTargetingInfo(childDirected: true));
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "LIVE",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                )
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.symmetric(
                horizontal: (20 * SizeConfig.oneW).roundToDouble(),
                vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "NOT LIVE : Go to MORE OPTIONS",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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

  void _deleteMatch() async {
    ///when we delete a collection,
    ///inner collections are not deleted, so we have to delete inner collections also

    final batsmen1Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("1InningBattingData")
        .get();
    for (var docs in batsmen1Ref.docs) {
      docs.reference.delete();
    }

    final batsmen2Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("2InningBattingData")
        .get();
    for (var docs in batsmen2Ref.docs) {
      docs.reference.delete();
    }

    final bowler1Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("1InningBowlingData")
        .get();
    for (var docs in bowler1Ref.docs) {
      docs.reference.delete();
    }

    final bowler2Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("2InningBowlingData")
        .get();
    for (var docs in bowler2Ref.docs) {
      docs.reference.delete();
    }

    matchesRef
        .doc(widget.match.getMatchId())
        .collection("FirstInning")
        .doc("scoreBoardData")
        .delete();

    matchesRef
        .doc(widget.match.getMatchId())
        .collection("SecondInning")
        .doc("scoreBoardData")
        .delete();

    final overs1Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("inning1overs")
        .get();
    for (var docs in overs1Ref.docs) {
      docs.reference.delete();
    }

    final overs2Ref = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("inning2overs")
        .get();
    for (var docs in overs2Ref.docs) {
      docs.reference.delete();
    }

    final chatCollection = await matchesRef
        .doc(widget.match.getMatchId())
        .collection("chatData")
        .get();
    for (var docs in chatCollection.docs) {
      docs.reference.delete();
    }

    matchesRef.doc(widget.match.getMatchId()).delete();
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
        // elevation: 0,
        // highlightElevation: 0,
        // color: Colors.blueAccent.shade400,
        // minWidth: double.infinity,
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
                        topLeft: Radius.circular(
                            (8 * SizeConfig.oneW).roundToDouble()),
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
                              : liveOnDialog(context: context);
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
                          _shareMatch(context);
                        },
                        btnText: "SHARE MATCH"),
                    fabBtn(
                        iconData: Icons.delete,
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteMatch();
                          // print("pressed");
                        },
                        btnText: "DELETE MATCH")
                  ],
                )),
          );
        });
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

  liveOnDialog({BuildContext context}) {
    Widget cancelButton = TextButton(
      child: Text("Go back"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget logoutButton = TextButton(
      child: Text("Turn ON LIVE"),
      onPressed: () {
        adLoop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("LIVE TELECAST"),
      content: loadingAd
          ? Text("Loading ad")
          : Text(
              "Watch an Rewarding ad and TELECAST LIVE Score. You may need to click 3-4 times on Live button"),
      actions: [
        cancelButton,
        logoutButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  adLoop() async {
    bool didItEnterListener = false;

    print("Entering AdLoop");
    bool isAdLoaded = await RewardedVideoAd.instance.load(
        adUnitId: "ca-app-pub-7348080910995117/3729480926",
        targetingInfo: MobileAdTargetingInfo(childDirected: true));
    if (isAdLoaded) {
      print("enter 1");
      RewardedVideoAd.instance.show();

      RewardedVideoAd.instance.listener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        print("enter ${event.toString()}");
        if (event == RewardedVideoAdEvent.rewarded) {
          print("enter 2");
          didItEnterListener = true;
          Navigator.pop(context);
          toggleLiveOnOff(true);
        } else if (event == RewardedVideoAdEvent.failedToLoad) {
          print("enter 3");
          RewardedVideoAd.instance.load(
              adUnitId: "ca-app-pub-7348080910995117/3729480926",
              targetingInfo: MobileAdTargetingInfo(childDirected: true));
        }
      };
    }
  }

  _shareMatch(BuildContext context) {
    final String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.okays.umiperer";
    final String msg =
        "Watch live score of Cricket Match between ${widget.match.getTeam1Name()} vs ${widget.match.getTeam2Name()} [${widget.match.getLocation()}] on Kirket app. $playStoreUrl";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
