import 'package:flutter/material.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

class NoInternetDialog extends StatelessWidget {
  final bool back;
  final bool doubleBack;

  NoInternetDialog({required this.back, required this.doubleBack});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      title: Text(
        'No Internet',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        alignment: Alignment.center,
        // width: SizeConfig.blockSizeHorizontal!*100,
        // height: SizeConfig.blockSizeVertical!*50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/no_internet.png'),
            Text('Please check your internet connection')
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
          ),
        if (doubleBack)
          ElevatedButton(
            child: Text('Back'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          )
      ],
    );
  }
}
