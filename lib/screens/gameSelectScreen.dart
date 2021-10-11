import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/Loader.dart';
import 'package:royal_advisor/Dialogs/dialogsMain.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';

import 'advisorGame.dart';

class GameSelect extends StatefulWidget {
  @override
  State<GameSelect> createState() => _GameSelectState();
}

class _GameSelectState extends State<GameSelect> {
  late Future _questions;

  @override
  void initState() {
    super.initState();
    _questions = ApiCalls().fetchQuestionList();
  }

  Future<void> _refreshQuestions(BuildContext context) async {
    // var temp = await ApiCalls().fetchQuestionList();
    setState(() {
      _questions = ApiCalls().fetchQuestionList();
    });
    return;
  }

  Future moveToGameScreen(BuildContext ctx, String id, int questionNumber,
      List<QuestionListItem> questionsList) async {
    DialogShower().loaderDialogIndissmisableOnBackPress(ctx);
    var temp = await ApiCalls().fetchQuestion(id);
    Navigator.pop(ctx);

    if (temp is Question && questionsList.length > 0) {
      Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (_) {
            return AdvisorGame(
                questionsList: questionsList,
                id: id,
                questionNum: questionNumber,
                question: temp);
          },
        ),
      );
    } else {
      //show error dialog here
      DialogShower().moveToNoInternetScreen(ctx, true, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Royal Advisor'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshQuestions(context),
        child: FutureBuilder(
            future: _questions,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Loader());
              } else if (snapshot.hasError) {
                return Container(child: Text('An error occurred!'));
              } else if (snapshot.data == null) {
                return Container(child: Text('Empty data'));
              } else {
                List<QuestionListItem> list;
                list = snapshot.data as List<QuestionListItem>;
                return snapshot.hasData
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              width: 100,
                              height: 66.667,
                              child: RiveAnimation.asset(
                                  'assets/crown-rotating.riv')),
                          ElevatedButton(
                            onPressed: () {
                              DialogShower().moveToNoInternetScreen(context, false, false);
                            },
                            child: Text('No Internet Temporary'),
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ),
                          Expanded(
                            child: Container(
                              //gridviewBuilder
                              child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  // return Text(list[index].id.toString());
                                  //gridItem
                                  return ElevatedButton(
                                    onPressed: () {
                                      moveToGameScreen(context, list[index].id,
                                          list[index].questionNum, list);
                                    },
                                    child: Text(
                                        list[index].questionNum.toString()),
                                    style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Center(child: Text('No data'));
              }
            }),
      ),
    );
  }
}
