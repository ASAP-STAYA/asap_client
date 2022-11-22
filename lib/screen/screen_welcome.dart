import 'dart:async';

import 'package:asap_client/screen/screen_voice1.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Voice1()));
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: const Color(0xff0f4c81),
        ),
        body: const Center(
          child: Text('반가워요!',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'EliceDigitalBaeum_TTF',
                  fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}
