import 'package:flutter/material.dart';
import 'package:umiperer/screens/fill_new_match_details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyMatchesScreen extends StatelessWidget {
  MyMatchesScreen({this.user});
  final User user;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _modalBottomSheetMenu(context);
             print("FAB pressed");
            },
            child: Icon(Icons.add),
          ),
        ));
  }

  void _modalBottomSheetMenu(BuildContext context){
    showModalBottomSheet(
        context: context,
        builder: (builder){
          return Container(
            height: 120.0,
            color: Color(0xFF737373),
            // color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0))),
                child: Column(
                  children: [
                    FlatButton(
                      minWidth: double.infinity,
                        child: Text("Create match"),
                        onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return FillNewMatchDetailsPage(user: user);
                        }));
                      print("pressed");
                    }),
                    FlatButton(
                        child: Text("Create Tournament"),
                        onPressed: (){
                          print("pressed");
                        }),
                  ],
                )),
          );
        }
    );
  }
}
