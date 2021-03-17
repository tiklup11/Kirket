import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:umiperer/modals/constants.dart';
import 'package:umiperer/modals/size_config.dart';
import 'package:umiperer/screens/other_match_screens/MyMatchesScreen.dart';
import 'package:umiperer/screens/other_match_screens/about_us_page.dart';
import 'package:umiperer/screens/other_match_screens/admin_access_page.dart';
import 'package:umiperer/screens/live_scores_directory/catergory_screen.dart';
import 'package:umiperer/screens/other_match_screens/upcoming_matches_screens.dart';
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

  List<String> titleList;

  UpdateChecker _updateChecker;

  @override
  void dispose() {
    super.dispose();
    // _interstitialAd.dispose();
  }

  String title;

  @override
  void initState() {
    super.initState();

    titleList = [
      "Hey, ${widget.user.displayName}",
      "My Matches",
      "Future Tournaments"
    ];

    _updateChecker = new UpdateChecker(context: context);
    _widgetOptions = <Widget>[
      CategoryPage(
        user: widget.user,
      ),
      // LiveScreenHome(user: widget.user,),
      MyMatchesScreen(
        user: widget.user,
      ),
      UpcomingMatchesScreen(
        user: widget.user,
      ),
      // ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _updateChecker.check(context);
      } catch (e) {
        print(e);
      }
    });

    title = titleList[_selectedIndex];
    final space = SizedBox(
      height: (4 * SizeConfig.oneH).roundToDouble(),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        elevation: 0,
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
            widget.user.uid == "4VwUugdc6XVPJkR2yltZtFGh4HN2" ||
                    widget.user.uid == "V3lwRvXi2pXYFOnaA9JAC2lgvY42"
                ? adminTile()
                : Container(),
            space,
            customTile(
                iconData: Icons.update,
                text: "Update app",
                onTab: () {
                  _launchOnPs(PLAY_STORE_URL);
                }),
            space,
            customTile(
                iconData: Icons.error,
                text: "Report Issue",
                onTab: () {
                  reportBugDialog(context);
                }),
            space,
            customTile(
                iconData: Icons.person,
                text: "About us",
                onTab: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AboutUsPage();
                  }));
                }),
            space,
            customTile(
                iconData: Icons.stacked_line_chart_rounded,
                text: "Support Devs",
                onTab: () {
                  RewardedVideoAd.instance.load(
                      adUnitId: "ca-app-pub-7348080910995117/3729480926",
                      targetingInfo:
                          MobileAdTargetingInfo(childDirected: true));
                  supportDevsDialog(context: context);
                }),
            space,
            customTile(
                iconData: Icons.login_rounded,
                text: "Logout",
                onTab: () {
                  showAlertDialog(context: context);
                }),
          ],
        ),
      ),
      appBar: AppBar(
        // toolbarHeight: 100,
        automaticallyImplyLeading: false,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        // toolbarHeight: _selectedIndex == 0 ? 120 : 70,
        title: appBarTopRow(),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedFontSize: 13,
        unselectedFontSize: 13,
        unselectedIconTheme: IconThemeData(color: Colors.black38),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.live_tv_rounded),
            label: 'Live',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_cricket_outlined),
            label: 'Next',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  appBarTopRow() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset(
              'assets/images/kirket.png',
              height: SizeConfig.setHeight(40),
              width: SizeConfig.setWidth(120),
            ),
            // FloatingSearchAppBar(
            //   automaticallyImplyDrawerHamburger: false,
            // ),
            Builder(
              builder: (BuildContext context) => Bounce(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Hero(
                  tag: "Logo",
                  child: CircleAvatar(
                    radius: SizeConfig.setWidth(16),
                    backgroundImage: AssetImage("assets/images/logo.png"),
                  ),
                ),
              ),
            ),
            // SizedBox(width: SizeConfig.setWidth(16),),
            // Text(title,style: TextStyle(color: Colors.black),),
          ],
        ),
        //[THIS IS FOR SEARCHIING]
        // _selectedIndex==0?
        // Container(
        //   height: 40,
        //   margin: EdgeInsets.only(bottom: 8,top: 4),
        //   padding: EdgeInsets.symmetric(horizontal: (10*SizeConfig.oneW).roundToDouble()),
        //   decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.circular(10),
        //       border: Border.all(color: Colors.black12,width: 2)
        //   ),
        //   child: FloatingSearchAppBar(
        //     // body: Text("HE:LO"),
        //     automaticallyImplyDrawerHamburger: false,
        //   ),
        // ):Container()
      ],
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
      content: Text(
          "This app is free for everyone, app services are running due to ads. Watch an ad to support the app devs. Thanks 😁"),
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

  adminTile() {
    return ListTile(
      // tileColor: Colors.blueGrey.shade50,
      leading: Icon(Icons.lock_rounded),
      title: Text('Admin Access'),
      onTap: () {
        // Update the state of the app.
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AdminAccessPage();
        }));
      },
    );
  }

  customTile({String text, IconData iconData, Function onTab}) {
    return ListTile(
      // tileColor: Colors.blueGrey.shade50,
      leading: Icon(iconData),
      title: Text(text),
      onTap: onTab,
    );
  }

  _launchEmail() async {
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

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(height: 112, color: color);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

//TODO: Move profile to app drawer

}
