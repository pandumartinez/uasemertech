import 'dart:convert';

import 'package:dailymemedigest/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPostState();
  }
}

class _NewPostState extends State<NewPost> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _imageCont = TextEditingController();
  TextEditingController _topTextCont = TextEditingController();
  TextEditingController _btmTextCont = TextEditingController();

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419137/newpost.php"),
        body: {
          'url_image_meme': _imageCont.text,
          'top_text': _topTextCont.text,
          'bottom_text': _btmTextCont.text,
          'username': userAccount.username,
        });
    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Post successfully Posted')));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Post failed to upload')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post New Meme"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                              image: NetworkImage(_imageCont.text),
                              fit: BoxFit.cover)),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      height: 400,
                      width: 400,
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        _btmTextCont.text,
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
                        _topTextCont.text,
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
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _imageCont.text = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || !Uri.parse(value).isAbsolute) {
                        return 'Image url is not valid';
                      }
                      return null;
                    },
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Top Text',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _topTextCont.text = value;
                      });
                    },
                    maxLines: 1,
                  )),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Bottom Text',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _btmTextCont.text = value;
                      });
                    },
                    maxLines: 1,
                  )),
              Divider(
                height: 20,
              ),
              Container(
                height: 40,
                width: 250,
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
                  child: Text('Post Meme'),
                ),
              ),
            ],
          ),
        ));
  }
}
