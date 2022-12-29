import 'dart:convert';

import 'package:dailymemedigest/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/meme.dart';

class Comment extends StatefulWidget {
  int memeID;
  Comment({super.key, required this.memeID});

  @override
  State<StatefulWidget> createState() {
    return _CommentState();
  }
}

class _CommentState extends State<Comment> {
  final _formKey = GlobalKey<FormState>();
  String _comment = "";
  Meme? post;

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419096/showcomment.php"),
        body: {'meme_id': widget.memeID.toString()});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    fetchData().then((value) {
      setState(() {
        Map json = jsonDecode(value);
        post = Meme.fromJson(json['data']);
      });
    });
  }

  void addcomment() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419137/addcomment.php"),
        body: {
          'comment': _comment,
          'meme_id': widget.memeID.toString(),
          'user': userAccount.username,
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Comment added')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('There was an error when connecting to the server')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget tampilData(Meme? _m) {
    if (_m == null) {
      return const CircularProgressIndicator();
    }
    return Column(
      children: <Widget>[
        Card(
            child: Container(
                height: 475,
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 400,
                      height: 400,
                      child: Stack(
                        children: [
                          Container(
                            height: 400,
                            width: 400,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(_m.url_image),
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            height: 400,
                            width: 400,
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              _m.bottom_text,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            height: 400,
                            width: 400,
                            alignment: Alignment.topCenter,
                            child: Text(
                              _m.top_text,
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 400,
                      height: 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.all(5),
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                      ))),
                              Text(_m.number_likes.toString() + " likes"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ))),
        Divider(
          height: 20,
        ),
        Card(
            elevation: 10,
            margin: const EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _m.users?.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                            title: Text(_m.users?[index]['username']),
                            subtitle: Text(_m.users?[index]['comment_content']),
                          );
                        })),
              ],
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Comment'),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height - 75,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: tampilData(post),
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width - 70,
                            height: 70,
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Write a comment',
                              ),
                              onChanged: (value) {
                                _comment = value;
                              },
                            )),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState != null &&
                                !_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Please check your input again')));
                            } else {
                              setState(() {
                                addcomment();
                                bacaData();
                              });
                            }
                          },
                          child: Icon(Icons.send),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
