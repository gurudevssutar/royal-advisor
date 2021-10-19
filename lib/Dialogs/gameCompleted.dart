import 'package:flutter/material.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

class GameCompletedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      title: Text(
        //change
        'Game Completed',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        width:SizeConfig.blockSizeHorizontal!*100,
        height:SizeConfig.blockSizeVertical!*100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //change
            Image.asset('assets/game_done.jpg'),
          ],
        ),
      ),
      actions: <Widget>[
          ElevatedButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
      ],
    );
  }
}
