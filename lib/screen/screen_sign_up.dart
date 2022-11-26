import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:asap_client/screen/screen_login.dart';

import '../provider/provider_user.dart';

import 'package:http/http.dart' as http;

import '../util/util_cost.dart';
import '../util/util_distance.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUpScreen();
  }
}

class _SignUpScreen extends State<SignUpScreen> {
  late Size screenSize;
  late double width;
  late double height;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordCheckController = TextEditingController();

  var _emailErrorMsg = '';
  var _passwordErrorMsg = '';
  var _passwordCheckErrorMsg = '';

  late UserProvider _userProvider;

  late List<bool> isSelectedMechanical = [false, true];
  late List<bool> isSelectedSmall = [false, true];
  late List<bool> isSelectedDistance = [false, false, false, true];
  late List<bool> isSelectedPrice = [false, false, false, true];

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    _userProvider = Provider.of<UserProvider>(context);

    void saveInLocal() {
      _userProvider.email = _emailController.text;
      _userProvider.name = _nameController.text;
      _userProvider.password = _passwordController.text;
      _userProvider.canMechanical = (isSelectedMechanical[0] == false);
      _userProvider.canNarrow = (isSelectedSmall[0] == false);
    }

    Future<String> saveUserInServer() async {
      late String userId;
      Uri userUri = Uri.parse("http://10.0.2.2:8080/api/auth/signup/");
      // Uri userUri = Uri.parse("http://localhost:8080/api/auth/signup/");
      // Uri userUri = Uri.parse(
      //     "http://staya.koreacentral.cloudapp.azure.com:8080/api/auth/signup/");

      final body = jsonEncode({
        "username": _userProvider.name,
        "email": _userProvider.email,
        "password": _userProvider.password,
        "dist_prefer": getDistanceFromSelectedList(isSelectedDistance),
        "cost_prefer": getCostFromSelectedList(isSelectedPrice),
        "can_mechanical": _userProvider.canMechanical,
        "can_narrow": _userProvider.canNarrow
      });

      final response = await http
          .post(userUri,
              headers: {'content-type': 'application/json'}, body: body)
          .catchError((onError) => onError);

      if (response.statusCode == 200 && response.body == "sign up success") {
        return "success";
      } else {
        return "[ERROR] same user";
      }
    }

    Future<bool> _submit() async {
      saveInLocal();
      final result = await saveUserInServer();

      if (result == "[ERROR] same user") {
        return false;
      } else {
        return true;
      }
    }

    Future<bool> _checkValidation() async {
      String emailPattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(emailPattern);

      setState(() {
        _emailErrorMsg = "";
        _passwordErrorMsg = "";
        _passwordCheckErrorMsg = "";
      });

      if (!regExp.hasMatch(_emailController.text)) {
        setState(() {
          _emailErrorMsg = "이메일 형식이 올바르지 않습니다";
        });
        return false;
      }
      if (_passwordController.text.length < 8) {
        setState(() {
          _passwordErrorMsg = "비밀번호는 8자리 이상이어야 합니다";
        });
        return false;
      }
      if (_passwordController.text != _passwordCheckController.text) {
        setState(() {
          _passwordCheckErrorMsg = "비밀번호가 일치하지 않습니다";
        });
        return false;
      }

      return true;
    }

