import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

// class Loader extends StatelessWidget {
//   const Loader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       type: MaterialType.transparency,
//
//       child: AlertDialog(
//
//         backgroundColor: Colors.transparent,
//         content: Container(
//           // height: 400,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                   width: 300,
//                   height: 200,
//                   child: RiveAnimation.asset('assets/crown-rotating.riv')),
//               Container(
//                 child: AnimatedTextKit(
//                   animatedTexts: [
//                     TyperAnimatedText(
//                       'Loading...',
//                       speed: const Duration(milliseconds: 200),
//                       textStyle: TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.yellowAccent),
//                     ),
//                   ],
//                   repeatForever: true,
//                   isRepeatingAnimation: true,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Material(
      type: MaterialType.transparency,
      child: Container(
        // height: 400,
        width: SizeConfig.blockSizeHorizontal!*100,
        height:SizeConfig.blockSizeVertical!*100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                width: 300,
                height: 200,
                child: RiveAnimation.asset('assets/crown-rotating.riv')),
            Container(
              child: AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    'Loading...',
                    speed: const Duration(milliseconds: 200),
                    textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent),
                  ),
                ],
                repeatForever: true,
                isRepeatingAnimation: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
