import 'dart:async';
import 'dart:ui';
import 'package:asap_client/main.dart';
import 'package:asap_client/screen/screen_navi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  // 카카오 내비 앱으로 전환
  void startNavi() async {
    // 카카오 API 연동
    bool result = await NaviApi.instance.isKakaoNaviInstalled();
    if (result) {
      print('카카오내비 앱으로 길안내 가능');
      await NaviApi.instance.navigate(
        destination:
        Location(name: '카카오 판교오피스', x: '127.108640', y: '37.402111'),
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
  void ReviewDialog(){
    double? _ratingValue;
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(

            title: Column(
              children: <Widget>[

                new Text("안내받은 주차장은 어떠셨나요"),
                new Text("별점을 남겨주세요!"),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                    onRatingUpdate: (value) {
                      setState(() {
                        _ratingValue = value;
                      });
                    }),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage(title:'')));
                },
                child: new Text("확인"),
              ),
            ],
          );
        }
    );
  }
  void initState(){
    Timer(Duration(seconds:3), (){
      startNavi();
      Timer(Duration(seconds:1), (){
        ReviewDialog();
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery
        .of(context)
        .size;
    width = screenSize.width;
    height = screenSize.height;

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
                          '사용자 맞춤 \n 최적의 주차장으로 \n 안내합니다',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        Padding(
                          padding: EdgeInsets.all(height*0.03),
                        ),
                        const Text(
                          '신수동 공영주차장',
                          style: TextStyle(fontSize: 30),

                        ),
                        const Text(
                          '남은 거리 560m',
                          style: TextStyle(fontSize:18),
                        ),
                        const Text(
                          '예상 요금 : 2100원',
                          style: TextStyle(fontSize:18),
                        ),

                        /*
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: height * 0.02),
                            minimumSize: Size(width*0.5, height*0.015),
                          ),
                          onPressed: ()=>_gotoNavi(),
                          //onPressed: () => Navigator.push(context,
                          //    MaterialPageRoute(builder: (context) => NaviScreen())),
                          child: const Text(
                            'A. 신수동 공영주차장 ',
                            style: TextStyle(fontSize: 18),
                          ),
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
                          onPressed: ()=>_gotoNavi(),
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
                         */
                      ],
                    )
                )
            )
        )
    );
  }
}