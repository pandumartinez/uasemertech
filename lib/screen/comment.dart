import 'dart:convert';

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
  Meme? _m;

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
      Map json = jsonDecode(value);
      _m = Meme.fromJson(json['data']);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget tampilData() {
    if (_m == null) {
      return const CircularProgressIndicator();
    }
    return Card(
        child: Container(
            height: 500,
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
                                image: NetworkImage(_m!.url_image),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        height: 400,
                        width: 400,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          _m!.bottom_text,
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
                          _m!.top_text,
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
                  height: 50,
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
                          Text(_m!.number_likes.toString() + " likes"),
                        ],
                      ),
                    ],
                  ),
                ),
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
                                itemCount: _m?.users?.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  return ListTile(
                                    title: Text(_m?.users?[index]['username']),
                                    subtitle: Text(
                                        _m?.users?[index]['comment_content']),
                                  );
                                })),
                      ],
                    ))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: tampilData(),
          )
        ],
      ),
    );
  }
}
