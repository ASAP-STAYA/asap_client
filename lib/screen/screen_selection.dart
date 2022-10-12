import 'dart:ui';
import 'package:asap_client/main.dart';
import 'package:asap_client/screen/screen_navi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';

class SelectScreen extends StatefulWidget{
  State<StatefulWidget> createState() {
    return _SelectScreen();
  }
}

class _SelectScreen extends State<SelectScreen> {
  int counter = 0;
  late Size screenSize;
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery
        .of(context)
        .size;
    width = screenSize.width;
    height = screenSize.height;

    void _gotoNavi() async{


      bool result = await NaviApi.instance.isKakaoNaviInstalled();
      if (result){
        print('카카오 내비 앱이 존재합니다');
        await NaviApi.instance.navigate(
            destination: Location(name: '카카오 판교오피스', x: '127.108640', y: '37.402111'),
          option: NaviOption(coordType: CoordType.wgs84),
        );
      } else {
        print('카카오 내비 미설치 -> 카카오내비 설치 페이지로 이동합니다');
        // 카카오 내비 설치 페이지로 이동
        launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
      }

    }
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(title: Text("Recommendations For You!"),
                backgroundColor: Colors.deepPurpleAccent),
            body: Container(
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        const Text(
                          '어디로 안내할까요?',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 30),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width*0.1),
                        ),

                        Padding(
                          padding: EdgeInsets.all(width*0.008),
                        ),
                         const Text(
                           '남은 거리 : 1,500m, 1시간 예상 요금 : 2100원',
                           textAlign: TextAlign.center,
                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                         ),
                        Padding(
                          padding: EdgeInsets.all(width*0.08),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: height * 0.02),
                              minimumSize: Size(width*0.5, height*0.015),
                          ),
                          onPressed: () => _gotoNavi(),
                          child: const Text(
                            'B. 서강대역 환승 공영주차장 ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(width*0.008),
                        ),
                        const Text(
                          '남은 거리 : 1,000m, 1시간 예상 요금 : 3500원',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                )
            )
        )
    );
  }
}