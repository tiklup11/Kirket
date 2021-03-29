import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:umiperer/modals/CategoryController.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/signin_screens/landing_page.dart';
import 'package:your_splash/your_splash.dart';

final matchesRef = FirebaseFirestore.instance.collection('allMatches');
final categoryRef = FirebaseFirestore.instance.collection('categories');
// final usersRef = FirebaseFirestore.instance.collection('users');

// final String adMobId = "ca-app-pub-3940256099942544~3347511713";

PackageInfo packageInfo;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final ok = await FirebaseAdMob.instance
  // .initialize(appId: "ca-app-pub-7348080910995117~8961750013");
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryController())
      ],
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.blueAccent,
              // focusColor: Colors.blueGrey,
            ),
            home: SplashScreen.timed(
              seconds: 1,
              route: MaterialPageRoute(builder: (_) => LandingPage()),
              body: Scaffold(
                backgroundColor: Colors.white,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(
                          tag: "Logo",
                          child: Image.asset(
                            'assets/gifs/load5.gif',
                            scale: 12,
                          )),
                      Text("Loading..")
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      }),
    );
  }
}
