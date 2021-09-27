import 'package:drag_drop_listview_example/screens/advisorGame.dart';
import 'package:flutter/material.dart';

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
