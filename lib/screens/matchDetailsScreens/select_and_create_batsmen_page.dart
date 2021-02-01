import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/Match.dart';
import 'package:umiperer/modals/dataStreams.dart';
import 'package:umiperer/screens/matchDetailsScreens/dialog_custom.dart';

class SelectAndCreateBatsmenPage extends StatefulWidget {
  SelectAndCreateBatsmenPage({this.match, this.user});

  final CricketMatch match;
  final User user;
  @override
  _SelectAndCreateBatsmenPageState createState() =>
      _SelectAndCreateBatsmenPageState();
}

class _SelectAndCreateBatsmenPageState
    extends State<SelectAndCreateBatsmenPage> {
  DataStreams _dataStreams;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataStreams = DataStreams(
        userUID: widget.user.uid, matchId: widget.match.getMatchId());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          automaticallyImplyLeading: true,
          title: Text("Select Batsmen"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            batsmensList(),
            addNewPlayerBtn(),
          ],
        ));
  }

  Widget batsmensList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _dataStreams.batsmenData(inningNumber: widget.match.getInningNo()),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final playersData = snapshot.data.docs;
          List<Widget> playerNames;
          if (playersData.isEmpty) {
            return addNewPlayerText();
          }

          playersData.forEach((player) {
            playerNames.add(playerText(player.id));
          });
          return ListView(
            children: playerNames,
          );
        }
      },
    );
  }

  Widget playerText(String playerName) {
    return Text(playerName);
  }

  Widget addNewPlayerText() {
    return Expanded(
      child: Center(
        child: Text(
          "ADD NEW PLAYER",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic),
        ),
      ),
    );
  }

  Widget addNewPlayerBtn() {
    return FlatButton(
      // elevation: 0,
      minWidth: double.infinity,
      color: Colors.blueGrey,
      child: Text("ADD NEW PLAYER"),
      onPressed: () {
        openDialog();
      },
    );
  }

  openDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return AddPlayerDialog(
            user: widget.user,
            match: widget.match,
          );
        });
  }
}
