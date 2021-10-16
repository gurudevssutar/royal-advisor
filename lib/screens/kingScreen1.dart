import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:royal_advisor/widgets/KingScreenWidget.dart';

import 'kingScreen2.dart';

class KingScreen extends StatelessWidget {
  const KingScreen({Key? key}) : super(key: key);

  void moveToKingScreen2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return KingScreen2();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Royal Advisor'),
          centerTitle: true,
        ),
        body: KingScreenWidget(
            // imageURI:'https://th.bing.com/th/id/OIP.v159VFeV5NRhNADty8jmwQHaJ4?w=206&h=275&c=7&r=0&o=5&dpr=1.25&pid=1.7',
            imageURI : 'https://raw.githubusercontent.com/gurudevssutar/resources/main/king.jpeg',
            text1: 'Hello Advisor',
            text2: ' Schedule all my today\'s task',
            nextScreen: moveToKingScreen2));
  }
}
