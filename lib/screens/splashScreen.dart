import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/screens/kingScreen1.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _space = 0;
  int _noOfSeconds = 0;
  late Timer _everySecond;

  @override
  void initState() {
    super.initState();

    // defines a timer
    _everySecond = Timer.periodic(Duration(milliseconds: 25), (Timer t) {
      if (_noOfSeconds <= 120) {
        // print(_space);
        // print(_noOfSeconds);
        setState(() {
          _space = _space + 0.1;
          _noOfSeconds++;
        });
      }
    });

    Timer(
        Duration(seconds: 6),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => KingScreen())));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  // height: 250.0,
                  // width: 350.0,
                  height: SizeConfig.blockSizeVertical! * 40,
                  width: SizeConfig.blockSizeHorizontal! * 70,
                  // margin: EdgeInsets.fromLTRB(20, 200, 20, 0),
                  child: CircularText(
                    children: [
                      TextItem(
                        text: Text(
                          "Royal Advisor".toUpperCase(),
                          style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent
                            // foreground: Paint()
                            //   ..style = PaintingStyle.stroke
                            //   ..strokeWidth = 1
                            //   ..color = Colors.blue[700]!,
                          ),
                        ),
                        space: _space,
                        startAngle: -163,
                        startAngleAlignment: StartAngleAlignment.start,
                        direction: CircularTextDirection.clockwise,
                      ),
                    ],
                    radius: 125,
                    position: CircularTextPosition.outside,
                    //backgroundPaint: Paint()..color = Colors.grey.shade200,
                  ),
                ),
                Container(
                  // margin: EdgeInsets.fromLTRB(20, 250, 20, 0),
                  // width: double.infinity,
                  // height: 200,
                  height: SizeConfig.blockSizeVertical! * 30,
                  width: SizeConfig.blockSizeHorizontal! * 60,
                  child: RiveAnimation.asset(
                    'assets/crown-rotating.riv',
                  ),
                ),
              ],
            )
          ),
        ));
  }
}
