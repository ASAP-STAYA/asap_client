import 'package:asap_client/screen/screen_setting.dart';
import 'package:asap_client/screen/screen_voice1.dart';
import 'package:flutter/material.dart';
import 'package:asap_client/provider/provider_user.dart';

import 'package:asap_client/screen/screen_sign_up.dart';
import 'package:asap_client/screen/screen_login.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_navi.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:asap_client/screen/screen_selection.dart';

void main() async {
  // kakao api 시작
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    // 앱
    nativeAppKey: 'dc549883cd9e704f17c4b5506784bf3f',
    // 웹
    //isJavaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
  );

  runApp(MultiProvider(providers: [
    ListenableProvider(create: (_) => UserProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ASAP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(
          seconds: 2,
          navigateAfterSeconds: MyHomePage(title: 'ASAP'),
          image: new Image.asset(
            'assets/images/image.png',
            alignment: Alignment.center,
          ),
          photoSize: 200.0,
          backgroundColor: Color(0xff0f4c81),
        )
        // home: SignUpScreen(),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({key, required this.title});

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

    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 40), minimumSize: Size(200, 100));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ASAP',
                style: const TextStyle(
                  fontFamily: 'EliceDigitalBaeum_TTF',
                  fontSize: 80.0,
                  color: const Color(0xff0f4c81),
                  fontWeight: FontWeight.w700,
                )),
            Padding(
              padding: EdgeInsets.all(width * 0.105),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0f4c81),
                minimumSize: Size(150, 50),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen())),
              child: const Text('회원가입',
                  style: TextStyle(
                    fontFamily: 'EliceDigitalBaeum_TTF',
                    fontSize: 20.0,
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.010),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0f4c81),
                minimumSize: Size(150, 50),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage())),
              child: const Text('로그인',
                  style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF', fontSize: 20.0)),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.010),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff0f4c81),
                minimumSize: Size(150, 50),
              ),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen())),
              child: const Text('설정',
                  style: TextStyle(
                      fontFamily: 'EliceDigitalBaeum_TTF', fontSize: 20.0)),
            ),
          ],
        ),
      ),
    );
  }
}
