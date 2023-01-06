import 'dart:convert';
import 'dart:io';

import 'package:dailymemedigest/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewPostState();
  }
}

class _NewPostState extends State<NewPost> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _imageCont = TextEditingController();
  TextEditingController _topTextCont = TextEditingController();
  TextEditingController _btmTextCont = TextEditingController();

  void submit() async {
    DateTime curtime = DateTime.now();
    String timeStr =
        "${curtime.day.toString()}${curtime.month.toString()}${curtime.year.toString()}${curtime.hour.toString()}${curtime.minute.toString()}";
    if (_image != null) {
      List<int> imageBytes = _image!.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      final response2 = await http.post(
          Uri.parse('https://ubaya.fun/flutter/160419137/uploadmeme.php'),
          body: {
            'name': "meme" + timeStr,
            'image': base64Image,
          });
      if (response2.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response2.body)));
        _imageCont.text = "https://ubaya.fun/flutter/160419137/img/meme/meme" +
            timeStr +
            ".jpg";
      }
    }
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
  void initState() {
    super.initState();
    setState(() {
      _imageCont.text =
          "https://icon-library.com/images/placeholder-image-icon/placeholder-image-icon-21.jpg";
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.link),
                      title: Text('Link'),
                      onTap: () {
                        Navigator.of(context).pop();
                        _image = null;
                      }),
                  new ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        _imgGallery();
                        Navigator.of(context).pop();
                        _imageCont.text = "Using image from gallery";
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgCamera();
                      Navigator.of(context).pop();
                      _imageCont.text = "Using image from Camera";
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  _imgCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 75,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Post New Meme"),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: _image != null
                                      ? FileImage(
                                          _image!,
                                        )
                                      : NetworkImage(_imageCont.text)
                                          as ImageProvider,
                                  fit: BoxFit.cover)),
                        )),
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
                      if (value == null && _image != null) {
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
        )));
  }
}
