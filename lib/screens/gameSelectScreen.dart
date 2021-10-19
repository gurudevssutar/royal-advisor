import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/dialogsMain.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';
import 'package:royal_advisor/widgets/SizeConfig.dart';
import 'package:royal_advisor/widgets/gameGridItem.dart';

import '../customExceptions.dart';
import 'advisorGame.dart';

class GameSelect extends StatefulWidget {
  final List<QuestionListItem> _questionsList;

  GameSelect(this._questionsList);

  @override
  State<GameSelect> createState() => _GameSelectState();
}

class _GameSelectState extends State<GameSelect> {
  late List<QuestionListItem> _questionsList = widget._questionsList;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _refreshQuestions(BuildContext context) async {
    DialogShower().loaderDialogIndissmisableOnBackPress(context);
    var temp = await ApiCalls().fetchQuestionList();
    Navigator.pop(context);

    if (temp is List<QuestionListItem>) {
      setState(() {
        _questionsList = temp;
      });
    } else if (temp is NoInternetException) {
      DialogShower().moveToNoInternetScreen(context, true, false);
    } else {
      DialogShower().showGeneralErrorDialog(
          context, temp.title, temp.message, true, false);
    }

    return;
  }

  Future moveToGameScreen(
      BuildContext ctx, String id, int questionNumber) async {
    DialogShower().loaderDialogIndissmisableOnBackPress(ctx);
    var temp = await ApiCalls().fetchQuestion(id);
    Navigator.pop(ctx);

    if (temp is Question && _questionsList.length > 0) {
      Navigator.of(ctx).push(
        MaterialPageRoute(
          builder: (_) {
            return AdvisorGame(
                questionsList: _questionsList,
                id: id,
                questionNum: questionNumber,
                question: temp);
          },
        ),
      );
    } else if (temp is NoInternetException) {
      DialogShower().moveToNoInternetScreen(context, true, false);
    } else {
      DialogShower().showGeneralErrorDialog(
          context, temp.title, temp.message, true, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Container(
          width: SizeConfig.blockSizeHorizontal! * 100,
          child: Text("Royal Advisor"),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(SizeConfig.blockSizeVertical! * 2),
        child: RefreshIndicator(
            onRefresh: () => _refreshQuestions(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(children: [
                  Container(
                      width: SizeConfig.blockSizeHorizontal! * 50,
                      child: Text(
                        "Start Advising...",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20,
                        ),
                      )),
                  Container(
                      // width: 100,
                      // height: 66.667,
                      width: SizeConfig.blockSizeHorizontal! * 30,
                      height: SizeConfig.blockSizeVertical! * 10,
                      child: RiveAnimation.asset('assets/crown-rotating.riv')),
                ]),
                // ElevatedButton(
                //   onPressed: () {
                //     DialogShower().moveToNoInternetScreen(context, false, false);
                //   },
                //   child: Text('No Internet Temporary'),
                //   style: ElevatedButton.styleFrom(
                //       primary: Theme.of(context).primaryColor,
                //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                //       textStyle: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         fontSize: 20,
                //       )),
                // ),
                if (_questionsList.length > 0)
                  Expanded(
                    child: Container(
                      //gridviewBuilder
                      child: GridView.builder(
                          itemCount: _questionsList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing:
                                SizeConfig.blockSizeHorizontal! * 5,
                            mainAxisSpacing: SizeConfig.blockSizeVertical! * 5,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return GameGridItem(
                                id: _questionsList[index].id,
                                questionNum: _questionsList[index].questionNum,
                                moveToGameScreen: moveToGameScreen);
                          }),
                    ),
                  ),
              ],
            )),
      ),
    );
  }
}

// class _GameSelectState extends State<GameSelect> {
//   late Future _questions;
//
//   @override
//   void initState() {
//     super.initState();
//     _questions = ApiCalls().fetchQuestionList();
//
//   }
//
//   Future<void> _refreshQuestions(BuildContext context) async {
//     // var temp = await ApiCalls().fetchQuestionList();
//     setState(() {
//       _questions = ApiCalls().fetchQuestionList();
//     });
//     return;
//   }
//
//   Future moveToGameScreen(BuildContext ctx, String id, int questionNumber,
//       List<QuestionListItem> questionsList) async {
//     DialogShower().loaderDialogIndissmisableOnBackPress(ctx);
//     var temp = await ApiCalls().fetchQuestion(id);
//     Navigator.pop(ctx);
//
//     if (temp is Question && questionsList.length > 0) {
//       Navigator.of(ctx).push(
//         MaterialPageRoute(
//           builder: (_) {
//             return AdvisorGame(
//                 questionsList: questionsList,
//                 id: id,
//                 questionNum: questionNumber,
//                 question: temp);
//           },
//         ),
//       );
//     } else {
//       //show error dialog here
//       DialogShower().moveToNoInternetScreen(ctx, true, false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       appBar: AppBar(
//         title: Text('Royal Advisor'),
//         centerTitle: true,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshQuestions(context),
//         child: FutureBuilder(
//             future: _questions,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(child: Loader());
//               } else if (snapshot.hasError) {
//                 return Container(child: NoInternetDialog(back: false,doubleBack: true,));
//               } else if (snapshot.data == null) {
//                 return Container(child: Text('Empty data'));
//               } else {
//                 List<QuestionListItem> list;
//                 list = snapshot.data as List<QuestionListItem>;
//                 return snapshot.hasData
//                     ? Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Container(
//                               width: 100,
//                               height: 66.667,
//                               child: RiveAnimation.asset(
//                                   'assets/crown-rotating.riv')),
//                           ElevatedButton(
//                             onPressed: () {
//                               DialogShower().moveToNoInternetScreen(context, false, false);
//                             },
//                             child: Text('No Internet Temporary'),
//                             style: ElevatedButton.styleFrom(
//                                 primary: Theme.of(context).primaryColor,
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 20),
//                                 textStyle: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 20,
//                                 )),
//                           ),
//                           Expanded(
//                             child: Container(
//                               //gridviewBuilder
//                               child: ListView.builder(
//                                 itemCount: list.length,
//                                 itemBuilder: (context, index) {
//                                   // return Text(list[index].id.toString());
//                                   //gridItem
//                                   return ElevatedButton(
//                                     onPressed: () {
//                                       moveToGameScreen(context, list[index].id,
//                                           list[index].questionNum, list);
//                                     },
//                                     child: Text(
//                                         list[index].questionNum.toString()),
//                                     style: ElevatedButton.styleFrom(
//                                         primary: Theme.of(context).primaryColor,
//                                         padding: EdgeInsets.symmetric(
//                                             vertical: 10, horizontal: 20),
//                                         textStyle: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 20,
//                                         )),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : Center(child: Text('No data'));
//               }
//             }),
//       ),
//     );
//   }
// }
