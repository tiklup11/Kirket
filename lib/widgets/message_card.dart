import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/size_config.dart';

class MessageCard extends StatelessWidget {

  MessageCard({this.textMsg,this.senderDisplayName,this.currentUser,this.senderEmail});

  final User currentUser;
  final String senderDisplayName;
  final String textMsg;
  final String senderEmail;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
      currentUser.email==senderEmail?
      EdgeInsets.only(left: SizeConfig.setWidth(100)):
      EdgeInsets.only(right: SizeConfig.setWidth(100)),
      child: Padding(
        padding:
        currentUser.email==senderEmail?
        EdgeInsets.only(right: SizeConfig.setWidth(10),top: SizeConfig.setHeight(12)):
        EdgeInsets.only(left: SizeConfig.setWidth(10),top: SizeConfig.setHeight(12)),
        child: Column(
          crossAxisAlignment:currentUser.email==senderEmail?
          CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
              currentUser.email==senderEmail?
              EdgeInsets.only(right:12.0):EdgeInsets.only(left: 12.0),
              child: Text(senderDisplayName,style: TextStyle(fontSize: SizeConfig.setWidth(8)),),
            ),
            Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.setWidth(14),
                    right:SizeConfig.setWidth(14),
                    top: SizeConfig.setWidth(8),
                    bottom: SizeConfig.setWidth(8)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26,width: 2)
                ),
                child: Text(textMsg,maxLines: 10,)),
          ],
        ),
      ),
    );
  }
}
