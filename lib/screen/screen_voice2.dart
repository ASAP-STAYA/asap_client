import 'dart:async';
import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_selection.dart';




class Voice2 extends StatefulWidget {
  @override
  _Voice2 createState() => _Voice2();
}

class _Voice2 extends State<Voice2> {
  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen()));
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('주차가 필요하신가요?',style:TextStyle(fontSize: 25)),
        ),
      ),
    );
  }
}