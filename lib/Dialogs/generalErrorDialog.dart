import 'package:flutter/material.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';

class GeneralErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final bool back;
  final bool doubleBack;

  GeneralErrorDialog(
      {required this.title,
      required this.message,
      required this.back,
      required this.doubleBack});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return AlertDialog(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        width:SizeConfig.blockSizeHorizontal!*100,
        height:SizeConfig.blockSizeVertical!*100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/errorImage.jpg', fit: BoxFit.contain),
            Text(message)
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
