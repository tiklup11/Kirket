import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/full_score_card_for_audience.dart';
import 'package:umiperer/screens/live_score_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/team_details_page.dart';

///this contains 3-4 tabs and show to audience
class MatchDetailsHomeForAudience extends StatefulWidget {
  MatchDetailsHomeForAudience({this.creatorUID, this.match,this.matchUID});
  final CricketMatch match;
  final String matchUID;
  final String creatorUID;

  @override
  _MatchDetailsHomeForAudienceState createState() => _MatchDetailsHomeForAudienceState();
}

class _MatchDetailsHomeForAudienceState extends State<MatchDetailsHomeForAudience> {

  List tabBarView;

  BannerAd _bannerAd;

  BannerAd createBannerAd (){
    final MobileAdTargetingInfo targetingInfo = new MobileAdTargetingInfo();
    return  BannerAd(
      adUnitId: "ca-app-pub-7348080910995117/5980363458",
      size: AdSize.smartBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }


  @override
  void dispose() {
    super.dispose();
    // _bannerAd.
    _bannerAd..dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = createBannerAd()..load();
    _bannerAd?.show(
      // anchorOffset: 60.0,
      // // Positions the banner ad 10 pixels from the center of the screen to the right
      // horizontalCenterOffset: 10.0,
      // // Banner Position
      // anchorType: AnchorType.bottom,
    );
    tabBarView = [
      TeamDetails(match: widget.match,),
      LiveScorePage(matchUID: widget.matchUID,creatorUID: widget.creatorUID,match: widget.match,),
      ScoreCard(creatorUID: widget.creatorUID, match2: widget.match),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Details",
      "Live Score",
      "Full ScoreCard",
      // "Overs"
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (value){
                //TODO: make switch cases
                switch (value){
                  case "Share match":
                    _shareMatch(context);
                    break;
                }
              },
              itemBuilder: (context){
                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                    value: "Share match",
                    child: Text("Share match"),),
                ];
              },
            ),
          ],
          automaticallyImplyLeading: false,
          title: Text(
              "${widget.match.getTeam1Name().toUpperCase()} v ${widget.match.getTeam2Name().toUpperCase()}"),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabBarView)
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom:
                      (90*SizeConfig.oneH).roundToDouble()
                  ),
                  child: tab,),
              ),
          ],
        ),
      ),
    );
  }


  _shareMatch(BuildContext context) {

    final String playStoreUrl = "https://play.google.com/store/apps/details?id=com.okays.umiperer";
    final String msg = "Watch live score of Cricket Match between ${widget.match.getTeam1Name()} vs ${widget.match.getTeam2Name()} on Kirket app. $playStoreUrl";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
