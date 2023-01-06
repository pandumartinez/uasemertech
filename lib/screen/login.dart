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
          ),
          Container(
            alignment: Alignment.topCenter,
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'data:image/png;base64,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'),
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
