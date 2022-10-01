import 'package:flutter/material.dart';

class NaviScreen extends StatefulWidget {
  @override
  _NaviScreenState createState() => _NaviScreenState();
}

class _NaviScreenState extends State<NaviScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Navi Page'),
          backgroundColor: Colors.amber,
          leading: Container(),
        ),
      ),
    );
  }

}
