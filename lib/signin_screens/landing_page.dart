
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:umiperer/screens/MatchScreens.dart';
import 'package:umiperer/screens/app_update_pop.dart';
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
    // setThemeToNull();
    return
      LandingPageBody();
  }
}

// ignore: must_be_immutable
class LandingPageBody extends StatefulWidget {
  @override
  _LandingPageBodyState createState() => _LandingPageBodyState();
}

class _LandingPageBodyState extends State<LandingPageBody> {
  PackageInfo packageInfo;

  @override
  void initState() {
    // TODO: implement initState
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
                          // print('qwerty ::${user?.uid}');
                          return SignInPage();
                        } else{
                          // print('qwerty ::${user?.uid}');
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

  // showUpdate(User user){
  //
  //   return StreamBuilder(
  //       stream: appVersionRef.doc("latestAppVersion").snapshots(),
  //       builder: (context,snapshot){
  //         if(!snapshot.hasData){
  //           return Container(child: Center(child: CircularProgressIndicator()));
  //         }else{
  //           // String appName = packageInfo.appName;
  //           // String packageName = packageInfo.packageName;
  //           String version = packageInfo.version;
  //           String buildNumber = packageInfo.buildNumber;
  //           print("version : $buildNumber");
  //           final latestAppVersion = snapshot.data['latestAppVersion'];
  //           print(latestAppVersion);
  //           if(latestAppVersion!=version){
  //             return MatchHomeScreens(user: user,);
  //           }else{
  //             return AppUpdateDialog();
  //           }
  //         }
  //       });
  // }
}

