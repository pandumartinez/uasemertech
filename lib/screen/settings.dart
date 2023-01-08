import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingState();
  }
}

class _SettingState extends State<Setting> {
  File? _image;
  String _newFirstName = "";
  String _newLastName = "";
  TextEditingController _firstNameCont = TextEditingController();
  TextEditingController _lastNameCont = TextEditingController();
  bool? _newIsPrivate = false;

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    main();
  }

  void submit() async {
    final response = await http.post(
        Uri.parse("https://ubaya.fun/flutter/160419137/editaccount.php"),
        body: {
          'username': userAccount.username,
          'first_name': _newFirstName,
          'last_name': _newLastName,
          'url_image': "https://ubaya.fun/flutter/160419137/img/user/" +
              userAccount.username +
              ".jpg",
          'is_private': (_newIsPrivate == true ? 1 : 0).toString()
        });
    if (response.statusCode == 200) {
      print(response.body);
      Map json = jsonDecode(response.body);
      if (json['result'] == 'success') {
        if (!mounted) return;
        if (_image != null) {
          List<int> imageBytes = _image!.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          final response2 = await http.post(
              Uri.parse(
                  'https://ubaya.fun/flutter/160419137/uploadaccountprofile.php'),
              body: {
                'username': userAccount.username,
                'image': base64Image,
              });
          if (response2.statusCode == 200) {
            if (!mounted) return;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(response2.body)));
          }
        }

        setState(() {
          _firstNameCont.text = _newFirstName;
          _lastNameCont.text = _newLastName;
          userAccount.first_name = _firstNameCont.text;
          userAccount.last_name = _lastNameCont.text;
          userAccount.url_image =
              "https://ubaya.fun/flutter/160419137/img/user/" +
                  userAccount.username +
                  ".jpg";
          userAccount.is_private = _newIsPrivate ?? false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User info successfully changed')));
      }
    } else {
      throw ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User info change failed')));
      ;
    }
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
                  ListTile(
                      tileColor: Colors.white,
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                      onTap: () {
                        _imgGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgCamera();
                      Navigator.of(context).pop();
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
      imageQuality: 30,
      maxHeight: 256,
      maxWidth: 256,
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
      imageQuality: 60,
      maxHeight: 512,
      maxWidth: 512,
    );
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _firstNameCont.text = userAccount.first_name;
      _lastNameCont.text = userAccount.last_name;
      _newIsPrivate = userAccount.is_private;
      _newFirstName = _firstNameCont.text;
      _newLastName = _lastNameCont.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //  title: Text('Setting'),
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            doLogout();
          },
          // tooltip: 'Increment',
          child: const Icon(Icons.logout),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              alignment: Alignment.center,
              height: 150.0,
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(
                          _image!,
                        )
                      : NetworkImage(userAccount.url_image) as ImageProvider,
                ),
              ),
            ),
            Center(
              child: Column(children: [
                userAccount.is_private == false
                    ? Text(
                        userAccount.first_name + " " + userAccount.last_name,
                        style: TextStyle(fontSize: 16),
                      )
                    : Text(
                        (userAccount.first_name + " " + userAccount.last_name)
                            .replaceRange(
                                3,
                                (userAccount.first_name +
                                        " " +
                                        userAccount.last_name)
                                    .length,
                                "*" *
                                    (userAccount.first_name +
                                            " " +
                                            userAccount.last_name)
                                        .length),
                        style: TextStyle(fontSize: 16),
                      ),
                Text(
                  "Active since " + userAccount.registration_date,
                  style: TextStyle(fontSize: 18),
                ),
                Divider(
                  height: 5,
                  color: Colors.transparent,
                ),
                Text(
                  "@" + userAccount.username,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ]),
            ),
            Divider(
              height: 20,
              color: Colors.transparent,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {
                  _newFirstName = value;
                },
                controller: _firstNameCont,
                validator: (value) {
                  if (value == null && userAccount.first_name == "") {
                    value = "";
                  } else if (value == null && userAccount.first_name != "") {
                    value = userAccount.first_name;
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: 'First Name'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                onChanged: (value) {
                  _newLastName = value;
                },
                controller: _lastNameCont,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                ),
                validator: (value) {
                  if (value == null && userAccount.last_name == "") {
                    value = "";
                  } else if (value == null && userAccount.last_name != "") {
                    value = userAccount.last_name;
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: CheckboxListTile(
                title: Text("Private account endabled"),
                value: _newIsPrivate,
                onChanged: ((value) {
                  setState(() {
                    _newIsPrivate = value;
                  });
                }),
              ),
            ),
            Divider(
              height: 50,
              color: Colors.transparent,
            ),
            Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                )),
          ]),
        ));
  }
}
