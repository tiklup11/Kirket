
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:umiperer/screens/other_match_screens/MatchScreens.dart';
import 'package:umiperer/services/Database.dart';
import 'package:umiperer/signin_screens/sign_in_screen.dart';

//MediaQuery r2d
final appVersionRef = FirebaseFirestore.instance.collection('appVersions');

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  void initState() {
    super.initState();
    auth.FirebaseAuth.instance.authStateChanges().listen((user) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      LandingPageBody();
  }
}

class LandingPageBody extends StatefulWidget {
  @override
  _LandingPageBodyState createState() => _LandingPageBodyState();
}

class _LandingPageBodyState extends State<LandingPageBody> {
  PackageInfo packageInfo;

  @override
  void initState() {
    super.initState();
    getPackageInfo();
  }

  getPackageInfo() async{
    packageInfo = await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
                resizeToAvoidBottomInset: false,
                body: StreamBuilder<auth.User>(
                    initialData: auth.FirebaseAuth.instance.currentUser,
                    ///this is the stream of type [User] and we listen to it
                    ///when any new data comes
                    ///the builder: property builds it self every time new
                    ///data comes
                    stream: auth.FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      ///this snapshot contains the Data from our Stream
                      ///Stream can contain any data eg. [int, list, null]
                      ///
                      if (snapshot.connectionState == ConnectionState.active) {
                        final user = snapshot.data;
                        if (user == null) {
                          return SignInPage();
                        } else{
                          return
                            MatchHomeScreens(user: user,);
                        }
                      } else{
                        return Scaffold(
                          body: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    }
                    ),
            );
      }
}

