import 'dart:async';
import 'dart:ui';
import 'package:asap_client/main.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectScreen extends StatefulWidget{
  final int parking;
  final String xx;
  final String yy;
  final String name;
  const SelectScreen(this.parking,this.name,this.xx, this.yy);
  State<StatefulWidget> createState() {
    return _SelectScreen(this.parking,this.name, this.xx, this.yy);
  }
}

class _SelectScreen extends State<SelectScreen> {
  int counter = 0;
  late Size screenSize;
  late double width;
  late double height;
  int parking;
  String xx = '';
  String yy = '';
  String name = ''; //목적지 이름
  _SelectScreen(this.parking,this.name, this.xx, this.yy);

  // 카카오 내비 앱으로 전환
  void startNavi() async {
    // 카카오 API 연동

    print(xx);
    print(yy);
    bool result = await NaviApi.instance.isKakaoNaviInstalled();
    if (result) {
      print('카카오내비 앱으로 길안내 가능');
      await NaviApi.instance.navigate(
        destination: Location(name: '장소', x: yy, y: xx),
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
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("안내받은 주차장은 어떠셨나요?",style: TextStyle(
              fontFamily: 'EliceDigitalBaeum_TTF',fontWeight: FontWeight.w700)),
                Padding(
                  padding: EdgeInsets.all(height*0.001),
                ),
                new Text("별점을 남겨주세요!",style: TextStyle(
                  fontFamily: 'EliceDigitalBaeum_TTF',fontWeight: FontWeight.w700)),
              ],
            ),
            content:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:<Widget> [

                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff0f4c81),
                                  ),
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => MyHomePage(title:'')));
                                  },
                                  icon: Icon(Icons.mood,size:18),
                                  label: Text(
                                    '만족해요!',
                                    style: TextStyle(fontSize: 15, color: Colors.white,fontFamily: 'EliceDigitalBaeum_TTF'),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff0f4c81),
                                  ),
                                  onPressed: () => {Review_Reason_Dialog()},
                                  icon: Icon(Icons.mood_bad,size:18),
                                  label:Text(
                                    '별로예요',
                                    style: TextStyle(fontSize: 15, color: Colors.white,fontFamily: 'EliceDigitalBaeum_TTF'),
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
        }
    );
  }

  void Review_Reason_Dialog(){
    double? _ratingValue;
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(

            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text("어떤점이 불만족스러우셨나요?", style: TextStyle(
                  fontFamily: 'EliceDigitalBaeum_TTF',fontWeight: FontWeight.w700))
              ],
            ),
            content:
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget> [

                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 30),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => MyHomePage(title:'')));
                            },
                            icon: Icon(Icons.directions_car_rounded,size:13),
                            label: Text(
                              '거리가 멀어요',
                              style: TextStyle(fontSize: 11, color: Colors.white,fontFamily: 'EliceDigitalBaeum_TTF'),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(10, 30, 10, 30),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xff0f4c81),
                            ),
                            onPressed: (){
                              Navigator.pop(context);
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => MyHomePage(title:'')));},
                            icon: Icon(Icons.attach_money_rounded,size:13),
                            label:Text(
                              '요금이 비싸요',
                              style: TextStyle(fontSize: 11, color: Colors.white,fontFamily: 'EliceDigitalBaeum_TTF'),
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
        }
    );
  }

  void initState(){
    Timer(Duration(seconds:3), (){
      startNavi();
      if(this.parking == 1) {
        Timer(Duration(seconds: 1), () {
          ReviewDialog();
        });
      }
      else{
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyHomePage(title:'')));
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery
        .of(context)
        .size;
    width = screenSize.width;
    height = screenSize.height;
    String parking_name = ' '; //주차장 이름
    String parking_cost = ' '; //1시간 기준 요금
    String parking_space = ' '; //남은 자리 수

    Future<void> _submit() async {

      var url = Uri.parse("http");

      var response = await http.get(url);
      print("0:"+response.body);
      List<dynamic> parking_info = jsonDecode(response.body);
      parking_name = parking_info[0];
      parking_cost = parking_info[1];
      parking_space = parking_info[2];

    }


    Future<void> _onBackPressed(BuildContext context) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MyHomePage(title: 'ASAP')));
    }


    return SafeArea(
        child: Scaffold(

            body: WillPopScope(
                onWillPop: () async{
                  await _onBackPressed(context);
                  return true;
                },
            child: Container(
                child: Center(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(height*0.001),
                        ),
                        const Text(
                            '안내 시작',
                            style: TextStyle(
                              fontFamily: 'EliceDigitalBaeum_TTF',
                              fontSize: 40.0,
                              color: const Color(0xff0f4c81),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center
                        ),
                        Padding(
                          padding: EdgeInsets.all(height*0.05),
                        ),
                        if(parking == 1)...[
                          const Text(
                            '사용자 맞춤 \n 최적의 주차장으로 \n 안내합니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22,fontFamily: 'EliceDigitalBaeum_TTF'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height*0.05),
                          ),
                          Text(
                            parking_name, //주차장 이름
                            style: TextStyle(fontSize: 30,fontFamily: 'EliceDigitalBaeum_TTF'),
                          ),
                          Text(
                            parking_cost, //1시간 기준 요금
                            style: TextStyle(fontSize:22,fontFamily: 'EliceDigitalBaeum_TTF'),
                          ),
                          Text(
                            parking_space, //남은 자리 수
                            style: TextStyle(fontSize:22,fontFamily: 'EliceDigitalBaeum_TTF'),
                          ),
                        ]
                        else ...[
                          const Text(
                            '입력한 목적지로 안내를 시작합니다',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22,fontFamily: 'EliceDigitalBaeum_TTF'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height*0.1),
                          ),
                          Text(
                            this.name, //목적지 이름
                            style: TextStyle(fontSize: 30,fontFamily: 'EliceDigitalBaeum_TTF', fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height*0.02),
                          ),

                        ]
                      ],
                    )
                )
            )
        )
        )
    );
  }
}