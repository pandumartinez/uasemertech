import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //  title: Text('Setting'),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            doLogout();
          },
          // tooltip: 'Increment',
          child: const Icon(Icons.logout),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              height: 150.0,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    NetworkImage("https://placekitten.com/150/150"),
              ),
            ),
            Center(
              child: Column(children: [
                Text(
                  "(Firstname + Lastname)",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "Active since (month + year)",
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "(email)",
                  style: TextStyle(fontSize: 16),
                ),
              ]),
            ),
            Divider(height: 20,),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                // onChanged: (value) {
                //   _user_id = value;
                // },
                decoration: InputDecoration(
                    labelText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                // onChanged: (value) {
                //   _user_id = value;s
                // },
                decoration: InputDecoration(
                    labelText: 'Last Name',),
              ),
            ),
            Divider(height: 50,),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      // doLogin();
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }
}
