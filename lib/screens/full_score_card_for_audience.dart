import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/first_in_sc.dart';
import 'package:umiperer/screens/second_inn_sc.dart';

///mqd
class ScoreCard extends StatefulWidget {
  ScoreCard({this.creatorUID, this.match2});
  final String creatorUID;
  final CricketMatch match2;

  @override
  _ScoreCardState createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  final tabs = ["first inning", "second inning"];

  List tabBarView;
  bool isInning1=true;
  Color activeTabColor = Colors.black54;
  Color inActiveTabColor = Colors.white;

  Color leftColor;
  Color rightColor;

  @override
  void initState() {
    super.initState();
    print("Inning ${widget.match2.getInningNo()}");
    leftColor = activeTabColor;
    rightColor = inActiveTabColor;
    tabBarView = [
      FirstInningScoreCard(creatorUID: widget.creatorUID, match: widget.match2),
      widget.match2.getInningNo()==1?
    Container(child: Center(child: zeroData(msg: "2nd Inning not started yet",iconData: Icons.sports_cricket_outlined),),):
    SecondInningScoreCard(creatorUID: widget.creatorUID, match: widget.match2)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Container(
        // color: Colors.black12,
        child: Column(
          children: [
            //1. toggleBox
            toggleBox(),
            isInning1?
                tabBarView[0]:tabBarView[1],
          ],
        ),
      )
    );
  }

  toggleBox(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: (100*SizeConfig.oneW).roundToDouble(),vertical: (10*SizeConfig.oneH).roundToDouble()),
      padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(),vertical: (6*SizeConfig.oneH).roundToDouble()),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [leftColor,rightColor], ),
        color: Colors.black,
        borderRadius: BorderRadius.circular((4*SizeConfig.oneW).roundToDouble())
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: (){
            if(leftColor!=activeTabColor && rightColor==activeTabColor){
              setState(() {
                leftColor = activeTabColor;
                rightColor  =  inActiveTabColor;
                isInning1=true;
              });
            }
          },
          child: Container(
            child: Text("Inning 1"),
          ),
        ),
        Container(
          width: (10*SizeConfig.oneW).roundToDouble(),
          color: Colors.white,
        ),
        GestureDetector(
          onTap: (){
            if(rightColor!=activeTabColor && leftColor==activeTabColor){
              setState(() {
                rightColor = activeTabColor;
                leftColor  =  inActiveTabColor;
                isInning1=false;
              });
            }
          },
          child: Expanded(
            child: Container(
              child: Text("Inning 2"),
            ),
          ),
        )
      ],
      ),
    );
  }

  zeroData({String msg, IconData iconData}){
    return Container(
      height: (80*SizeConfig.oneH).roundToDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData),
          SizedBox(width: (4*SizeConfig.oneW).roundToDouble(),),
          Text(msg),
        ],
      ),
    );
  }
}
