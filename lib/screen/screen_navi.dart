import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// Naver map LatLng 클래스
class LocationClass extends LatLng {
  final double latitude;
  final double longitude;
  const LocationClass({required this.latitude, required this.longitude}) : super(latitude, longitude);
}


class NaviScreen extends StatefulWidget{
  @override
  State<NaviScreen> createState() =>_NaviScreen();
}


class _NaviScreen extends State<NaviScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<NaverMapController> _controller = Completer();
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

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('공영주차장으로 안내를 시작합니다'),
        ),
        body: Center(
          child: Column(
            children:[
              Expanded(child:
                NaverMap(
                  onMapCreated: _onMapCreated,
                ),
                flex: 10,
              ),
              Expanded(child:
                TextButton(
                    onPressed: () => ReviewDialog(),
                    child: const Text(
                        '안내 종료',
                        style: TextStyle(fontSize: 30, color: Colors.green),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );


  }

  // 리뷰 창 띄움
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
                  },
                  child: new Text("확인"),
              ),
            ],
          );
        }
    );
  }
  // naver map 그려줌
  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }


}