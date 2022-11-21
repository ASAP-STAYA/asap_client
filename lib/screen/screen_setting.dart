import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:asap_client/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/provider_user.dart';
import '../util/util_distance.dart';
import '../util/util_cost.dart';

class SettingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingScreen();
  }
}

class _SettingScreen extends State<SettingScreen> {
  late Size screenSize;
  late double width;
  late double height;

  late UserProvider _userProvider;

  late List<bool> isSelectedMechanical = [false, false];
  late List<bool> isSelectedSmall = [false, false];
  late List<bool> isSelectedDistance = [false, false, false, false];
  late List<bool> isSelectedPrice = [false, false, false, false];

  Future<void> init(String token) async {
    Uri patchUri = Uri.parse("http://10.0.2.2:8080/api/preference/");

    final response = await http.get(patchUri, headers: {
      HttpHeaders.authorizationHeader: token,
      'content-type': 'application/json'
    });

    if (response.statusCode != 200) {
      throw Exception("[ERROR] Can't get user preference from server");
    }

    final body = jsonDecode(response.body);

    isSelectedDistance[getIndexOfDistance(body["dist_prefer"])] = true;
    isSelectedPrice[getIndexOfCost(body["cost_prefer"])] = true;

    if (body["can_mechanical"] == true) {
      isSelectedMechanical[1] = true;
    } else {
      isSelectedMechanical[0] = true;
    }

    if (body["can_narrow"] == true) {
      isSelectedSmall[1] = true;
    } else {
      isSelectedSmall[0] = true;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      init(context.read<UserProvider>().token).then((_) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    _userProvider = Provider.of<UserProvider>(context);

    Future<bool> _submit() async {
      Uri patchUri = Uri.parse("http://10.0.2.2:8080/api/preference/");

      final body = jsonEncode({
        "dist_prefer": getDistanceFromSelectedList(isSelectedDistance),
        "cost_prefer": getCostFromSelectedList(isSelectedPrice),
        "can_mechanical": (isSelectedMechanical[0] == false),
        "can_narrow": (isSelectedSmall[0] == false),
      });

      final response = await http.patch(patchUri, body: body, headers: {
        HttpHeaders.authorizationHeader: _userProvider.token,
        'content-type': 'application/json'
      });

      if (response.statusCode != 200) {
        return false;
      }
      return true;
    }

    final marginInputForm = width * 0.09;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('개인 설정'),
        ),
        body: ListView(
          children: <Widget>[
            Text(
              _userProvider.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(marginInputForm, height * 0.03,
                      marginInputForm, height * 0.015),
                  child: _inputPrefer1("기계식 주차장"),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      marginInputForm, 0, marginInputForm, 0),
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
                  padding: EdgeInsets.symmetric(vertical: height * 0.015)),
              onPressed: () async {
                await _submit().then((isSubmitted) {
                  if (isSubmitted = true) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const MyApp()));
                  }
                });
              },
              child: const Text(
                '설정 저장하기',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
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
              fontSize: 18, fontFeatures: [FontFeature.tabularFigures()]),
        ),
        ToggleButtons(
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
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: const Text(
                  '상관 없어',
                  style: TextStyle(fontSize: 16),
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
            style: const TextStyle(fontSize: 18),
          ),
        ),
        ToggleButtons(
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
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg2,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg3,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: height * 0.015),
                child: Text(
                  arg4,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ]),
      ],
    );
  }
}

