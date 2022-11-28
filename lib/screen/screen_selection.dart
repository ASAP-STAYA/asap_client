import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:asap_client/main.dart';
import 'package:asap_client/screen/screen_main_after_login.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../provider/provider_user.dart';

class SelectScreen extends StatefulWidget {
  final int parking;
  final String xx;
  final String yy;
  final String name;
  final int rate;
  final int capacity;
  final String parkingname;
  final int dest_parking;
  SelectScreen(this.parking, this.name, this.xx, this.yy, this.dest_parking, this.parkingname, this.rate, this.capacity);
  State<StatefulWidget> createState() {
    return _SelectScreen(this.parking, this.name, this.xx, this.yy, this.dest_parking, this.parkingname, this.rate, this.capacity);
  }
}

class _SelectScreen extends State<SelectScreen> {
  int counter = 0;
  late Size screenSize;
  late double width;
  late double height;
  int parking;
  int dest_parking = 1;
  String xx = '';
  String yy = '';
  String name = ''; // 목적지 이름
  int rate = -1;
  int capacity = -1;
  String parkingname =''; // 추천받은 주차장 이름
  _SelectScreen(this.parking, this.name, this.xx, this.yy, this.dest_parking, this.parkingname, this.rate, this.capacity);

  // 카카오 내비 앱으로 전환
  void startNavi() async {
    // 카카오 API 연동
    print(xx);
    print(yy);
    bool result = await NaviApi.instance.isKakaoNaviInstalled();
    if (result) {
      print('카카오내비 앱으로 길안내 가능');
      await NaviApi.instance.navigate(
        destination: Location(name: name, x: yy, y: xx),
        option: NaviOption(coordType: CoordType.wgs84),
      );
    } else {
      print('카카오내비 미설치');
      // 카카오내비 설치 페이지로 이동
      launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
    }
    print('카카오 내비 끝');
  }

  // 종료 후 리뷰페이지로 전환
  Future<void> ReviewDialog(token) async {
    double? _ratingValue;
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("안내받은 주차장은 어떠셨나요?",
                    style: TextStyle(
                        fontFamily: 'EliceDigitalBaeum_TTF',
                        fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.all(height * 0.001),
                ),
                const Text("별점을 남겨주세요!",
                    style: TextStyle(
                        fontFamily: 'EliceDigitalBaeum_TTF',
                        fontWeight: FontWeight.w700)),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainAfterLoginScreen()));
                            },
                            icon: const Icon(Icons.mood, size: 13),
                            label: const Text(
                              '만족해요!',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: 'EliceDigitalBaeum_TTF'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: () => {Review_Reason_Dialog(token)},
                            icon: const Icon(Icons.mood_bad, size: 13),
                            label: const Text(
                              '별로예요',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: 'EliceDigitalBaeum_TTF'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> saveReviewInServer(
      String token, double dist, double cost, int discontent) async {
    Uri preferenceUri =
        // Uri.parse("http://10.0.2.2:8080/api/auth/signup/preference/");
        // Uri.parse("http://localhost:8080/api/auth/signup/preference/");
        Uri.parse(
            "http://staya.koreacentral.cloudapp.azure.com:8080/api/review/save");

    final body =
        jsonEncode({"dist": dist, "cost": cost, "discontent": discontent});

    final response = await http
        .post(preferenceUri,
            headers: {
              HttpHeaders.authorizationHeader: token,
              'content-type': 'application/json'
            },
            body: body)
        .catchError((onError) => onError);

    if (response.statusCode != 200) {
      throw Exception("[ERROR] can't create review of user");
    }
  }

  Future<void> Review_Reason_Dialog(token) async {
    double? _ratingValue;
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: const <Widget>[
                Text("어떤점이 불만족스러우셨나요?",
                    style: TextStyle(
                        fontFamily: 'EliceDigitalBaeum_TTF',
                        fontWeight: FontWeight.w700))
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: () async {
                              await saveReviewInServer(token, 0.0, 0.0, 0);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MainAfterLoginScreen()));
                            },
                            icon: const Icon(Icons.directions_car_rounded,
                                size: 13),
                            label: const Text(
                              '거리가 멀어요',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontFamily: 'EliceDigitalBaeum_TTF'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: () async {
                              await saveReviewInServer(token, 0.0, 0.0, 1);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const MyHomePage(title: '')));
                            },
                            icon: const Icon(Icons.attach_money_rounded,
                                size: 13),
                            label: const Text(
                              '요금이 비싸요',
                              style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontFamily: 'EliceDigitalBaeum_TTF'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Timer _timer = Timer(const Duration(), () {});
  Timer _timer2 = Timer(const Duration(), () {});
  void initState() {
    _timer2 = Timer(const Duration(seconds: 3), () {
      startNavi();
      if (parking == 1 && dest_parking == 0) {
        _timer = Timer(const Duration(seconds: 1), () {
          ReviewDialog(context.read<UserProvider>().token);
        });
      } else {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;
    String parkingName = parkingname; //주차장 이름
    int parkingRate = rate; //1시간 기준 요금
    int parkingCapacity = capacity; //남은 자리 수

    Future<void> _onBackPressed(BuildContext context) async {
      _timer.cancel();
      _timer2.cancel();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainAfterLoginScreen()));
    }
    print("PPPPARKING" + parking.toString());
    print("PPPPARKINGDDD" + dest_parking.toString());
    return SafeArea(
        child: Scaffold(
            body: WillPopScope(
                onWillPop: () async {
                  await _onBackPressed(context);
                  return true;
                },
                child: Container(
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(height * 0.001),
                            ),
                            const Text('안내 시작',
                                style: TextStyle(
                                  fontFamily: 'EliceDigitalBaeum_TTF',
                                  fontSize: 40.0,
                                  color: Color(0xff0f4c81),
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center),
                            Padding(
                              padding: EdgeInsets.all(height * 0.05),
                            ),
                            if (parking == 1) ...[

                              if(dest_parking == 1)...[
                                //목적지에 주차장이 있을 때
                                const Text(
                                  '목적지에 주차장이 있습니다. \n 목적지로 안내합니다.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(height * 0.05),
                                ),
                                Text(
                                  name, // 목적지 이름
                                  style: const TextStyle(
                                      fontSize: 30, fontFamily: 'EliceDigitalBaeum_TTF'),
                                )
                              ]
                              else ...[
                                const Text(
                                  '사용자 맞춤 \n 최적의 주차장으로 \n 안내합니다.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(height * 0.05),
                                ),
                                Text(
                                  parkingName, //주차장 이름
                                  style: const TextStyle(
                                      fontSize: 30, fontFamily: 'EliceDigitalBaeum_TTF'),
                                ),
                                Text(
                                  '1시간 기준 요금: '+parkingRate.toString()+'원', //1시간 기준 요금
                                  style: const TextStyle(
                                      fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
                                ),
                                Text(
                                  '현재 남은 자리 수: '+parkingCapacity.toString()+'칸', //남은 자리 수
                                  style: const TextStyle(
                                      fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
                                ),
                              ]
                            ] else ...[
                              const Text(
                                '입력한 목적지로 안내를 시작합니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontFamily: 'EliceDigitalBaeum_TTF'),
                              ),
                              Padding(
                                padding: EdgeInsets.all(height * 0.1),
                              ),
                              Text(
                                name, //목적지 이름
                                style: const TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'EliceDigitalBaeum_TTF',
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: EdgeInsets.all(height * 0.02),
                              ),
                            ]
                          ],
                        ))))));
  }
}
