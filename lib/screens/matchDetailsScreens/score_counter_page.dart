import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/screens/matchDetailsScreens/custom_dialog.dart';
import 'package:umiperer/widgets/over_card.dart';

class CounterPage extends StatefulWidget {
  CounterPage({this.match, this.user});

  final User user;
  final CricketMatch match;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {

  final scoreSelectionAreaLength = 220;
  List<Container> balls;
  bool isFirstOverStarted = false;
  String _chosenValue;

  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chosenValue=widget.match.team2List[0];
    _scrollController = ScrollController(keepScrollOffset: true);
  }

  @override
  Widget build(BuildContext context) {


    balls = [
      ballWidget(),
      ballWidget(),
      ballWidget(),
      ballWidget(),
      ballWidget(),
      ballWidget(),
    ];

    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          miniScoreCard(),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'OVERS',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              // shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) =>
                  overCard(overNo: (index + 1).toString()),
            ),
          ),
          Text(
            'OPTIONS FOR NEXT BALL',
          ),
          widget.match.currentOver.getCurrentOverNo()==0?
          startFirstOverBtn():
          scoreSelectionWidget()
        ],
      ),
    );
  }


  ///next over selection
  // nextOverPlayerSelectionWidget(){
  //
  //   final space = SizedBox(width: 10,);
  //
  //   return Container(
  //     padding: EdgeInsets.only(left: 80,top: 20,bottom: 20),
  //     width: double.infinity,
  //     height: scoreSelectionAreaLength.toDouble(),
  //     color: Colors.white,
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         // crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Row(
  //             // mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Select Bowler:"),
  //               space,
  //               // dropDownWidget(itemList: widget.match.team2List),
  //             ],
  //           ),
  //           // space,
  //           Row(
  //             // mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Select Batsmen1:"),
  //               space,
  //               // dropDownWidget(itemList: widget.match.team2List),
  //             ],
  //           ),
  //           // space,
  //           Row(
  //             // mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text("Select Batsmen2:"),
  //               space,
  //               // dropDownWidget(itemList: widget.match.team2List),
  //             ],
  //           ),
  //         ],
  //   ),
  //     )
  //   );
  // }

  newOverPlayersSelectionDialog(){
    return showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        match: widget.match,
        user: widget.user,
        scrollListAnimationFunction: (){
          if (_scrollController.hasClients && widget.match.currentOver!=1){
            double offset = _scrollController.offset + 300;
            _scrollController.animateTo(offset, duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
            // _scrollController.jumpTo(300.0);
          }
        },
      ),
    );
  }

  startFirstOverBtn(){
    return Container(
      width: double.infinity,
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.white,
      child: Container(
        child: FlatButton(
          onPressed: (){
            newOverPlayersSelectionDialog();
          },
          child: Text("START FIRST OVER"),
        ),
      ),
    );
  }

  updateRuns({String playerName, int runs}){

    //update players runs in collection named after player inside TEAM>BATSMEN>PLAYERSNAME
    //
    print("Player $playerName scores $runs");

  }

  scoreSelectionWidget({String playersName}){

    final double buttonWidth = 60;
    final btnColor = Colors.black12;
    final spaceBtwn = SizedBox(width: 4,);

    return Container(
      height: scoreSelectionAreaLength.toDouble(),
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///row one [0,1,2,3,4]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: "RAJU", runs: 0);},
                    child: Text("0")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 1);},
                    child: Text("1")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 2);},
                    child: Text("2")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 3);},
                    child: Text("3")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 4);},
                    child: Text("4")),
              ],
            ),
            ///row 2 [6,Wide,LB,Out,NB]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 6);},
                    child: Text("6")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    onPressed: (){updateRuns(playerName: playersName, runs: 0);},
                    child: Text("Wide")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    //TODO: legBye runs need to updated [open new run set]
                    onPressed: (){updateRuns(playerName: playersName, runs: 0);},
                    child: Text("LB")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    //TODO: no-ball -- open new no-ball set
                    onPressed: (){updateRuns(playerName: playersName, runs: 1);},
                    child: Text("NB")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    //TODO: out btn clicked
                    onPressed: (){updateRuns(playerName: playersName, runs: 0);},
                    child: Text("Out")),
              ],
            ),
            ///row 3 [over throw, overEnd,]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    //TODO: over throw
                    onPressed: (){updateRuns(playerName: playersName, runs: 0);},
                    child: Text("Over Throw")),
                spaceBtwn,
                FlatButton(
                    color: btnColor,
                    minWidth: buttonWidth,
                    //TODO: start new over
                    onPressed: (){

                      newOverPlayersSelectionDialog();

                      // updateRuns(playerName: playersName, runs: 0);

                      },
                    child: Text("Start new over")),

              ],
            ),
          ],
        ),
      ),
    );
  }

  overCard({String overNo}) {
    // String overNo;
    String bowlerName;
    String batsman1Name;
    String batsman2Name;

    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.white),
      height: 60,
      // color: Colors.black26,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 8,
              top: 8,
            ),
            child: Text("OVER NO: $overNo"),
          ),
          //Bowler Name
          // bowlerWidget(),
          //
          // Row(
          //   // mainAxisSize: MainAxisSize.max,
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     batsmanWidget(batsmanName: "Pulkit",isOnStrike: false),
          //     batsmanWidget(batsmanName: "Rohit Sharma",isOnStrike: true),
          //   ],
          // ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4,horizontal: 4),
            child: Row(
              children: balls,
            ),
          ),
        ],
      ),
    );
  }

  bowlerWidget() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Text("Bowler: Bumrah 🏐"));
  }

  batsmanWidget({String batsmanName, bool isOnStrike}){
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(4)),
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child:
        isOnStrike?
        Text("$batsmanName 🏏"):
        Text("$batsmanName"),
    );
  }

  ballWidget() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Colors.blue.shade100,
        ));
  }

  tossLineWidget() {
    return Container(
        padding: EdgeInsets.only(left: 12, top: 12),
        child: Text(
            "${widget.match.getTossWinner()} won the toss and choose to ${widget.match.getChoosedOption()}"));
  }

  oversContainer() {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      children: [
        OverCard(
          user: widget.user,
          match: widget.match,
          currentOverNumber: 1,
        ),
        OverCard(
          user: widget.user,
          match: widget.match,
          currentOverNumber: 1,
        ),
        OverCard(
          user: widget.user,
          match: widget.match,
          currentOverNumber: 1,
        ),
        OverCard(
          user: widget.user,
          match: widget.match,
          currentOverNumber: 1,
        ),
        OverCard(
          user: widget.user,
          match: widget.match,
          currentOverNumber: 1,
        ),
      ],
    );
  }

  miniScoreCard() {
    return Column(
      children: [
        tossLineWidget(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.match.getTossWinner().toUpperCase(),
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        "92-2  (45)",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text("CRR"),
                      Text("5.83"),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 6),
                color: Colors.black12,
                height: 2,
              ),
              playersScore(),
            ],
          ),
        ),
      ],
    );
  }

  final TextStyle textStyle = TextStyle(color: Colors.black);

  playersScore() {
    final TextStyle textStyle = TextStyle(color: Colors.black54);
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 120,
                  child: Text(
                    "Batsman",
                    style: textStyle,
                  )),
              Container(
                  width: 30,
                  child: Text(
                    "R",
                    style: textStyle,
                  )),
              Container(
                  width: 30,
                  child: Text(
                    "B",
                    style: textStyle,
                  )),
              Container(
                  width: 30,
                  child: Text(
                    "4s",
                    style: textStyle,
                  )),
              Container(
                  width: 30,
                  child: Text(
                    "6s",
                    style: textStyle,
                  )),
              Container(
                  width: 30,
                  child: Text(
                    "SR",
                    style: textStyle,
                  )),
            ],
          ),
          SizedBox(height: 4,),

          //Batsman's data
          batsmanScoreRow(
              playerName: "Pulkit",
              runs: "100",
              balls: "35",
              noOf4s: "7",
              noOf6s: "11",
              SR: "290"),
          SizedBox(height: 4,),
          batsmanScoreRow(
              playerName: "Rohit Sharma*",
              runs: "99",
              balls: "35",
              noOf4s: "4",
              noOf6s: "11",
              SR: "220"),

          //Line
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.black12,
            height: 2,
          ),
          SizedBox(height: 4,),
          //Bowler's Data
          bowlerStatsRow(
              runs: "R",
              playerName: "Bowler",
              economy: "ER",
              median: "M",
              overs: "O",
              wickets: "W",
              textStyle: textStyle),
          SizedBox(height: 4,),
          bowlerStatsRow(
              runs: "34",
              playerName: "Malinga*",
              economy: "7",
              median: "0",
              overs: "4",
              wickets: "1",
              textStyle: textStyle.copyWith(color: Colors.black))
        ],
      ),
    );
  }

  batsmanScoreRow(
      {String playerName,
      String runs,
      String balls,
      String noOf4s,
      String noOf6s,
      String SR}) {
    final TextStyle textStyle = TextStyle(color: Colors.black);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: Text(
            playerName,
            style: textStyle,
            maxLines: 2,
          ),
        ),
        Container(
            width: 30,
            child: Text(
              runs,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              balls,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              noOf4s,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              noOf6s,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              SR,
              style: textStyle,
            )),
      ],
    );
  }

  bowlerStatsRow(
      {String playerName,
      String overs,
      String median,
      String runs,
      String wickets,
      String economy,
      TextStyle textStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: Text(
            playerName,
            style: textStyle,
            maxLines: 2,
          ),
        ),
        Container(
            width: 30,
            child: Text(
              overs,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              median,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              runs,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              wickets,
              style: textStyle,
            )),
        Container(
            width: 30,
            child: Text(
              economy,
              style: textStyle,
            )),
      ],
    );
  }

  addNewOverButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          IconButton(
            iconSize: 50,
            padding: EdgeInsets.zero,
            onPressed: () {
              print("AAAAAAAAAAAAAAAA");
            },
            icon: Icon(Icons.add),
          ),
          Text("Add new over")
        ],
      ),
    );
  }

}
