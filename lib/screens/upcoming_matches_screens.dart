import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umiperer/modals/UpcomingTournament.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/Upcoming_tournament_entry_page.dart';
import 'package:umiperer/screens/zero_doc_screen.dart';
import 'package:umiperer/widgets/upcoming_tour_card_widget.dart';
import 'package:url_launcher/url_launcher.dart';

///mqr
class UpcomingMatchesScreen extends StatefulWidget {

  UpcomingMatchesScreen({this.user});
  final User user;

  @override
  _UpcomingMatchesScreenState createState() => _UpcomingMatchesScreenState();
}

class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("HELLO"),),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AnnounceNewTournament(user: widget.user,);
            }));
          },
        ),
        body: upcoming());
  }

  ///
  upcoming() {
    return StreamBuilder<QuerySnapshot>(
        stream: upcomingTournamentCollectionRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(child: Center(child: CircularProgressIndicator()));
          } else {
            //ut  = upcomingTournaments
            final utDocList = snapshot.data.docs;

            if(utDocList.isEmpty){
              return ZeroDocScreen(textMsg: "Tab + to announce your Upcoming Tournament",iconData: Icons.sports_cricket_outlined,);
            }

            List<UpcomingTournamentCard> upcomingTournamentsCardList = [];

            utDocList.forEach((upcomingTournamentDoc) {
              UpcomingTournament upcomingTournament = new UpcomingTournament();

              upcomingTournament.tournamentUID = upcomingTournamentDoc.id;

              final upcomingTournamentData = upcomingTournamentDoc.data();

              upcomingTournament.startingDate =
                  upcomingTournamentData['startingDate'];
              upcomingTournament.tournamentName =
                  upcomingTournamentData['tournamentName'];
              upcomingTournament.contactNumber =
                  upcomingTournamentData['contactNumber'];
              upcomingTournament.matchLocation =
                  upcomingTournamentData['location'];
              upcomingTournament.entryFees =
                  upcomingTournamentData['entryFees'];
              upcomingTournament.creatorUID =
                  upcomingTournamentData['userUID'];


              print("UPcoming :::::  ${upcomingTournament.startingDate}");

              upcomingTournamentsCardList.add(UpcomingTournamentCard(
                upcomingTournament: upcomingTournament,
                showBottomModalSheet: () {
                  _modalBottomSheetMenu(upcomingTournament);
                },
              ));
            });

            return ListView.builder(
                itemCount: upcomingTournamentsCardList.length,
                itemBuilder: (context, index) {
                  return upcomingTournamentsCardList[index];
                });

            // listOfUpcomingTournaments();
          }
        });
  }

  void _modalBottomSheetMenu(UpcomingTournament upcomingTournament) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all((20*SizeConfig.oneW).roundToDouble()),
            height: (350.0*SizeConfig.oneH).roundToDouble(),
            color: Colors.transparent,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      upcomingTournament.tournamentName.toUpperCase(),
                      style: TextStyle(fontSize: (30*SizeConfig.oneW).roundToDouble(), color: Colors.black),
                    ),
                    customListTile(text: "Location",data: upcomingTournament.matchLocation,iconData: Icons.location_on),
                    customListTile(text: "Entry Fee",data: upcomingTournament.entryFees.toString(),iconData: Icons.attach_money_rounded),
                    customListTile(text: "Contact no",data: upcomingTournament.contactNumber.toString(),iconData: Icons.phone),
                    customListTile(text: "Starting data",data: upcomingTournament.startingDate,iconData: Icons.date_range),
                  ],
                ),
                upcomingTournament.creatorUID==widget.user.uid?
                    //Remove Btn
                MaterialButton(
                    minWidth: double.infinity,
                    // animationDuration: Duration(milliseconds: 1),
                    elevation: 0,
                    highlightElevation: 0,
                    color: Colors.blueGrey.shade400,
                    child: Text("Remove"),
                    onPressed: (){
                      showAlertDialog(context: context,tournamentUID: upcomingTournament.tournamentUID);
                    }):
                Column(
                  children: [
                    MaterialButton(
                        minWidth: double.infinity,
                        // animationDuration: Duration(milliseconds: 1),
                        elevation: 0,
                        highlightElevation: 0,
                        color: Colors.blueGrey.shade400,
                        child: Text("Call"),
                        onPressed: (){
                          _launchCaller(phoneNo: upcomingTournament.contactNumber.toString());
                          Navigator.pop(context);
                        }),
                    MaterialButton(
                        minWidth: double.infinity,
                        // animationDuration: Duration(milliseconds: 1),
                        elevation: 0,
                        highlightElevation: 0,
                        color: Colors.blueGrey.shade400,
                        child: Text("Whatsapp"),
                        onPressed: (){
                          _launchWhatsapp(phoneNo: upcomingTournament.contactNumber.toString());
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            ),
          );
        });
  }

  removeThisTournament({String docUID}){
    upcomingTournamentCollectionRef.doc(docUID).delete();
  }

  customListTile({String text,String data,IconData iconData}){
    final space = SizedBox(width: (8*SizeConfig.oneW).roundToDouble(),);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: (4*SizeConfig.oneH).roundToDouble()),
      child: Row(
        children: [
          Icon(iconData),
          space,
          Text(
            "$text :  $data",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  _launchCaller({String phoneNo}) async {
    // String url = "tel:$phoneNo";
    String url = "tel:$phoneNo";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchWhatsapp({String phoneNo}) async {

      var whatsappUrl = "whatsapp://send?phone=$phoneNo";
      await canLaunch(whatsappUrl) != null
          ? launch(whatsappUrl)
          : print(
          "open WhatsApp app link or do a snackbar with notification that there is no WhatsApp installed");
  }

  showAlertDialog({BuildContext context,String tournamentUID}) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () async{
        Navigator.pop(context);
        //remove this tournament from firebase
        await removeThisTournament(docUID: tournamentUID);
        Navigator.pop(context);

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete"),
      content: Text("This will delete your announcement"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}
