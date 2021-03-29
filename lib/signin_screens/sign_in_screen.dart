import 'dart:ui';
import 'package:umiperer/modals/size_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

//MediaQuery r2d

///Working on new sign in functionality in this page
// ignore: must_be_immutable
class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

// keytool -genkey -v -keystore c:\Users\tiklu\kirketKey\key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

class _SignInPageState extends State<SignInPage> {
  final _firebaseAuth = FirebaseAuth.instance;

  ///this is the same user who logged in, but also contains
  ///some more properties
  User user;
  bool isLoading = false;

  _signInWithGoogle() async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken),
          );
          // print(authResult.user.email);
          user = authResult.user;
          _uploadUserData(user);
          return user;
        } else {
          PlatformException(
              code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
              message: 'Missing Google Auth Token');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by User');
      }
    } catch (e) {
      // print('QWERTY:: $e');
    }
  }

  _uploadUserData(User user) {
    print('qwerty:: called');
    final _firestore = FirebaseFirestore.instance;
    final userCollection = _firestore.collection('users');
    userCollection.doc(user.uid.toString()).set({
      'usedId': user.uid,
      'userImageUrl': user.photoURL,
      'userDisplayName': user.displayName,
      'lastLogin': DateTime.now(),
    });

    if (user == null) {
      print("QWERT::::::: user is null");
    }
    print('qwerty:: ${user.email}');
  }

  @override
  Widget build(BuildContext context) {
    return signInScreen(context);
  }

  ///method that builds signInScreen
  Scaffold signInScreen(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      resizeToAvoidBottomInset: true,
      body: lightThemeLogin(),
    );
  }

  Container loadingScreen() {
    return Container(
      height: (SizeConfig.oneH * 30).roundToDouble(),
      child: Center(
          child: SizedBox(
        height: SizeConfig.setHeight(14),
        width: SizeConfig.setWidth(14),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      )),
    );
  }

  Widget lightThemeLogin() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/bg.png'))),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    scale: 2,
                  ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text(
                  //   "Welcome",
                  //   style: TextStyle(
                  //       color: Colors.white, fontWeight: FontWeight.bold),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _signInWithGoogle();
                      setState(() {
                        isLoading = true;
                      });
                    },
                    child: Container(
                        height: (40 * SizeConfig.oneH).roundToDouble(),
                        margin: EdgeInsets.symmetric(
                            horizontal: (15.81 * SizeConfig.widthMultiplier)
                                .roundToDouble()),
                        padding: EdgeInsets.symmetric(
                            vertical: (0.61 * SizeConfig.heightMultiplier)
                                .roundToDouble()),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(
                              (0.8 * SizeConfig.heightMultiplier)
                                  .roundToDouble()),
                        ),
                        child: isLoading
                            ? loadingScreen()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: (7 * SizeConfig.widthMultiplier).roundToDouble(),
                  vertical:
                      (0.5 * SizeConfig.heightMultiplier).roundToDouble()),
              margin: EdgeInsets.only(
                left: (5 * SizeConfig.widthMultiplier).roundToDouble(),
                right: (5 * SizeConfig.widthMultiplier).roundToDouble(),
                top: (10 * SizeConfig.heightMultiplier).roundToDouble(),
                bottom: (2 * SizeConfig.heightMultiplier).roundToDouble(),
              ),
              child: Center(
                child: Text(
                  "By continuing you agree Okays's Terms of services & Privacy Policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          (1.47 * SizeConfig.textMultiplier).roundToDouble()),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
