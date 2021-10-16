import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:royal_advisor/screens/kingScreen2.dart';

import 'SizeConfig.dart';

class KingScreenWidget extends StatelessWidget {

  final String imageURI;
  final String text1;
  final String text2;
  final Function nextScreen;

  KingScreenWidget({required this.imageURI, required this.text1, required this.text2, required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Center(
      child: Stack(
        children: [
          Image.network(
              // 'https://th.bing.com/th/id/OIP.v159VFeV5NRhNADty8jmwQHaJ4?w=206&h=275&c=7&r=0&o=5&dpr=1.25&pid=1.7',
              imageURI,
              // width: double.infinity,
              // height: double.infinity,
              height:SizeConfig.blockSizeVertical! * 100 ,
              width: SizeConfig.blockSizeHorizontal! * 100,),
          Positioned(
            // The Positioned widget is used to position the text inside the Stack widget
            bottom: SizeConfig.blockSizeVertical! * 15,
            right: SizeConfig.blockSizeHorizontal! * 5,

            child: Container(
              // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
              width: 200,
              color: Colors.black54,
              padding: EdgeInsets.all(10),
              child: Column(children: <Widget>[
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      // 'Hello Advisor',
                      text1,
                      textStyle: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    TyperAnimatedText(
                      // ' Schedule all my today\'s task',
                      text2,
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) {
                  //       return KingScreen2();
                  //     },
                  //   ),
                  // );
                  nextScreen(context);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
