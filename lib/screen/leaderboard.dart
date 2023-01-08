import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/leadboard.dart';

class Leaderboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaderboardState();
  }
}

class _LeaderboardState extends State<Leaderboard> {
  String _temp = 'waiting API respond…';

  List<Leadboard> Ls = [];

  Future<String> fetchData() async {
    final response = await http
        .get(Uri.https("ubaya.fun", '/flutter/160419137/getleaderboard.php'));
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
      for (var leader in json['data']) {
        Leadboard l = Leadboard.fromJson(leader);
        Ls.add(l);
      }
      setState(() {
        // _temp = Ms[2].url_image;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      bacaData();
    });
  }

  Widget DaftarLeaderboard(Leaderboards) {
    if (Leaderboards != null) {
      return ListView.builder(
          itemCount: Leaderboards.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return new Card(
                child: Container(
              width: 400,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          Leaderboards[index].url_image.toString()),
                    ),
                  ),
                  Leaderboards[index].isPrivate == false
                      ? Text(Leaderboards[index].firstname.toString() +
                          " " +
                          Leaderboards[index].lastname.toString())
                      : Text((Leaderboards[index].firstname.toString() +
                              " " +
                              Leaderboards[index].lastname.toString())
                          .replaceRange(
                              2,
                              (Leaderboards[index].firstname.toString() +
                                      " " +
                                      Leaderboards[index].lastname.toString())
                                  .length,
                              "*" *
                                  (Leaderboards[index].firstname.toString() +
                                          " " +
                                          Leaderboards[index]
                                              .lastname
                                              .toString())
                                      .length)),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(5),
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )),
                      Text(Leaderboards[index].number_likes.toString() +
                          " likes"),
                    ],
                  ),
                ],
              ),
            ));
          });
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Leaderboard'),
      ),*/
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: DaftarLeaderboard(Ls),
          )
        ],
      ),
    );
  }
}
