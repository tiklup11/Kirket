import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/signin_screens/landing_page.dart';

// final String adMobId = "ca-app-pub-3940256099942544~3347511713";

CollectionReference appVersionRef;
PackageInfo packageInfo;
void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}


class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Building");
    return LayoutBuilder(
        builder: (context, constraints) {
          return OrientationBuilder(
              builder: (context, orientation) {
                SizeConfig().init(constraints, orientation);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryColor: Colors.white,
                    primarySwatch: Colors.blueGrey,
                    focusColor: Colors.blueGrey,

                  ),
                  home: LandingPage(),
                );
              }
          );
        }
    );
  }


}