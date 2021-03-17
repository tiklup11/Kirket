import 'package:flutter/material.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_batsmen_page.dart';
import 'package:umiperer/screens/matchDetailsScreens/select_and_create_bowler_page.dart';
import 'package:umiperer/widgets/score_button_widget.dart';

/*this class will give 2 buttons 
 * 1.Select Batsmen
 * 2.Select Bowler
 *based on the btnText onPressed will be changed
 */
class SelectPlayerButton extends StatelessWidget {
  const SelectPlayerButton({this.match, this.btnText,this.currentOverNo});
  final String btnText;
  final CricketMatch match;
  final int currentOverNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: selectBatsmenBtn(btnText, context),
    );
  }

  selectBatsmenBtn(String btnText, BuildContext context) {
    return ScoreButton(
        btnText: btnText,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            if (btnText == "Select Batsmen") {
              return SelectAndCreateBatsmenPage(
                match: match,
              );
            }
            if (btnText == "Select Bowler") {
              return SelectAndCreateBowlerPage(
                currentOverNo: currentOverNo,
                match: match,
              );
            }
          }));
        });
  }
}
