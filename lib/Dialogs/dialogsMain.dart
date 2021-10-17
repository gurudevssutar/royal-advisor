import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/gameCompleted.dart';
import 'package:royal_advisor/Dialogs/generalErrorDialog.dart';
import 'package:royal_advisor/Dialogs/noInternet.dart';
import 'package:royal_advisor/Dialogs/rightansDialog.dart';
import 'package:royal_advisor/Dialogs/wrongansDialog.dart';

import 'Loader.dart';

class DialogShower {
  void rightAnsDialog(BuildContext context, String id, int nextQuestionNum,
      Function nextQuestion) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return RightAnsDialog(
              id: id,
              nextQuestionNum: nextQuestionNum,
              nextQuestion: nextQuestion);
        });
  }

  void wrongAnsDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return IncorrectAnsDialog();
        });
  }

  void loaderDialogIndissmisableOnBackPress(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: Loader());
      },
    );
  }

  // void loaderDialogDissmisableToKingScreen2(BuildContext context) {
  //   showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return WillPopScope(onWillPop: () async {
  //         Navigator.popUntil(context, (route) => route.settings.name == "KingScreen2");
  //         return true;
  //       }, child: Loader());
  //     },
  //   );
  // }

  void moveToErrorScreen(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!'),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 200,
                  height: 200,
                  child: RiveAnimation.asset('assets/alert_icon_red.riv')),
              Image.asset('assets/no_internet.png'),
              Text('Something went wrong')
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void moveToNoInternetScreen(
      BuildContext context, bool back, bool doubleBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return NoInternetDialog(back: back, doubleBack: doubleBack);
        });
  }

  void showGeneralErrorDialog(BuildContext context, String title,
      String message, bool back, bool doubleBack) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GeneralErrorDialog(
              title: title,
              message: message,
              back: back,
              doubleBack: doubleBack);
        });
  }

  void showGameCompletedDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return GameCompletedDialog();
        });
  }
}
