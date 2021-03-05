import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/LiveMatchesScreen.dart';
import 'package:umiperer/screens/live_scores_directory/catergory_screen.dart';
import 'package:umiperer/screens/live_scores_directory/ended_match_screen.dart';


///this is home screen for live matches
///this has two tabs - 1. LIVE   2. ENDED

class LiveScreenHome extends StatelessWidget {

  LiveScreenHome({this.user,this.catName});

  // final CricketMatch match;
  final User user;
  final String catName;

  appBarTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset('assets/images/kirket.png',height: SizeConfig.setHeight(40),width: SizeConfig.setWidth(120),)
        ,        Builder(
          builder: (BuildContext context)=>Bounce(
            onPressed: (){
              Scaffold.of(context).openDrawer();
            },
            child: CircleAvatar(
              radius: SizeConfig.setWidth(16),
              backgroundImage:AssetImage("assets/images/logo.png") ,
            ),
          ),
        ),
        // SizedBox(width: SizeConfig.setWidth(16),),
        // Text(title,style: TextStyle(color: Colors.black),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      "Live",
      "Finished"
    ];

    final tabBarView = [
      LiveMatchesScreen(currentUser: user,catName: catName,),
      EndMatchesScreen(currentUser: user,),
    ];

    return DefaultTabController(
      initialIndex: 0,
      length: tabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 1,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          // elevation: 0.1,
          title: appBarTopRow(),
          toolbarHeight: (100*SizeConfig.oneH).roundToDouble(),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.black,
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(horizontal: 20),
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              for (final tab in tabBarView)
                Center(
                  child: tab,
                ),
            ],
          ),

      ),
      );
  }

}