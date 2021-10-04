import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/rightansDialog.dart';
import 'package:royal_advisor/Dialogs/wrongansDialog.dart';

import 'Loader.dart';

class DialogShower {
  void rightAnsDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return RightAnsDialog();
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

  void moveToNoInternetScreen(BuildContext ctx) {
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
}
