import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/other_match_screens/first_in_sc.dart';
import 'package:umiperer/screens/live_chat_screens/live_chat_page.dart';
import 'package:umiperer/screens/other_match_screens/live_score_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';
import 'package:umiperer/modals/ShareMatch.dart';
import 'package:umiperer/screens/other_match_screens/second_inn_sc.dart';

///this contains 3-4 tabs and show to audience
class MatchDetailsHomeForAudience extends StatefulWidget {
  MatchDetailsHomeForAudience(
      {this.currentUser, this.creatorUID, this.match, this.matchUID});
  final CricketMatch match;
  final String matchUID;
  final String creatorUID;
  final User currentUser;

  @override
  _MatchDetailsHomeForAudienceState createState() =>
      _MatchDetailsHomeForAudienceState();
}

class _MatchDetailsHomeForAudienceState
    extends State<MatchDetailsHomeForAudience> {
  List tabBarView;

  List<String> tabs = [];

  @override
  void initState() {
    super.initState();

    print("currentUID: ${widget.creatorUID}");

    // tabs = [
    // "Details",
    // "Live Score",
    // "1st Inning",
    // "2nd Inning"
    // "Overs"
    // ];

    tabs = [
      "Info",
      "Live",
      "1st Inn",
      "2nd Inn",
    ];

    tabBarView = [
      TeamDetails(
        match: widget.match,
      ),
      LiveScorePage(
        matchUID: widget.matchUID,
        creatorUID: widget.creatorUID,
        match: widget.match,
      ),
      // ScoreCard(creatorUID: widget.creatorUID, match2: widget.match),
      FirstInningScoreCard(creatorUID: widget.creatorUID, match: widget.match),
      widget.match.getInningNo() == 1
          ? Container(
              color: Colors.white,
              child: Center(
                child: zeroData(
                    msg: "2nd Inning not started yet",
                    iconData: Icons.sports_cricket_outlined),
              ),
            )
          : SecondInningScoreCard(
              creatorUID: widget.creatorUID, match: widget.match)
    ];

    if (widget.match.isLiveChatOn) {
      tabs.add("Chat");
      tabBarView.add(
        LiveChatPage(
          match: widget.match,
          currentUser: widget.currentUser,
          creatorUid: widget.creatorUID,
        ),
      );
    }

    if (widget.match.isSecondInningEnd) {
      tabs.removeAt(1);
      tabBarView.removeAt(1);
    }
  }

  FacebookBannerAd _currentAd = FacebookBannerAd(
    placementId: K_BANNER_ID, //testid
    bannerSize: BannerSize.STANDARD,
    listener: (result, value) {
      print("Banner Ad: $result -->  $value");
    },
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (value) {
                switch (value) {
                  case "Share match":
                    ShareMatch(widget.match).shareMatch(context);

                    break;
                }
              },
              itemBuilder: (context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: "Share match",
                    child: Text("Share match"),
                  ),
                ];
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: Text(
            "${widget.match.getTeam1Name().toUpperCase()} v ${widget.match.getTeam2Name().toUpperCase()}",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelPadding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            labelColor: Colors.black,
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Text(tab),
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
              child: TabBarView(
                children: [
                  for (final tab in tabBarView) tab,
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _currentAd,
            )
          ],
        ),
      ),
    );
  }

  _shareMatch(BuildContext context) {
    final String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.okays.umiperer";
    final String msg =
        "Watch live score of Cricket Match between ${widget.match.getTeam1Name()} vs ${widget.match.getTeam2Name()} on Kirket app. $playStoreUrl";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  zeroData({String msg, IconData iconData}) {
    return Container(
      height: (80 * SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(
            width: (4 * SizeConfig.oneW).roundToDouble(),
          ),
          Text(msg),
        ],
      ),
    );
  }
}
