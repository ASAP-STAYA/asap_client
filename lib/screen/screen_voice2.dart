import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:asap_client/main.dart';

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



  stt2.SpeechToText _speech2 = stt2.SpeechToText();
  bool _isListening = false;
  String _text =  '';
  double _confidence = 1.0;
  int parking = -1;


  Future<void> _submit() async {
    String new_name = id;
    new_name = id.replaceAll(' ','');
    print('AAA');
    print(id);
    print(new_name);
     var url = Uri.parse('http://localhost:8080/api/parking/latlng?searching='+new_name);
    //var url = Uri.parse('http://staya.koreacentral.cloudapp.azure.com:8080/api/parking/latlng?searching='+new_name);
    // print(url);
    var response = await http.get(url);
    print("0:"+response.body);
    List<dynamic> latlng = jsonDecode(response.body);
    if(parking == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(1, latlng[0].toString(), latlng[1].toString())));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen(0, latlng[0].toString(), latlng[1].toString())));
    }
  }

  late var locales =  _speech2.locales();

  @override
  void initState(){
    super.initState();
    _speech2 = stt2.SpeechToText();
    locales = _speech2.locales();
  }

  Future<void> _onBackPressed(BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'ASAP')));
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
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
          onComplete: _listen2,
          child: Icon(Icons.mic, size:30, color: Colors.white,)
          //child: const Text("주차장 유무"),
        ),
      ),

      body: WillPopScope(
          onWillPop: () async{
            await _onBackPressed(context);
            return true;
          },
          child: Center(
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              height: 300,
              alignment: Alignment(0.0,0.0),
              child: Column(

                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0,0,100),
                        child: const Text('주차가 필요하신가요?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'EliceDigitalBaeum_TTF',
                              fontSize: 35.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ))),
                    Text(_text,

                      style: const TextStyle(
                        fontFamily: 'EliceDigitalBaeum_TTF',
                        fontSize: 30.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ]
              )
          )
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
        if (_text.contains('예') || _text.contains('네')){
          parking = 1;
        }
        else{
          parking = 0;
        }


        _submit();

      });
    }else {
      print('aaaaaa');
      setState(() => _isListening = false);
      _speech2.stop();
    }
  }


}

