import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: NaverMap(
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }

  void _onMapCreated(NaverMapController controller) {
    if (_controller.isCompleted) _controller = Completer();
    _controller.complete(controller);
  }

}