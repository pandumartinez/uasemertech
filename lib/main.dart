import 'dart:html';

import 'package:dailymemedigest/screen/home.dart';
import 'package:dailymemedigest/screen/leaderboard.dart';
import 'package:dailymemedigest/screen/login.dart';
import 'package:dailymemedigest/screen/myCreation.dart';
import 'package:dailymemedigest/screen/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  Widget myDrawer() {
    return Drawer(
      elevation: 16.0,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              accountName: Text("active_user"),
              accountEmail: Text("xyz@gmail.com"),
              currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      NetworkImage("https://placekitten.com/150/150"))),
          ListTile(
              title: new Text("Home"),
              leading: new Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, 'home');
              }),
          ListTile(
              title: new Text("My Creation"),
              leading: new Icon(Icons.emoji_emotions_outlined),
              onTap: () {
                Navigator.pushNamed(context, 'myCreation');
              }),
          ListTile(
              title: new Text("Leaderboard"),
              leading: new Icon(Icons.leaderboard_outlined),
              onTap: () {
                Navigator.pushNamed(context, 'leaderboard');
              }),
          ListTile(
              title: new Text("Settings"),
              leading: new Icon(Icons.settings),
              onTap: () {
                Navigator.pushNamed(context, 'settings');
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
              label: "Leaderboard",
              icon: Icon(Icons.leaderboard)
            ),
            // BottomNavigationBarItem(
            //   label: "Settings",
            //   icon: Icon(Icons.settings)
            // ),
          ],
      ),
    );
  }
}
