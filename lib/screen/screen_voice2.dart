import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_selection.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt2;
import 'package:duration_button/duration_button.dart';
import 'package:http/http.dart' as http;


class Voice2 extends StatefulWidget {
  String id='';
  Voice2(this.id);

  @override
  _Voice2 createState() => _Voice2(this.id);
}

class _Voice2 extends State<Voice2> {
  String id='';
  _Voice2(this.id);


  @override
  void initState(){
    super.initState();
    //int parking = 0;
    //Timer(Duration(seconds: 10), (){

    //  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(parking)));
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
      home: SpeechScreen(id),
    );
  }
}

class SpeechScreen extends StatefulWidget{
  String id='';
  SpeechScreen(this.id);
  @override
  _SpeechScreenState createState() => _SpeechScreenState(id);
}

class _SpeechScreenState extends State<SpeechScreen>{
  String id='';
  _SpeechScreenState(this.id);

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

  stt2.SpeechToText _speech2 = stt2.SpeechToText();
  bool _isListening = false;
  String _text = '주차를 하시겠습니까?';
  double _confidence = 1.0;
  int parking = -1;


  Future<void> _submit() async {

    print(id);
    String new_name = id;
    new_name = id.replaceAll(' ','');
    print('AAA');
    print(id);
    print(new_name);
    var url = Uri.parse('http://localhost:8080/api/parking/latlng?searching='+new_name);
    print(url);
    Map data = {
     'name': _text
    };
    var response = await http.get(url);

    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');



    if(parking == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(1,response.body[0],response.body[1])));

    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(0,response.body[0],response.body[1])));
    }

    ////////to popup
  }

  late var locales =  _speech2.locales();

  @override
  void initState(){
    super.initState();
    _speech2 = stt2.SpeechToText();
    locales = _speech2.locales();
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
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
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
          onComplete: _listen2,
          child: Icon(Icons.mic)
          //child: const Text("주차장 유무"),
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

  void _listen2() async{

    if (!_isListening){
      bool available = await _speech2.initialize(

        onStatus: (val) => print('onStatus44: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available){
        setState(()=> _isListening = true);
        _speech2.listen(
            onResult: (val) => setState(() {
              _text= val.recognizedWords;
              if (val.hasConfidenceRating && val.confidence > 0){
                _confidence = val.confidence;
              }
            }),
            localeId: 'ko'
        );
      }
      Timer(Duration(seconds: 5), (){

        setState(() => _isListening = false);
        _speech2.stop();
        print(_text);
        print(id);
        //if (_text.contains('예') || _text.contains('네')){

        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(1)));
       // }
        //else{
        //  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(0)));
        //}
        _submit();
      });
    }else {
      print('aaaaaa');
      setState(() => _isListening = false);
      _speech2.stop();
    }
  }


}

