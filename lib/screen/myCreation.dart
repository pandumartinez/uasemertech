import 'dart:convert';

import 'package:dailymemedigest/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/meme.dart';

class MyCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCreationState();
  }
}

class _MyCreationState extends State<MyCreation> {
  String _temp = 'waiting API respond…';

  List<Meme> Ms = [];

  Future<String> fetchData() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419096/mycreation.php"),
        body: {'username': userAccount.username});
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
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Stack(
                    children: [
                      Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(Memes[index].url_image),
                                fit: BoxFit.cover)),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        height: 400,
                        width: 400,
                        alignment: Alignment.bottomCenter,
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
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        height: 400,
                        width: 400,
                        alignment: Alignment.topCenter,
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
                    ],
                  ),
                ),
              ],
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyCreation'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarMeme(Ms),
          )
        ],
      ),
    );
  }
}
