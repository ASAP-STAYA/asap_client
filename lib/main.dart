import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:asap_client/model/model_user.dart';
import 'package:asap_client/provider/provider_user.dart';
import 'package:asap_client/screen/screen_navi.dart';
import 'package:asap_client/screen/screen_sign_up.dart';
import 'package:asap_client/screen/screen_selection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';
import 'package:provider/provider.dart';

void main() async {
  // kakao api 시작
  WidgetsFlutterBinding.ensureInitialized();

  final NATIVE_APP_KEY = '6a4ae5a36656e1e37b35889e4fd7b532';
  KakaoSdk.init(
    // 앱
    nativeAppKey: 'dc549883cd9e704f17c4b5506784bf3f',
    // 웹
    //isJavaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
  );

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


  runApp(MultiProvider(
      providers: [
        ListenableProvider(create: (_) => UserProvider()),
      ],
      child: MyApp()));


/*
  // Backend와 연동 (http)
  final url = Uri.parse('10.0.2.2:8080/api/parking/data');
  //final url = Uri.parse('https://raw.githubusercontent.com/dev-yakuza/users/master/api.json');
  //final url = Uri.parse('http://127.0.0.1:8080/api/user/1');
  final response = await http.get(url);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
*/

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASAP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ASAP'),
      // home: SignUpScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Size screenSize;
  late double width;
  late double height;

  @override
  void initSate() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/playstore.png', width: width * 0.7,),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen())),
              child: Text('회원가입'),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.025),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectScreen())),
              child: Text('내비 안내'),
            ),
          ],
        ),
      ),

    );
  }
}
