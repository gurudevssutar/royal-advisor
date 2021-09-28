import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'advisorGame.dart';

class GameSelect extends StatefulWidget {
  const GameSelect({Key? key}) : super(key: key);

  @override
  _GameSelectState createState() => _GameSelectState();
}

class _GameSelectState extends State<GameSelect> {

  void moveToGameScreen(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return AdvisorGame();
        },
      ),
    );
  }

  void moveToNoInternetScreen(BuildContext ctx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An error occurred!'),
        content: Text('Something went wrong.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text('Royal Advisor'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: RiveAnimation.asset('assets/crown-rotating.riv')
            ),
            ElevatedButton(
              onPressed: () {moveToNoInternetScreen(context);},
              child: Text('No Internet Temporary'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
            ElevatedButton(
              onPressed: () {moveToGameScreen(context);},
              child: Text('Game Screen'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
            ),
          ],
        ));
  }
}
