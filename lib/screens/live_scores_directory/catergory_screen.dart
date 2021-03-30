import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:page_transition/page_transition.dart';
import 'package:umiperer/main.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/live_scores_directory/live_screen_home.dart';
import 'package:umiperer/screens/other_match_screens/zero_doc_screen.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({this.user});
  final User user;
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: categoryRef.snapshots(),
      builder: (context, snapshot) {
        List<CatCard> catCardsList = [];
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          final catDocs = snapshot.data.docs;

          catDocs.forEach((catDoc) {
            if (catDoc.data()["count"] != 0) {
              catCardsList.add(new CatCard(
                catName: catDoc.data()['catName'],
                user: widget.user,
              ));
            }
          });

          if (catCardsList.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Live",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ZeroDocScreen(
                    showLearnMore: true,
                    dialogText:
                        "To start scoring, go to HOME and press (+ NEW MATCH)",
                    textMsg: "NO LIVE MATCHES",
                    iconData: Icons.live_tv_rounded,
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Live",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  cacheExtent: 10,
                  itemCount: catCardsList.length,
                  itemBuilder: (context, int) {
                    return catCardsList[int];
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class CatCard extends StatelessWidget {
  CatCard({this.catName, this.user});
  final String catName;
  final User user;
  @override
  Widget build(BuildContext context) {
    return Bounce(
      onPressed: () {
        Navigator.push(
            context,
            PageTransition(
                child: LiveScreenHome(
                  catName: catName,
                  user: user,
                ),
                type: PageTransitionType.rightToLeft));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12, width: 2)),
        margin: EdgeInsets.symmetric(
            horizontal: (10 * SizeConfig.oneW).roundToDouble(),
            vertical: (10 * SizeConfig.oneH).roundToDouble()),
        padding: EdgeInsets.symmetric(
            horizontal: (20 * SizeConfig.oneW).roundToDouble(),
            vertical: (20 * SizeConfig.oneH).roundToDouble()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(catName.toUpperCase()),
            Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
