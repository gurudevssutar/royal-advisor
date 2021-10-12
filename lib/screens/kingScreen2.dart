import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:royal_advisor/Dialogs/dialogsMain.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/customExceptions.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/widgets/KingScreenWidget.dart';

import 'gameSelectScreen.dart';

class KingScreen2 extends StatelessWidget {
  const KingScreen2({Key? key}) : super(key: key);

  void moveToGameSelect(BuildContext context) async {
    DialogShower().loaderDialogIndissmisableOnBackPress(context);
    var temp = await ApiCalls().fetchQuestionList();
    Navigator.pop(context);

    if (temp is List<QuestionListItem>) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return GameSelect(temp);
          },
        ),
      );
    } else if (temp is NoInternetException) {
      DialogShower().moveToNoInternetScreen(context, true, false);
    } else {
      DialogShower().showGeneralErrorDialog(
          context, temp.title, temp.message, true, false);
    }
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
        imageURI:
            'https://qph.fs.quoracdn.net/main-qimg-c65857449cabf0d1630f86dcb7984338-c',
        text1: 'Yes my majesty',
        text2: ' I will help you solve the problems.',
        nextScreen: moveToGameSelect,
      ),
      // Stack(
      //   children: [
      //     Image.network(
      //         'https://qph.fs.quoracdn.net/main-qimg-c65857449cabf0d1630f86dcb7984338-c',
      //         width: double.infinity,
      //         height: double.infinity,
      //         fit: BoxFit.cover),
      //     Positioned(
      //       // The Positioned widget is used to position the text inside the Stack widget
      //       bottom: 80,
      //       right: 10,
      //
      //       child: Container(
      //         // We use this Container to create a black box that wraps the white text so that the user can read the text even when the image is white
      //         width: 200,
      //         color: Colors.black54,
      //         padding: EdgeInsets.all(10),
      //         child: Column(children: <Widget>[
      //           AnimatedTextKit(
      //             animatedTexts: [
      //               TyperAnimatedText(
      //                 'Yes my majesty',
      //                 textStyle: TextStyle(fontSize: 20, color: Colors.white),
      //               ),
      //               TyperAnimatedText(
      //                 ' I will help you solve the problems.',
      //                 textStyle: TextStyle(fontSize: 20, color: Colors.white),
      //               ),
      //             ],
      //             isRepeatingAnimation: false,
      //           ),
      //         ]),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 10,
      //       right: 10,
      //       child: Container(
      //         child: AnimatedTextKit(
      //           animatedTexts: [
      //             WavyAnimatedText(
      //               'Click to Continue --->',
      //               textStyle: TextStyle(fontSize: 20, color: Colors.blue),
      //             ),
      //           ],
      //           isRepeatingAnimation: true,
      //           repeatForever: true,
      //           onTap: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (_) {
      //                   return GameSelect();
      //                 },
      //               ),
      //             );
      //           },
      //         ),
      //       ),
      //     )
      //   ],
      // )
    );
  }
}
