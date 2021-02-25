import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/screens/about_us_page.dart';
import 'package:umiperer/screens/admin_access_page.dart';
import 'package:umiperer/screens/live_scores_directory/live_screen_home.dart';
import 'package:umiperer/screens/upcoming_matches_screens.dart';
import 'package:umiperer/services/UpdateChecker.dart';
import 'package:url_launcher/url_launcher.dart';

///This is BottomNavigationBar

/// This is the stateful widget that the main application instantiates.
/// mqd
class MatchHomeScreens extends StatefulWidget {
  MatchHomeScreens({this.user});
  final User user;

  @override
  _MatchHomeScreensState createState() => _MatchHomeScreensState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MatchHomeScreensState extends State<MatchHomeScreens> {

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions;

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<String> titleList = [
    "Live Scores",
    "My Matches",
    "Upcomings"
  ];

  UpdateChecker _updateChecker;

  @override
  void dispose() {
    super.dispose();
    // _interstitialAd.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _updateChecker = new UpdateChecker(context: context);
    _widgetOptions = <Widget>[
      LiveScreenHome(user: widget.user,),
      MyMatchesScreen(
        user: widget.user,
      ),
      UpcomingMatchesScreen(user: widget.user,),
      // ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      try {
        _updateChecker.check(context);
      } catch (e) {
        print(e);
      }
    });

    String title = titleList[_selectedIndex];
    final space =SizedBox(height: (4*SizeConfig.oneH).roundToDouble(),);

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.displayName),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(widget.user.photoURL),
                // backgroundColor:Colors.white,
              ),
            ),
            widget.user.uid=="4VwUugdc6XVPJkR2yltZtFGh4HN2" || widget.user.uid=="V3lwRvXi2pXYFOnaA9JAC2lgvY42"?
                adminTile():Container(),
            space,
            customTile(iconData: Icons.update,text: "Update app",
            onTab: (){
              _launchOnPs(PLAY_STORE_URL);
            }),
            space,
            customTile(iconData:Icons.error,text: "Report Issue",
                onTab:(){
                  reportBugDialog(context);
                }),
            space,
            customTile(iconData:Icons.stacked_line_chart_rounded,text: "Support Devs",
                onTab:(){
                  RewardedVideoAd.instance.load(
                    adUnitId: "ca-app-pub-7348080910995117/3729480926",
                    targetingInfo:MobileAdTargetingInfo(childDirected: true)
                  );
                  supportDevsDialog(context: context);
            }),
            space,
            customTile(iconData:Icons.person,text: "About us",
                onTab:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return AboutUsPage();
                  }));
                }),
            space,
            customTile(iconData:Icons.login_rounded,text: "Logout",
            onTab: (){
              showAlertDialog(context: context);
            }),
          ],
        ),
      ),
      appBar: AppBar(
        // elevation: 0.1,
        title: Text(title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.black38),
        // selectedIconTheme: IconThemeData(color: Colors.blueGrey.shade600),
        // selectedItemColor: Colors.blueGrey.shade600,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Live Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_handball),
            label: 'Upcoming',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  _launchOnPs(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  supportDevsDialog({BuildContext context}) {
    Widget cancelButton = TextButton(
      child: Text("Nope"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget logoutButton = TextButton(
      child: Text("Okays"),
      onPressed: () {
        RewardedVideoAd.instance.show();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Support Devs"),
      content: Text("This app is free for everyone, app services are running due to ads. Watch an ad to support the app devs. Thanks 😁"),
      actions: [
        cancelButton,
        logoutButton,
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



  showAlertDialog({BuildContext context}) {
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget logoutButton = TextButton(
      child: Text("Log0ut"),
      onPressed: () {
        Navigator.pop(context);
        _signOut();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Would you like to log out?"),
      actions: [
        cancelButton,
        logoutButton,
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

  adminTile(){
    return ListTile(
      tileColor: Colors.blueGrey.shade50,
      leading: Icon(Icons.lock_rounded),
      title: Text('Admin Access'),
      onTap: () {
        // Update the state of the app.
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AdminAccessPage();
        }));
      },
    );
  }

  customTile({String text,IconData iconData,Function onTab}){
    return ListTile(
      tileColor: Colors.blueGrey.shade50,
      leading: Icon(iconData),
      title: Text(text),
      onTap: onTab,
    );
  }
}

_launchEmail() async{
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: K_EMAIL,
    // queryParameters: {
    //   'subject': 'Example Subject & Symbols are allowed!'
    // }
  );
  launch(_emailLaunchUri.toString());
}

reportBugDialog(context) async {
  await showDialog<String>(
    context: context,
    // barrierDismissible: false,
    builder: (BuildContext context) {
      String title = "Report";
      String message =
          "The app is in early development stage, means you can find some issues. Please report us with the screenshot of the issue. Stay with the Latest Version. Thanks";
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("Okays"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text("Report"),
            onPressed: () {
              _launchEmail();
            },
          ),
        ],
      );
    },
  );


}

//TODO: Move profile to app drawer
