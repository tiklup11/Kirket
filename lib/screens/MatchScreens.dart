import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/screens/LiveMatchesScreen.dart';
import 'package:umiperer/screens/about_us_page.dart';
import 'package:umiperer/screens/admin_access_page.dart';
import 'package:umiperer/screens/upcoming_matches_screens.dart';

///This is BottomNavigationBar

/// This is the stateful widget that the main application instantiates.
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
    // print('signing out');
    await FirebaseAuth.instance.signOut();
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _widgetOptions = <Widget>[
      MyMatchesScreen(
        user: widget.user,
      ),
      LiveMatchesScreen(),
      UpcomingMatchesScreen(),
      // ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black12,
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
            SizedBox(height: 4,),
            ListTile(
              tileColor: Colors.blueGrey.shade50,
              leading: Icon(Icons.alternate_email_rounded),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return AboutUsPage();
                }));
              },
            ),
            SizedBox(height: 4,),
            ListTile(
              tileColor: Colors.blueGrey.shade50,
              leading: Icon(Icons.login_rounded),
              title: Text('Logout'),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(color: Colors.black38),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_baseball),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            // backgroundColor: Colors.black,
            icon: Icon(Icons.home),
            label: 'Live Scores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_handball),
            label: 'Upcoming',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Log0ut"),
      onPressed: () {
        Navigator.pop(context);
        _signOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Would you like to log out?"),
      actions: [
        cancelButton,
        continueButton,
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
      leading: Icon(Icons.person_sharp),
      title: Text('Admin Access'),
      onTap: () {
        // Update the state of the app.
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AdminAccessPage();
        }));
      },
    );
  }
}

//TODO: Move profile to app drawer
