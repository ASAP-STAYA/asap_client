import 'dart:ui';

import 'package:asap_client/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_user.dart';

class SignUpScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();

  var _emailErrorMsg = '';
  var _passwordErrorMsg = '';
  var _passwordCheckErrorMsg = '';

  late UserProvider _userProvider;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    _userProvider = Provider.of<UserProvider>(context);

    void _submit() {
      _userProvider.email = _emailController.text;
      _userProvider.name = _nameController.text;
      _userProvider.password = _passwordController.text;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    }

    void _checkValidation() async {
      String emailPattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(emailPattern);

      setState(() {
        _emailErrorMsg = "";
        _passwordErrorMsg = "";
        _passwordCheckErrorMsg = "";
      });

      if (!regExp.hasMatch(_emailController.text)) {
        setState(() {
          _emailErrorMsg = "이메일 형식이 올바르지 않습니다";
        });
        return;
      }
      if (_passwordController.text.length < 8) {
        setState(() {
          _passwordErrorMsg = "비밀번호는 8자리 이상이어야 합니다";
        });
        return;
      }
      if (_passwordController.text != _passwordCheckController.text) {
        setState(() {
          _passwordCheckErrorMsg = "비밀번호가 일치하지 않습니다";
        });
        return;
      }

      _submit();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('SIGN UP'),
          leading: Container(),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(35, 10, 35, 0),
                      child: _inputForm("이름", _nameController, '', width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: _inputForm(
                          "이메일", _emailController, _emailErrorMsg, width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: _inputForm("비밀번호", _passwordController,
                          _passwordErrorMsg, width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(35, 0, 35, 0),
                      child: _inputForm("비밀번호 확인", _passwordCheckController,
                          _passwordCheckErrorMsg, width)),
                ],
              ),
              const Text('선호도'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _inputForm(String name, TextEditingController textEditingController,
    String errorMsg, double width) {
  final TextFormField textFormField;
  if ("이메일" == name) {
    textFormField = TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(
          errorMsg,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  } else if ("이름" == name) {
    textFormField = TextFormField(
      keyboardType: TextInputType.name,
      controller: textEditingController,
    );
  } else if ("비밀번호" == name || "비밀번호 확인" == name) {
    textFormField = TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(
          errorMsg,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  } else {
    throw Exception("[ERROR] Invalid argument in _inputForm");
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Padding(padding: EdgeInsets.only(left: width * 0.05)),
      Text(
        name,
        style: const TextStyle(
            fontSize: 18, fontFeatures: [FontFeature.tabularFigures()]),
      ),
      Padding(padding: EdgeInsets.only(left: width * 0.06)),
      SizedBox(width: width * 0.5, child: textFormField),
    ],
  );
}
