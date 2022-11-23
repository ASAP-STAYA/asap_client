import 'dart:async';

import 'package:asap_client/screen/screen_voice1.dart';
import 'package:flutter/material.dart';
import 'package:asap_client/main.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  Timer _timer = Timer(Duration(),(){});

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SpeechScreen()));
    });
  }

  Future<void> _onBackPressed(BuildContext context) async {
    _timer.cancel();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'ASAP')));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text(''),
          backgroundColor: const Color(0xff0f4c81),

        ),

        body: WillPopScope(
          onWillPop: () async {
          await _onBackPressed(context);
          return true;
          },
          child: const Center(
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
