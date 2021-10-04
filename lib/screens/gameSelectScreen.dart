import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/Loader.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';

import 'advisorGame.dart';

// class GameSelect extends StatefulWidget {
//   const GameSelect({Key? key}) : super(key: key);
//
//   @override
//   _GameSelectState createState() => _GameSelectState();
// }
//
// class _GameSelectState extends State<GameSelect> {
//   void showLoaderDialog(BuildContext context) {
//
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Loader();
//       },
//     );
//   }
//
//   void moveToGameScreen(BuildContext ctx) {
//     Navigator.of(ctx).push(
//       MaterialPageRoute(
//         builder: (_) {
//           return AdvisorGame();
//         },
//       ),
//     );
//     // showLoaderDialog(ctx);
//   }
//
//   void moveToNoInternetScreen(BuildContext ctx) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text('An error occurred!'),
//         content: Text('Something went wrong.'),
//         actions: <Widget>[
//           ElevatedButton(
//             child: Text('Okay'),
//             onPressed: () {
//               Navigator.of(ctx).pop();
//             },
//           )
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Theme.of(context).backgroundColor,
//         appBar: AppBar(
//           title: Text('Royal Advisor'),
//           centerTitle: true,
//         ),
//         body: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 moveToNoInternetScreen(context);
//               },
//               child: Text('No Internet Temporary'),
//               style: ElevatedButton.styleFrom(
//                   primary: Theme.of(context).primaryColor,
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   )),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 moveToGameScreen(context);
//               },
//               child: Text('Game Screen'),
//               style: ElevatedButton.styleFrom(
//                   primary: Theme.of(context).primaryColor,
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   textStyle: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   )),
//             ),
//           ],
//         ));
//   }
// }

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

  Future showLoaderDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false, child: Loader());
      },
    );
  }

  Future moveToGameScreen(BuildContext ctx, String id, int questionNumber,
      List<QuestionListItem> questionsList) async {
    showLoaderDialog(ctx);
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
      moveToNoInternetScreen(ctx);
    }
  }

  void moveToNoInternetScreen(BuildContext ctx) {
    showDialog(
      context: ctx,
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
                              moveToNoInternetScreen(context);
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
                              child: ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  // return Text(list[index].id.toString());
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
