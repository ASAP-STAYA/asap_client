import 'dart:async';

import 'package:asap_client/screen/screen_main_after_login.dart';
import 'package:flutter/material.dart';
import 'package:asap_client/main.dart';

class Welcome extends StatefulWidget {
  @override
  _Welcome createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  final Timer _timer = Timer(const Duration(),(){});

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
    });
  }

  Future<void> _onBackPressed(BuildContext context) async {
    _timer.cancel();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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