
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class CustomDialog extends StatefulWidget {

  CustomDialog({this.match,this.user});

  final User user;
  final CricketMatch match;
  // final Function isFirstOverStarted;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  final space = SizedBox(width: 10,);

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Align(
            alignment: Alignment.topLeft,
            child: Text("SELECT FOR NEW OVER",
              style: TextStyle(fontWeight: FontWeight.bold,),),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Bowler:"),
              // space,
              dropDownWidget(itemList: team1List),
              // dropDownWidget(itemList: widget.match.team2List),
            ],
          ),
          // space,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Batsmen1:"),
              dropDownWidget(itemList: team1List),
              // dropDownWidget(itemList: widget.match.team2List),
            ],
          ),
          // space,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Batsmen2:"),
              // space,
              dropDownWidget(itemList: team1List),
              // dropDownWidget(itemList: widget.match.team2List),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
              FlatButton(
                color: Colors.blue.shade500,
                child: Text("Start Over"),
                onPressed: (){

                  //TODO: 1. increase OverNo on cloud and all players data // 2.set essentials on class
                  usersRef.doc(widget.user.uid).collection("createdMatches").doc(widget.match.getMatchId()).update(
                      {
                        "currentOverNumber": FieldValue.increment(1)
                      });
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  String _chosenValue="Google";

  List team1List = <String>['Google', 'Apple', 'Amazon', 'Tesla'];

  dropDownWidget({List<String> itemList}){

    return DropdownButton<String>(
      value: _chosenValue,
      items: itemList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          _chosenValue = value;
        });
      },
    );
  }
}