import 'dart:async';

import 'package:asap_client/screen/screen_main_after_login.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        body: Center(
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
