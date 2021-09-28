import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import 'kingScreen2.dart';

class KingScreen extends StatelessWidget {
  const KingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Royal Advisor'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Image.network(
                'https://th.bing.com/th/id/OIP.v159VFeV5NRhNADty8jmwQHaJ4?w=206&h=275&c=7&r=0&o=5&dpr=1.25&pid=1.7',
                width: 450,
                height: 650,
                fit: BoxFit.cover),
            Positioned(
              // The Positioned widget is used to position the text inside the Stack widget
              bottom: 80,
              right: 10,

              child: Container(
                // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
                width: 200,
                color: Colors.black54,
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  AnimatedTextKit(
                    animatedTexts: [
                      TyperAnimatedText(
                        'Hello Advisor',
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      TyperAnimatedText(
                        ' Schedule all my today\'s task',
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                    isRepeatingAnimation: false,
                  ),
                ]),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      'Click to Continue --->',
                      textStyle: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) {
                          return KingScreen2();
                        },
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
