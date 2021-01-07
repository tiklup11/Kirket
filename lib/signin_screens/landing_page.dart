
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:umiperer/screens/MatchScreens.dart';
import 'package:umiperer/signin_screens/sign_in_screen.dart';

//MediaQuery r2d

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {


  void initState() {
    super.initState();
    auth.FirebaseAuth.instance.authStateChanges().listen((user) {
      // print('user :${user?.uid}');
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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
}

