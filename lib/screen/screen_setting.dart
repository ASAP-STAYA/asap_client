import 'dart:ui';

import 'package:asap_client/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/provider_user.dart';

class SettingScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingScreen> {
  late Size screenSize;
  late double width;
  late double height;

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

    void _submit() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyApp()));
    }

    final marginInputForm = width * 0.09;

    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(

              child: const Text(
                  '설정',
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
              child: Text(
                _userProvider.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(marginInputForm, height * 0.05,
                  marginInputForm, height * 0.015),
              child: _inputPrefer1("기계식 주차장"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(
                  marginInputForm, 0, marginInputForm, 0),
              child: _inputPrefer1("좁은 주차장"),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
              child: _inputPrefer2(
                  "거리", "~0.5km", "~1km", "~1.5km", "상관 없어"),
            ),
            Container(
              margin:
              EdgeInsets.fromLTRB(0, height * 0.02, 0, height * 0.05),
              child:
              _inputPrefer2("요금", "무료만", "~500원", "~1000원", "상관 없어"),
            ),
            Container(

              child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0f4c81),
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    minimumSize: Size(width,50),),
                onPressed: () => _submit(),
                //onPressed: () => {},
                child: const Text(
                  '확인',
                  style: TextStyle(fontFamily: 'EliceDigitalBaeum_TTF',fontSize: 18),
                ),
              ),
            )
          ]
        )

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
              fontSize: 22, fontFeatures: [FontFeature.tabularFigures()],fontFamily: 'EliceDigitalBaeum_TTF'),
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
            constraints: BoxConstraints(minHeight: height * 0.05),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: const Text(
                  '안 가!',
                  style: TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: const Text(
                  '상관 없어',
                  style: TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
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
            style: const TextStyle(fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
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
                minHeight: height * 0.05, minWidth: width * 0.2),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg1,
                  style: const TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg2,
                  style: const TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg3,
                  style: const TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg4,
                  style: const TextStyle(fontSize: 16,fontFamily: 'EliceDigitalBaeum_TTF'),
                ),
              ),
            ]),
      ],
    );
  }
}

