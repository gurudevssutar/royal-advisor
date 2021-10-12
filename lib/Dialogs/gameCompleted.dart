import 'package:flutter/material.dart';

class GameCompletedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Game Completed',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/no_internet.png'),
            Text('Game completed animation or image')
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
