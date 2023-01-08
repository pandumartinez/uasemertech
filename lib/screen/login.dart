import 'dart:convert';

import 'package:dailymemedigest/class/account.dart';
import 'package:dailymemedigest/screen/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class MyLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  late String _user_id;
  late String _user_password;
  late String error_login;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user_id = "";
    _user_password = "";
    error_login = "";
  }

  void doLogin() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419137/login.php"),
        body: {'user_id': _user_id, 'user_password': _user_password});
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        userAccount = Account.fromJson(json['data']);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString("user_id", _user_id);
        prefs.setString("user_name", userAccount.username);
        main();
      } else {
        setState(() {
          error_login = "Incorrect user or password";
        });
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Divider(
            height: 10,
            color: Colors.transparent,
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            "Daily Meme Digest",
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(
            height: 10,
            color: Colors.transparent,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                _user_id = value;
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter username'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                _user_password = value;
              },
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password'),
            ),
          ),
          if (error_login != "")
            Text(
              error_login,
              style: TextStyle(color: Colors.red),
            ),
          Divider(
            height: 20,
            color: Colors.transparent,
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: Column(children: [
                Container(
                  height: 50,
                  width: 250,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: OutlinedButton(
                    style: ButtonStyle(),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.blue, fontSize: 25),
                    ),
                  ),
                ),
                Divider(
                  height: 10,
                  color: Colors.transparent,
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      doLogin();
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
              ]))
        ]),
      ),
    );
  }
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString("user_id") ?? '';
  return user_id;
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("user_id");
  main();
}

Future<Account> fetchData(user_id) async {
  final response = await http.post(
      Uri.parse("https://ubaya.fun/flutter/160419137/login.php"),
      body: {'user_id': user_id});
  if (response.statusCode == 200) {
    Map json = jsonDecode(response.body);
    return Account.fromJson(json['data']);
  } else {
    throw Exception('Failed to read API');
  }
}
