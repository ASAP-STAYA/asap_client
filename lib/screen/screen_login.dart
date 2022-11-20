import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_sign_up.dart';
import 'package:asap_client/screen/screen_welcome.dart';
import 'package:provider/provider.dart';
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
        appBar: AppBar(
          title: const Text('LOG IN'),
        ),

        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: <Widget>[

              Container(
                  margin: EdgeInsets.fromLTRB(_marginInputForm, 170, _marginInputForm, 0),
                  child: _inputForm(
                      "이메일", _emailController, _emailErrorMsg, width)),
              Container(
                  margin: EdgeInsets.fromLTRB(_marginInputForm, 20, _marginInputForm, 0),
                  child: _inputForm("비밀번호", _passwordController,
                      _passwordErrorMsg, width)),
              const SizedBox(height: 80.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  minimumSize: Size(width*0.5, height*0.015),
                ),
                // onPressed: () => Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => Welcome())),
                onPressed: _callAPI,
                child: const Text(
                  '로그인',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
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
          style: const TextStyle(color: Colors.red, fontSize: 14),
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
          style: const TextStyle(color: Colors.red, fontSize: 13),
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
            fontSize: 18, fontFeatures: [FontFeature.tabularFigures()]),
      ),
      Padding(padding: EdgeInsets.only(left: width * 0.06)),
      SizedBox(width: width * 0.4, child: textFormField),
    ],
  );
}