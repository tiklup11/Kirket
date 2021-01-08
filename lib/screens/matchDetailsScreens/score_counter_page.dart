import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/widgets/over_card.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CounterPage extends StatefulWidget {

  CounterPage({this.match,this.user});

  final User user;
  final CricketMatch match;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: ListView(
        children: [
         tossLineWidget(),
          miniScoreCard(),
          OverCard(user: widget.user,match: widget.match,currentOverNumber: 1,),
          addNewOverButton(context)
        ],
      ),
    );
  }

  tossLineWidget(){
    return Container(
        padding: EdgeInsets.only(left: 12,top: 12),
        child: Text("${widget.match.getTossWinner()} won the toss and choose to ${widget.match.getChoosedOption()}"));
  }

  miniScoreCard(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                  Text(widget.match.getTossWinner(),style: TextStyle(fontSize: 30),),
                  Text("92-2  (45)",style: TextStyle(fontSize: 16),)
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
            color: Colors.black12,height: 2,),
          playersScore(),
        ],
      ),
    );
  }
  final TextStyle textStyle = TextStyle(color: Colors.black);


  playersScore(){
    final TextStyle textStyle = TextStyle(color: Colors.black54);
    return Container(
      child: Column(
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Container(
                   width: 120,
                   child: Text("Batsman",style: textStyle,)),
               Container(width: 30,child: Text("R",style: textStyle,)),
               Container(width: 30,child: Text("B",style: textStyle,)),
               Container(width: 30,child: Text("4s",style: textStyle,)),
               Container(width: 30,child: Text("6s",style: textStyle,)),
               Container(width: 30,child: Text("SR",style: textStyle,)),
             ],
           ),

          //Batsman's data
          batsmanScoreRow(playerName: "Pulkit",runs: "100",balls: "35",noOf4s: "7",noOf6s: "11",SR: "290"),
          batsmanScoreRow(playerName: "Rohit Sharma*",runs: "99",balls: "35",noOf4s: "4",noOf6s: "11",SR: "220"),

          //Line
          Container(
            margin: EdgeInsets.symmetric(vertical: 6),
            color: Colors.black12,height: 2,),

          //Bowler's Data
          bowlerStatsRow(
              runs: "R",playerName: "Bowler",economy: "ER",median: "M",overs: "O",wickets: "W",textStyle: textStyle
          ),

          bowlerStatsRow(
            runs: "34",playerName: "Malinga*",economy: "7",median: "0",overs: "4",wickets: "1",textStyle: textStyle.copyWith(color: Colors.black)
          )
        ],
      ),
    );
  }

  batsmanScoreRow({String playerName,String runs,String balls,String noOf4s,String noOf6s,String SR}){

    final TextStyle textStyle = TextStyle(color: Colors.black);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: Text(playerName,style: textStyle,
          maxLines: 2,),
        ),
        Container(width: 30,child: Text(runs,style: textStyle,)),
        Container(width: 30,child: Text(balls,style: textStyle,)),
        Container(width: 30,child: Text(noOf4s,style: textStyle,)),
        Container(width: 30,child: Text(noOf6s,style: textStyle,)),
        Container(width: 30,child: Text(SR,style: textStyle,)),
      ],
    );
  }

  bowlerStatsRow({String playerName,String overs,String median,String runs,String wickets,String economy,TextStyle textStyle}){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120,
          child: Text(playerName,style: textStyle,
            maxLines: 2,),
        ),
        Container(width: 30,child: Text(overs,style: textStyle,)),
        Container(width: 30,child: Text(median,style: textStyle,)),
        Container(width: 30,child: Text(runs,style: textStyle,)),
        Container(width: 30,child: Text(wickets,style: textStyle,)),
        Container(width: 30,child: Text(economy,style: textStyle,)),
      ],
    );
  }

  addNewOverButton(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      height: 100,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          IconButton(
            iconSize: 50,
            padding: EdgeInsets.zero,
            onPressed: (){print("AAAAAAAAAAAAAAAA");},
            icon: Icon(Icons.add),
          ),
          Text("Add new over")
        ],
      ),
    );
  }

}
