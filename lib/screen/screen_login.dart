import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size screenSize;
  late double width;
  late double height;
  final _emailErrorMsg = '';
  final _passwordErrorMsg = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _callAPI() async {

    var url = Uri.parse('http://staya.koreacentral.cloudapp.azure.com:8080/api/auth/signin');
    Map data1 = {
      'email': 'user@test.com',
      'password': '12345678'
    };
    var response = await http.post(url, body: json.encode(data1), headers: {
      'Content-Type': 'application/json'
    });
    String token = response.body.toString();
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Welcome()));
  }


  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    final _marginInputForm = width * 0.09;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
              Container(

                child: const Text(
                    '로그인',
                    style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF',
                      fontSize: 30.0,
                      color: const Color(0xff0f4c81),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(_marginInputForm, 150, _marginInputForm, 0),
                  child: _inputForm(
                      "이메일", _emailController, _emailErrorMsg, width)),
              Container(
                  margin: EdgeInsets.fromLTRB(_marginInputForm, 20, _marginInputForm, 0),
                  child: _inputForm("비밀번호", _passwordController,
                      _passwordErrorMsg, width)),
              SizedBox(height: 80.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0f4c81),
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  minimumSize: Size(width,50)
                ),
                // onPressed: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Welcome())),
                onPressed: _callAPI,
                child: const Text(
                  '로그인',
                  style: TextStyle(fontSize: 18,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

Widget _inputForm(String type, TextEditingController textEditingController,
    String errorMsg, double width) {
  final TextFormField textFormField;
  if ("이메일" == type) {
    textFormField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(
          errorMsg,
          style: const TextStyle(color: Colors.red, fontSize: 14,fontFamily: 'EliceDigitalBaeum_TTF'),
        ),
      ),
    );
  } else if ("이름" == type) {
    textFormField = TextFormField(
      keyboardType: TextInputType.name,
      controller: textEditingController,
    );
  } else if ("비밀번호" == type || "비밀번호 확인" == type) {
    textFormField = TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(
          errorMsg,
          style: const TextStyle(color: Colors.red, fontSize: 13,fontFamily: 'EliceDigitalBaeum_TTF'),
        ),
      ),
    );
  } else {
    throw Exception("[ERROR] Invalid argument in _inputForm");
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        type,
        style: const TextStyle(
            fontSize: 18, fontFeatures: [FontFeature.tabularFigures()],fontFamily: 'EliceDigitalBaeum_TTF'),
      ),
      Padding(padding: EdgeInsets.only(left: width * 0.06)),
      SizedBox(width: width * 0.4, child: textFormField),
    ],
  );
}