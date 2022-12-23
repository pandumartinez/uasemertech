import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _username = "";
  String _password = "";
  String _repassword = "";

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419096/register.php"),
        body: {
          'username': _username,
          'password': _password,
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Account Created"),
                  content: Text(
                      "Your account have succesfully created \n Please login with your new account"),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: const Text("Ok")),
                  ],
                ));
      } else {
        throw Exception('Failed to read API');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('There was an error when connecting to the server')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register New Account"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                "Daily Meme Digest",
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Create Account",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(
                height: 100,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    onChanged: (value) {
                      _username = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      } else if (value.length < 6) {
                        return 'Please create password with 6 or more characters';
                      } else
                        return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                    onChanged: (value) {
                      _repassword = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please re-enter your password';
                      } else if (_password != _repassword) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                  )),
              Divider(
                height: 100,
              ),
              Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        !_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please check your input again')));
                    } else {
                      submit();
                    }
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              )),
            ],
          ),
        ));
  }
}
