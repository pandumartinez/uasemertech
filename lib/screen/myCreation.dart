import 'package:flutter/material.dart';

class MyCreation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyCreationState();
  }
}

class _MyCreationState extends State<MyCreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyCreation'),
      ),
      body: Center(
        child: Text('MyCreation Text'),
      ),
    );
  }
}
