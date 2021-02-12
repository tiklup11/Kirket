import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umiperer/modals/size_config.dart';


///mqd
class OverCard extends StatefulWidget {

  OverCard({this.match,this.user,this.currentOverNumber});

  final User user;
  final CricketMatch match;
  final int currentOverNumber;

  @override
  _OverCardState createState() => _OverCardState();
}

class _OverCardState extends State<OverCard> {

  String dropdownValue = '1';
  List<Widget> balls;

  @override
  Widget build(BuildContext context) {

    final SizedBox sizedBox = SizedBox(width: (2*SizeConfig.oneW).roundToDouble(),);

    balls = [
      overBallWidget(context: context,),
      sizedBox,
      overBallWidget(context: context,),
      sizedBox,
      overBallWidget(context: context,),
      sizedBox,
      addNewBallButton()
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(),vertical: (10*SizeConfig.oneH).roundToDouble()),
      margin: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble(),vertical: (10*SizeConfig.oneH).roundToDouble()),
      height: (135*SizeConfig.oneH).roundToDouble(),
      // color: Colors.white,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular((8*SizeConfig.oneW).roundToDouble())
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Over ${widget.currentOverNumber}"),
          // dropDown(context: context,icon: Icon(Icons.add)),
          Container(
            child: Row(
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: balls,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  //CircleAvatar(backgroundColor: Colors.blue,);


  overBallWidget({BuildContext context}){
    return Container(
      width:60,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular((6*SizeConfig.oneW).roundToDouble())
      ),
      child: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          // icon: Icon(Icons.add),
          iconSize: (24*SizeConfig.oneW).roundToDouble(),
          elevation: 16,
          style: TextStyle(color: Colors.black),
          underline: Container(),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: <String>['0','1', '2', '3', '4','5','6','Wide','W']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  dropDown({BuildContext context, Icon icon}){
    return DropdownButton<String>(
      value: dropdownValue,
      // icon: icon,
      iconSize: (24*SizeConfig.oneW).roundToDouble(),

      elevation: 16,
      style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: (2*SizeConfig.oneH).roundToDouble(),
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['1', '2', '3', '4']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  addNewBallButton(){
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      minWidth: (60*SizeConfig.oneW).roundToDouble(),
      height: (48*SizeConfig.oneH).roundToDouble(),
      color: Colors.blue,
        onPressed: (){
        setState(() {
          balls.add(overBallWidget(context: context,));
        });
        },
        child: Icon(Icons.add));
  }
}
