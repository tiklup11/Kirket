import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:umiperer/screens/MyMatchesScreen.dart';
import 'package:umiperer/screens/LiveMatchesScreen.dart';
import 'package:umiperer/screens/upcoming_matches_screens.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;


// class MatchesHomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final tabs = [
//       "Live Matches",
//       "My Matches"
//     ];
//
//     final tabBarView = [
//       LiveMatchesScreen(),
//       MyMatchesScreen()
//     ];
//
//     return DefaultTabController(
//       length: tabs.length,
//       child: Scaffold(
//         drawer: Drawer(
//           // Add a ListView to the drawer. This ensures the user can scroll
//           // through the options in the drawer if there isn't enough vertical
//           // space to fit everything.
//           child: ListView(
//             // Important: Remove any padding from the ListView.
//             padding: EdgeInsets.zero,
//             children: <Widget>[
//               DrawerHeader(
//                 child: Text('Drawer Header'),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                 ),
//               ),
//               ListTile(
//                 title: Text('Item 1'),
//                 onTap: () {
//                   // Update the state of the app.
//                   // ...
//                 },
//               ),
//               ListTile(
//                 title: Text('Item 2'),
//                 onTap: () {
//                   // Update the state of the app.
//                   // ...
//                 },
//               ),
//             ],
//           ),
//         ),
//         appBar: AppBar(
//           // actions: [
//           //   PopupMenuItem(
//           //     value: 1,
//           //     child: Text("First"),),
//           //   PopupMenuItem(
//           //     value: 2,
//           //     child: Text("Second"),),
//           // ],
//           // automaticallyImplyLeading: false,
//           title: Text("Umpireer"),
//           bottom: TabBar(
//             isScrollable: true,
//             tabs: [
//               for (final tab in tabs) Tab(text: tab),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             for (final tab in tabBarView)
//               Center(
//                 child: tab,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///This is BottomNavigationBar

/// This is the stateful widget that the main application instantiates.
class MatchHomeScreens extends StatefulWidget {
  MatchHomeScreens({Key key}) : super(key: key);

  @override
  _MatchHomeScreensState createState() => _MatchHomeScreensState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MatchHomeScreensState extends State<MatchHomeScreens> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
   static List<Widget> _widgetOptions = <Widget>[
    LiveMatchesScreen(),
     MyMatchesScreen(),
     UpcomingMatchesScreen(),
     // ProfileScreen(),
  ];

  void _signOut() async{
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
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _signOut
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
        // fixedColor: Colors.blueAccent,
        // selectedLabelStyle: TextStyle(color: Colors.blueAccent),
        // selectedIconTheme: IconThemeData(color: Colors.blueAccent),
        unselectedIconTheme: IconThemeData(color: Colors.black38),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            // backgroundColor: Colors.black,
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person_sharp),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

//TODO: Move profile to app drawer