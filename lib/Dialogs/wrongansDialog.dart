import 'dart:ui';
import 'package:rive/rive.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

import './constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncorrectAnsDialog extends StatefulWidget {
  @override
  _IncorrectAnsDialogState createState() => _IncorrectAnsDialogState();
}

class _IncorrectAnsDialogState extends State<IncorrectAnsDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      // width:SizeConfig.blockSizeHorizontal!*100,
      // height:SizeConfig.blockSizeVertical!*50,
      alignment: Alignment.center,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Incorrect Answer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 22,
              ),
              Container(
                  width: 200,
                  height: 200,
                  child: RiveAnimation.asset('assets/error_icon.riv')),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
