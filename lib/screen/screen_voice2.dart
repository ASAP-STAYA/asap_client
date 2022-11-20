import 'dart:async';
import 'package:flutter/material.dart';
import 'package:asap_client/screen/screen_selection.dart';


class Voice2 extends StatefulWidget {
  @override
  _Voice2 createState() => _Voice2();
}

class _Voice2 extends State<Voice2> {
  late Size screenSize;
  late double width;
  late double height;
  int parking = -1;
  @override
  void initState(){
    super.initState();
    /*Timer(Duration(seconds: 3), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectScreen()));
    });*/
  }
  Widget build(BuildContext context) {

    screenSize = MediaQuery.of(context).size;
    width = screenSize.width;
    height = screenSize.height;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(height * 0.2),
              ),
              Text('주차가 필요하신가요?',style:TextStyle(fontSize: 25)),
              Padding(
                padding: EdgeInsets.all(height * 0.01),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(

                    onPressed: () => {
                        parking = 1,
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SelectScreen(parking))),
                      },
                    child: Text('네'),
                  ),
                  Padding(
                    padding: EdgeInsets.all(width * 0.01),
                  ),
                  ElevatedButton(

                    onPressed: () => {
                        parking = 0,
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SelectScreen(parking))),
                        },
                        child: Text('아니오'),
                  ),
                ]
              )
            ],
          ),

        ),
      ),
    );
  }
}