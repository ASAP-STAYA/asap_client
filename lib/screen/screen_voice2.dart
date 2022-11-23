import 'dart:_http';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:asap_client/main.dart';

import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_selection.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt2;
import 'package:duration_button/duration_button.dart';
import 'package:http/http.dart' as http;
import '../provider/provider_user.dart';

/*
>>>>>>> 6333862b1ca03a5234f60524fae256c9b3b512a5
class Voice2 extends StatefulWidget {
  String id = '';
  Voice2(this.id);

  @override
  _Voice2 createState() => _Voice2(this.id);
}

class _Voice2 extends State<Voice2> {
  String id = '';
  _Voice2(this.id);

  @override
  void initState() {
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
*/

class SpeechScreen2 extends StatefulWidget {
  String id = '';
  SpeechScreen2(this.id);
  @override
  _SpeechScreenState2 createState() => _SpeechScreenState2(id);
}

class _SpeechScreenState2 extends State<SpeechScreen2> {
  String id = '';
  _SpeechScreenState2(this.id);

  stt2.SpeechToText _speech2 = stt2.SpeechToText();
  bool _isListening = false;
  String _text = '';
  double _confidence = 1.0;
  int parking = -1;

  Future<void> _submit() async {
    String new_name = id;
    new_name = id.replaceAll(' ', '');
    print(new_name);

    String token = context.read<UserProvider>().token;

    // var url = Uri.parse('http://localhost:8080/api/parking/latlng?searching=' + new_name);
    var url = Uri.parse('http://staya.koreacentral.cloudapp.azure.com:8080/api/parking/latlng?searching='+new_name); // 목적지 latlng
    var response = await http.get(url);
    print("0:" + response.body);
    List<dynamic> latlng = jsonDecode(response.body);
    // 네 주차필요
    if (parking == 1) {
      // url = Uri.parse('http://localhost:8080/api/parking/hasParkingLot?searching='+new_name);
      // 목적지에 주차장
      url = Uri.parse('http://staya.koreacentral.cloudapp.azure.com:8080/api/parking/hasParkingLot?searching=${new_name}&lat=${latlng[0]}&lng=${latlng[1]}');

      var response = await http.get(url);
      print("parking 1::" + response.body);

      if (response.body == "true") {
        // 주차가 필요하지만 목적지에 주차장이 있을 경우 그냥 목적지로 안내
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectScreen(
                    1, new_name, latlng[0].toString(), latlng[1].toString())));
      } else {
        // 추천 api 전송
        // url = Uri.parse('http://localhost:8080/api/parking/findParkingLot?lat=${latlng[0]}&lng=${latlng[1]});


        print("parking 11 token::" + token);
        url = Uri.parse('http://staya.koreacentral.cloudapp.azure.com:8080/api/parking/findParkingLot?lat=${latlng[0]}&lng=${latlng[1]}');
        var response = await http.get(url, headers: {
          HttpHeaders.authorizationHeader: token,
          'content-type': 'application/json'
        });
        print("parking 11::" + response.body);

        final body = jsonDecode(response.body); // 목적지 주차장 lat lng
        print(body);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectScreen(1, new_name,
                    body['lat'].toString(), body['lng'].toString())));
      }
    } else {
      // 아니오 주차 안함 -> 바로 목적지 경도로 안내
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SelectScreen(
                  0, new_name, latlng[0].toString(), latlng[1].toString())));
    }
  }

  late var locales = _speech2.locales();

  @override
  void initState() {
    super.initState();
    _speech2 = stt2.SpeechToText();
    locales = _speech2.locales();
  }

  Timer _timer = Timer(Duration(),(){});

  Future<void> _onBackPressed(BuildContext context) async {
    _timer.cancel();
    setState(() => _isListening = false);
    _speech2.stop();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'ASAP')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: const Color(0xff0f4c81),
      ),
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
            child: Icon(
              Icons.mic,
              size: 30,
              color: Colors.white,
            )
            //child: const Text("주차장 유무"),
            ),
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
                      child: const Text('주차가 필요하신가요?',
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

  void _listen2() async {
    if (!_isListening) {
      bool available = await _speech2.initialize(
        onStatus: (val) => print('onStatus44: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech2.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    _confidence = val.confidence;
                  }
                }),
            localeId: 'ko');
      }
      _timer= Timer(Duration(seconds: 5), () {
        setState(() => _isListening = false);
        _speech2.stop();
        print(_text);
        print(id);
        if (_text.contains('예') || _text.contains('네')) {
          parking = 1;
        } else {
          parking = 0;
        }

        _submit();
        /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SelectScreen(1, 'a',
                    '22', 'aa')));*/
      });
    } else {
      print('aaaaaa');
      setState(() => _isListening = false);
      _speech2.stop();
    }
  }
}
