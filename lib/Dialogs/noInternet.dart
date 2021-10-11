import 'package:flutter/material.dart';

class NoInternetDialog extends StatelessWidget {
  final bool back;
  final bool doubleBack;

  NoInternetDialog({required this.back, required this.doubleBack});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'No Internet',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/no_internet.png'),
            Text('No Internet, Please try again later')
          ],
        ),
      ),
      actions: <Widget>[
        if (back)
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
