import 'dart:async';
import 'dart:collection';
import 'package:asap_client/screen/screen_voice2.dart';
import 'package:flutter/material.dart';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:duration_button/duration_button.dart';

class Voice1 extends StatefulWidget {
  @override
  _Voice1 createState() => _Voice1();
}

class _Voice1 extends State<Voice1> {
  @override
  void initState(){
    super.initState();
    //Timer(Duration(seconds: 10), (){

    //  Navigator.push(context, MaterialPageRoute(builder: (context) => Voice2(title: _text)));

    //});
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class ReturnValue{
  String? result = '';
  ReturnValue({this.result});
}
// 데이터 전달에 사용할 클래스
class Arguments {
  String arg;   // 전달에 사용할 데이터
  ReturnValue? returnValue;
  Arguments({this.arg: '', this.returnValue});
}


class SpeechScreen extends StatefulWidget{
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>{

  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  };

  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '목적지를 말하세요';
  double _confidence = 1.0;

  late var locales =  _speech.locales();

  @override
  void initState(){
    super.initState();
    _speech = stt.SpeechToText();
    locales = _speech.locales();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: Text(''),

      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 800),
        repeatPauseDuration: const Duration(milliseconds: 800),
        repeat: true,

        //child: FloatingActionButton(
        //  onPressed: _listen ,
        //  child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        //),
        child: DurationButton(
          duration: const Duration(seconds: 1),
          onPressed: () {},
          backgroundColor: Colors.blueAccent,
          splashFactory: NoSplash.splashFactory,
          onComplete: _listen,
          child: Icon(Icons.mic)
        ),

      ),

      body: SingleChildScrollView(
        reverse: true,

        child: Container(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: TextHighlight(
              text: _text,
              words : LinkedHashMap<String, HighlightedWord>(),
              textStyle: const TextStyle(
                fontSize: 32.0,
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
          ),
        ),

      ),

    );

  }

  void _listen() async{

    if (!_isListening){
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus33: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available){
        setState(()=> _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0){
              _confidence = val.confidence;
            }
          }),
          localeId: 'ko'
        );
      }
      Timer(Duration(seconds: 5), (){

        setState(() => _isListening = false);
        _speech.stop();
        print(_text);
        Timer(Duration(seconds: 5), (){

          Navigator.push(context, MaterialPageRoute(builder: (context) => Voice2(_text)));

        });
      });
    }else {
      print('aaaaaa');
      setState(() => _isListening = false);
      _speech.stop();
    }
  }


}

