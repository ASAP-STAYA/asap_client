import 'package:asap_client/screen/screen_setting.dart';
import 'package:asap_client/screen/screen_voice1.dart';
import 'package:flutter/material.dart';

class MainAfterLoginScreen extends StatelessWidget {
  late Size screenSize;
  late double width;
  late double height;

  MainAfterLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('ASAP',
                style: TextStyle(
                  fontFamily: 'EliceDigitalBaeum_TTF',
                  fontSize: 80.0,
                  color: Color(0xff0f4c81),
                  fontWeight: FontWeight.w700,
                )),
            Padding(
              padding: EdgeInsets.all(width * 0.105),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0f4c81),
                minimumSize: const Size(150, 50),
              ),
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SpeechScreen())),
              child: const Text('안내 시작',
                  style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF', fontSize: 20.0)),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.010),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0f4c81),
                minimumSize: const Size(150, 50),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen())),
              child: const Text('설정',
                  style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF', fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}

