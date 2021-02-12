import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/users_data.dart';
import 'package:umiperer/screens/toss_page.dart';

class AdminAccessPage extends StatefulWidget {

  AdminAccessPage({this.user,this.match});

  final CricketMatch match;
  final User user;

  @override
  _AdminAccessPageState createState() => _AdminAccessPageState();
}

class _AdminAccessPageState extends State<AdminAccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Access"),),
      body: matchesData(),
    );
  }

  Widget matchesData(){

    return StreamBuilder<QuerySnapshot>(
      stream: usersRef.snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }else{

          UsersDataForMatches usersDataForMatches;

          final usersDocs = snapshot.data.docs;

          if(usersDocs.isNotEmpty){
            usersDocs.forEach((userDoc) {
              usersDataForMatches.userUID=userDoc.id;
            });
          }

        }



      return ListView.builder(

          itemBuilder: (context,index){
        return Container();
      });
      },
    );

  }
}
