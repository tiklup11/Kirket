import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/message_card.dart';

class LiveChatPage extends StatefulWidget {

  LiveChatPage({this.match,this.currentUser,this.creatorUid});

  CricketMatch match;
  String creatorUid;
  User currentUser;
  @override
  _LiveChatPageState createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> {

  String typedMsg;

  @override
  Widget build(BuildContext context) {
    print("currentUID: ${widget.creatorUid}");
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          msgList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              typeBox(),
              sendBtn()
            ],
          )
        ],
      ),
    );
  }

  msgList(){
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: matchesRef
            .doc(widget.match.getMatchId())
            .collection('chatData').orderBy("timeStamp",descending: true)
            .snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData){
            return Expanded(child: Container(child: Center(child: CircularProgressIndicator())));
          }else{
            final allMsgDocs = snapshot.data.docs;
            List<MessageCard> allMsgList = [];

            allMsgDocs.forEach((msgDoc) {
              allMsgList.add(MessageCard(
                currentUser: widget.currentUser,
                senderEmail: msgDoc['senderEmail'],
                textMsg: msgDoc.data()['textMsg'],
                senderDisplayName: msgDoc.data()['sender'],
              ));
            });

            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                   reverse: true,
                  itemCount: allMsgList.length,
                  itemBuilder: (context,index){
                return allMsgList[index];
              }),
            );
          }
        },
      ),
    );
  }

  sendBtn(){
    return Bounce(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 11),
          child: Icon(Icons.send_rounded,color: Colors.blueGrey,),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(6))
          ),
        ) ,
        onPressed: (){
          print("Sending");
          uploadMessageToCloud();
        });
  }

  uploadMessageToCloud(){
    _editingController.clear();
    // _editingController
    if(typedMsg!=null){
      matchesRef
          .doc(widget.match.getMatchId())
          .collection('chatData')
          .doc()
          .set({
        "textMsg": typedMsg,
        "timeStamp": DateTime.now().toString(),
        "sender": widget.currentUser.displayName,
        "senderEmail": widget.currentUser.email,
      });
      typedMsg=null;
    }
  }

  TextEditingController _editingController = TextEditingController();

  typeBox() {
    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      margin: EdgeInsets.symmetric(horizontal: (6*SizeConfig.oneW).roundToDouble(),vertical: 12),
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: _editingController,
        onChanged: (value){
          setState(() {
            typedMsg=value;
          });
        },
        decoration: InputDecoration(
          hintText: "Type message here.",
          // prefix: sendBtn(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


