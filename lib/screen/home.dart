import 'dart:convert';

import 'package:dailymemedigest/main.dart';
import 'package:dailymemedigest/screen/comment.dart';
import 'package:dailymemedigest/screen/newpost.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/meme.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  String _temp = 'waiting API respond…';

  List<Meme> Ms = [];

  Future<String> fetchData() async {
    final response = await http
        .get(Uri.https("ubaya.fun", '/flutter/160419096/memelist.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to read API');
    }
  }

  bacaData() {
    Future<String> data = fetchData();
    data.then((value) {
      Map json = jsonDecode(value);
      for (var meme in json['data']) {
        Meme m = Meme.fromJson(meme);
        Ms.add(m);
      }
      setState(() {
        // _temp = Ms[2].url_image;
      });
    });
  }

  void addLike(Meme post) async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419137/addlike.php"),
        body: {
          'id': post.id.toString(),
        });

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;

        setState(() {
          post.number_likes++;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('There was an error while connecting to the server')));
      }
    }
  }

  // bacaData() {
  //   Future<String> data = fetchData();
  //   data.then((value) {
  //     setState(() {
  //       _temp = value;
  //     });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  Widget DaftarMeme(Memes) {
    if (Memes != null) {
      return ListView.builder(
          itemCount: Memes.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
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
                              GestureDetector(
                                child: Container(
                                  height: 400,
                                  width: 400,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              Memes[index].url_image),
                                          fit: BoxFit.cover)),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Comment(memeID: Memes[index].id),
                                    ),
                                  );
                                },
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                height: 400,
                                width: 400,
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  Memes[index].bottom_text.toString(),
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
                                  Memes[index].top_text.toString(),
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
                                          onPressed: () {
                                            if (Memes[index].creator_id !=
                                                userAccount.id) {
                                              addLike(Memes[index]);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ))),
                                  Text(Memes[index].number_likes.toString() +
                                      " likes"),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          Comment(memeID: Memes[index].id),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.comment,
                                  color: Colors.blue,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarMeme(Ms),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewPost()));
        },
        tooltip: 'Create Post',
        child: const Icon(Icons.add),
      ),
    );
  }
}
