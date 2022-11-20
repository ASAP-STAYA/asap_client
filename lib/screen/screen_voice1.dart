import 'dart:async';
import 'package:asap_client/screen/screen_voice2.dart';
import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_selection.dart';


class Voice1 extends StatefulWidget {
  @override
  _Voice1 createState() => _Voice1();
}

class _Voice1 extends State<Voice1> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Voice2()));
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('어디로 안내할까요?',style:TextStyle(fontSize: 25)),
        ),
      ),
    );
  }
}