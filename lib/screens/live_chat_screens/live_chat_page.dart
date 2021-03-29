import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/CricketMatch.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/widgets/message_card.dart';

class LiveChatPage extends StatefulWidget {
  LiveChatPage({this.match, this.currentUser, this.creatorUid});

  CricketMatch match;
  String creatorUid;
  User currentUser;
  @override
  _LiveChatPageState createState() => _LiveChatPageState();
}

class _LiveChatPageState extends State<LiveChatPage> {
  String typedMsg;

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("currentUID: ${widget.creatorUid}");
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          msgList(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [typeBox(), sendBtn()],
          )
        ],
      ),
    );
  }

  msgList() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: matchesRef
            .doc(widget.match.getMatchId())
            .collection('chatData')
            .orderBy("timeStamp", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Container(
                    child: Center(child: CircularProgressIndicator())));
          } else {
            final allMsgDocs = snapshot.data.docs;

            if (allMsgDocs.isEmpty) {
              return Expanded(
                child: Container(
                  child: Center(
                      child: Image.asset(
                    'assets/gifs/msg.gif',
                    scale: 1.4,
                  )),
                ),
              );
            }

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
                  cacheExtent: 10,
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: allMsgList.length,
                  itemBuilder: (context, index) {
                    return allMsgList[index];
                  }),
            );
          }
        },
      ),
    );
  }

  sendBtn() {
    return Bounce(
        child: CircleAvatar(
            radius: 23,
            backgroundColor: Colors.black12,
            child: Icon(
              Icons.send_rounded,
              color: Colors.black38,
            )),
        onPressed: () {
          print("Sending");
          uploadMessageToCloud();
        });
  }

  uploadMessageToCloud() {
    _editingController.clear();
    // _editingController
    if (typedMsg != null) {
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
      typedMsg = null;
    }
  }

  TextEditingController _editingController = TextEditingController();

  typeBox() {
    return Container(
      width: 310,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 2),
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.symmetric(
          horizontal: (6 * SizeConfig.oneW).roundToDouble(), vertical: 12),
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: _editingController,
        onChanged: (value) {
          setState(() {
            typedMsg = value;
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
