import 'dart:convert';
import 'dart:ui';
//import 'dart:html';

import 'package:dailymemedigest/class/account.dart';
import 'package:dailymemedigest/screen/home.dart';
import 'package:dailymemedigest/screen/leaderboard.dart';
import 'package:dailymemedigest/screen/login.dart';
import 'package:dailymemedigest/screen/myCreation.dart';
import 'package:dailymemedigest/screen/newpost.dart';
import 'package:dailymemedigest/screen/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Account userAccount = Account();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      print(result);
      fetchData(result).then((Account user) {
        userAccount = user;
        runApp(const MyApp());
      });
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "home": (context) => MyLogin(),
        "myCreation": (context) => MyCreation(),
        "leaderboard": (context) => Leaderboard(),
        "settings": (context) => Setting(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Daily Meme Digest'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: userAccount.is_private == false
                ? Text(userAccount.first_name + " " + userAccount.last_name)
                : Text((userAccount.first_name + " " + userAccount.last_name)
                    .replaceRange(
                        3,
                        (userAccount.first_name + " " + userAccount.last_name)
                            .length,
                        "*" *
                            (userAccount.first_name +
                                    " " +
                                    userAccount.last_name)
                                .length)),
            accountEmail: Text("@" + userAccount.username),
            currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(userAccount.url_image)),
            /*decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(userAccount.url_image),
                fit: BoxFit.cover
              )
            ),*/
          ),
          ListTile(
              title: new Text("Home"),
              leading: new Icon(Icons.home),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              }),
          ListTile(
              title: new Text("My Creation"),
              leading: new Icon(Icons.emoji_emotions_outlined),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              }),
          ListTile(
              title: new Text("Leaderboard"),
              leading: new Icon(Icons.leaderboard_outlined),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              }),
          ListTile(
              title: new Text("Settings"),
              leading: new Icon(Icons.settings),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              }),
          ListTile(
              title: new Text("Log Out"),
              leading: new Icon(Icons.logout),
              onTap: () {
                doLogout();
              }),
        ],
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  int _currentIndex = 0;
  final List<Widget> _screens = [
    Home(),
    MyCreation(),
    Leaderboard(),
    Setting()
  ];

  final List<Widget> _navBarPages = [
    Home(),
    MyCreation(),
    Leaderboard(),
    Setting(),
  ];

  final List<String> _title = [
    "Home",
    "My Creation",
    "Leaderboard",
    "Settings"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: myDrawer(),
      body: _navBarPages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        fixedColor: Colors.cyan,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "My Creation",
            icon: Icon(Icons.emoji_emotions_outlined),
          ),
          BottomNavigationBarItem(
              label: "Leaderboard", icon: Icon(Icons.leaderboard)),
          BottomNavigationBarItem(
              label: "Settings", icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
