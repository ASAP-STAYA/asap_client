import 'dart:async';
import 'dart:collection';
import 'package:asap_client/screen/screen_main_after_login.dart';
import 'package:asap_client/screen/screen_voice2.dart';
import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:duration_button/duration_button.dart';
import 'package:asap_client/main.dart';

class ReturnValue {
  String? result = '';
  ReturnValue({this.result});
}

// 데이터 전달에 사용할 클래스
class Arguments {
  String arg; // 전달에 사용할 데이터
  ReturnValue? returnValue;
  Arguments({this.arg = '', this.returnValue});
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;

  late var locales = _speech.locales();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    locales = _speech.locales();
  }

  Timer _timer = Timer(Duration(),(){});
  Timer _timer2 = Timer(Duration(),(){});

  Future<void> _onBackPressed(BuildContext context) async {

    _timer2.cancel();
    _timer.cancel();
    setState(() => _isListening = false);
    _speech.stop();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: const Color(0xff0f4c81),
          endRadius: 80.0,
          duration: const Duration(milliseconds: 500),
          repeatPauseDuration: const Duration(milliseconds: 500),
          repeat: true,

          //child: FloatingActionButton(
          //  onPressed: _listen ,
          //  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          //),
          child: DurationButton(
              duration: const Duration(seconds: 1),
              onPressed: () {},
              backgroundColor: const Color(0xff0f4c81),
              splashFactory: NoSplash.splashFactory,
              borderRadius: BorderRadius.circular(100.0),
              width: 70,
              height: 70,
              onComplete: _listen,
              child: Icon(
                Icons.mic,
                size: 30,
                color: Colors.white,
              )),
        ),
        body: WillPopScope(
          onWillPop: () async {
            await _onBackPressed(context);
            return true;
          },
          child: Center(
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                  height: 300,
                  alignment: Alignment(0.0, 0.0),
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                        child: const Text('어디로 안내할까요?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'EliceDigitalBaeum_TTF',
                              fontSize: 35.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ))),
                    Text(
                      _text,
                      style: const TextStyle(
                        fontFamily: 'EliceDigitalBaeum_TTF',
                        fontSize: 30.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ]))),
        ),
      );

  }

  void _listen() async {
    print("AAAA");
    print(_text);
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus33: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                }),
            localeId: 'ko');
      }
      _timer = Timer(const Duration(seconds: 5), () {
        setState(() => _isListening = false);
        _speech.stop();
        print(_text);
        _timer2 = Timer(const Duration(seconds: 3), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SpeechScreen2(_text)));
        });
      });
    } else {
      print('aaaaaa');
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}
