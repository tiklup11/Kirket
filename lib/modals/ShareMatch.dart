import 'package:share/share.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:flutter/material.dart';

class ShareMatch {
  ShareMatch(this.match);
  CricketMatch match;

  shareMatch(BuildContext context) {
    final String msg =
        "Watch live score of Cricket Match between ${match.getTeam1Name()} vs ${match.getTeam2Name()} [Location - ${match.getLocation()}] on Kirket app. $PLAY_STORE_URL";

    final RenderBox box = context.findRenderObject();
    final sharingText = msg;
    Share.share(sharingText,
        subject: 'Download Kirket app and watch live scores',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