    Future<void> alertSignUpFail() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 실패"),
            content: const Text("해당 이메일로 가입한 유저가 이미 존재합니다"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff0f4c81),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("확인"))
            ],
          );
        },
      );
    }

    Future<void> alertSignUpSuccess() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("회원가입 성공"),
            content: const Text("회원가입을 축하드립니다"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color(0xff0f4c81),
                  ),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())),
                  child: const Text("확인"))
            ],
          );
        },
      );
    }

    final _marginInputForm = width * 0.08;

    return SafeArea(
      child: Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              const Text('회원가입',
                  style: TextStyle(
                    fontFamily: 'EliceDigitalBaeum_TTF',
                    fontSize: 30.0,
                    color: Color(0xff0f4c81),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          _marginInputForm, height * 0.02, _marginInputForm, 0),
                      child: _inputForm("이름", _nameController, '', width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          _marginInputForm, 0, _marginInputForm, 0),
                      child: _inputForm(
                          "이메일", _emailController, _emailErrorMsg, width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          _marginInputForm, 0, _marginInputForm, 0),
                      child: _inputForm("비밀번호", _passwordController,
                          _passwordErrorMsg, width)),
                  Container(
                      margin: EdgeInsets.fromLTRB(_marginInputForm, 0,
                          _marginInputForm, height * 0.055),
                      child: _inputForm("비밀번호 확인", _passwordCheckController,
                          _passwordCheckErrorMsg, width)),
                ],
              ),
              const Text(
                '선호도를 알려주세요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'EliceDigitalBaeum_TTF'),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(_marginInputForm, height * 0.03,
                        _marginInputForm, height * 0.015),
                    child: _inputPrefer1("기계식 주차장"),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        _marginInputForm, 0, _marginInputForm, 0),
                    child: _inputPrefer1("좁은 주차장"),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                    child: _inputPrefer2(
                        "거리",
                        distanceToString(distances[0]),
                        distanceToString(distances[1]),
                        distanceToString(distances[2]),
                        distanceToString(distances[3])),
                  ),
                  Container(
                    margin:
                        EdgeInsets.fromLTRB(0, height * 0.02, 0, height * 0.05),
                    child: _inputPrefer2(
                        "요금",
                        costToString(costs[0]),
                        costToString(costs[1]),
                        costToString(costs[2]),
                        costToString(costs[3])),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                  primary: const Color(0xff0f4c81),
                  minimumSize: const Size(150, 50),
                ),
                onPressed: () async {
                  var isValidated = await _checkValidation();
                  if (isValidated == true) {
                    var isSubmitted = await _submit();
                    if (isSubmitted == true) {
                      await alertSignUpSuccess();
                    } else {
                      await alertSignUpFail();
                    }
                  }
                },
                child: const Text(
                  '가입하기',
                  style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF', fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputPrefer1(String type) {
    List<bool> isSelected;

    if ("기계식 주차장" == type) {
      isSelected = isSelectedMechanical;
    } else if ("좁은 주차장" == type) {
      isSelected = isSelectedSmall;
    } else {
      throw Exception("[ERROR] Invalid argument in _inputPrefer1");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: const TextStyle(
              fontSize: 18,
              fontFeatures: [FontFeature.tabularFigures()],
              fontFamily: 'EliceDigitalBaeum_TTF'),
        ),
        ToggleButtons(
            selectedColor: Colors.white,
            fillColor: const Color(0xff456795),
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                if (index == 0) {
                  isSelected[0] = true;
                  isSelected[1] = false;
                } else {
                  isSelected[0] = false;
                  isSelected[1] = true;
                }
              });
            },
            borderRadius: BorderRadius.circular(10),
            constraints: BoxConstraints(minHeight: height * 0.045),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: const Text(
                  '안 가!',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: const Text(
                  '상관 없어',
                  style: TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
            ])
      ],
    );
  }

  Widget _inputPrefer2(
      String type, String arg1, String arg2, String arg3, String arg4) {
    List<bool> isSelected;

    if ("거리" == type) {
      isSelected = isSelectedDistance;
    } else if ("요금" == type) {
      isSelected = isSelectedPrice;
    } else {
      throw Exception("[ERROR] Invalid argument in _inputPrefer2");
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: height * 0.015),
          child: Text(
            type,
            style: const TextStyle(
                fontSize: 18, fontFamily: 'EliceDigitalBaeum_TTF'),
          ),
        ),
        ToggleButtons(
            selectedColor: Colors.white,
            fillColor: const Color(0xff456795),
            isSelected: isSelected,
            onPressed: (int index) {
              setState(
                () {
                  if (index == 0) {
                    isSelected[0] = true;
                    isSelected[1] = isSelected[2] = isSelected[3] = false;
                  } else if (index == 1) {
                    isSelected[1] = true;
                    isSelected[0] = isSelected[2] = isSelected[3] = false;
                  } else if (index == 2) {
                    isSelected[2] = true;
                    isSelected[1] = isSelected[0] = isSelected[3] = false;
                  } else {
                    isSelected[3] = true;
                    isSelected[1] = isSelected[2] = isSelected[0] = false;
                  }
                },
              );
            },
            borderRadius: BorderRadius.circular(9),
            constraints: BoxConstraints(
                minHeight: height * 0.045, minWidth: width * 0.2),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg1,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg2,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg3,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg4,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
            ]),
      ],
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
          style: const TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontFamily: 'EliceDigitalBaeum_TTF'),
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
          style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontFamily: 'EliceDigitalBaeum_TTF'),
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
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontSize: 18,
            fontFeatures: [FontFeature.tabularFigures()],
            fontFamily: 'EliceDigitalBaeum_TTF'),
      ),
      Padding(padding: EdgeInsets.only(left: width * 0.06)),
      SizedBox(width: width * 0.5, child: textFormField),
    ],
  );
}
