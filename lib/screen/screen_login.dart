import 'dart:convert';

import 'package:asap_client/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:ui';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size screenSize;
  late double width;
  late double height;
  late UserProvider _userProvider;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _submit() async {
    var url = Uri.parse('http://10.0.2.2:8080/api/auth/signin/');

    final logInBody = {
      'email': _emailController.text,
      'password': _passwordController.text
    };

    var response = await http.post(url,
        body: json.encode(logInBody),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode != 200) {
      return false;
    }

    _userProvider.token = response.body.toString();
    return true;
  }

  Future<void> alertLogInFail() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("로그인 실패"),
          content: const Text("이메일 또는 비밀번호를 다시 확인해주세요"),
          actions: <Widget>[
            ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("확인"))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    _userProvider = Provider.of<UserProvider>(context);

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
                  margin: EdgeInsets.fromLTRB(
                      _marginInputForm, 170, _marginInputForm, 0),
                  child: _inputForm(
                      "이메일", _emailController, width)),
              Container(
                  margin: EdgeInsets.fromLTRB(
                      _marginInputForm, 20, _marginInputForm, 0),
                  child: _inputForm(
                      "비밀번호", _passwordController, width)),
              const SizedBox(height: 80.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  minimumSize: Size(width * 0.5, height * 0.015),
                ),
                onPressed: () async {
                  await _submit().then((value) {
                    if (value == true) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Welcome()));
                    } else {
                      alertLogInFail();
                    }
                  });
                },
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
    double width) {
  final TextFormField textFormField;
  if ("이메일" == type) {
    textFormField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: textEditingController,
    );
  } else if ("비밀번호" == type) {
    textFormField = TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      controller: textEditingController,
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
