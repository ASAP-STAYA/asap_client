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

void main() async {
  // kakao api 시작
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    // 앱
    nativeAppKey: 'dc549883cd9e704f17c4b5506784bf3f',
    // 웹
    //isJavaScriptAppKey: '${YOUR_JAVASCRIPT_APP_KEY}',
  );

  runApp(MultiProvider(
      providers: [
        ListenableProvider(create: (_) => UserProvider()),
      ],
      child: MyApp()));
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
      home: const MyHomePage(title: 'ASAP'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Image.asset('images/playstore.png'),
                iconSize: width*0.75,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Voice1())),
            ),

            Padding(
              padding: EdgeInsets.all(width * 0.025),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen())),
              child: Text('회원가입'),
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.002),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage())),
              child: Text('로그인'),
            ),
           Padding(
              padding: EdgeInsets.all(width * 0.002),
            ),
            ElevatedButton(
              onPressed: () =>
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingScreen())),
              child: Text('Settings'),
            ),
          ],
        ),
      ),

    );
  }
}
