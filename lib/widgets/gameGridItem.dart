import 'package:flutter/material.dart';
import 'package:royal_advisor/models/questionListModel.dart';

class GameGridItem extends StatelessWidget {
  final String id;
  final int questionNum;
  final Function moveToGameScreen;

  GameGridItem(
      {required this.id,
      required this.questionNum,
      required this.moveToGameScreen});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        moveToGameScreen(context, id, questionNum);
      },
      child: Text(questionNum.toString()),
      style: ElevatedButton.styleFrom(
          primary: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
    );
  }
}
