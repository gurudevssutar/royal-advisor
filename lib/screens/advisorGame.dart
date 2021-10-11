import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:royal_advisor/Dialogs/dialogsMain.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/data/draggable_lists.dart';
import 'package:royal_advisor/models/draggable_list.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';
import 'package:royal_advisor/widgets/DragAndDropListsWOP.dart';
import 'package:royal_advisor/widgets/clickableImage.dart';

class AdvisorGame extends StatefulWidget {
  final List<QuestionListItem> _questionsList;
  final String _id;
  final int _questionNum;
  final Question _question;

  AdvisorGame(
      {required List<QuestionListItem> questionsList,
      required String id,
      required int questionNum,
      required Question question})
      : _questionsList = questionsList,
        _id = id,
        _questionNum = questionNum,
        _question = question;

  @override
  _AdvisorGameState createState() => _AdvisorGameState();
}

class _AdvisorGameState extends State<AdvisorGame> {
  late List<DragAndDropList> lists;
  late List<QuestionOption> current;
  late Question _question;
  late final String _questionId;
  late List<QuestionOption> allLists;
  late List<AnswerOption> _ansOption;

  @override
  void initState() {
    super.initState();

    // lists = allLists.map(buildList).toList() as List<DragAndDropList>;
    // current = allLists;
    _question = widget._question;
    current=_question.questionOptions;
    _questionId = widget._id;
    print(_question.questionImg);
    allLists=_question.questionOptions;
    _ansOption=_question.answer;
  }

  bool anscheck(List<QuestionOption> soln, List<AnswerOption> ans) {
    // Code to check answer
    if(soln.length!=ans.length){
      return false;
    }

    for(int i=0;i<soln.length;i++){
      soln[i].startTime=0;
      soln[i].endTime=0;
    }

    for(int i=0;i<soln.length;i++){
        if(i==0){
          soln[i].endTime=soln[i].burstTime;
          continue;
        }
        soln[i].startTime=soln[i-1].endTime;
        soln[i].endTime=soln[i].startTime+soln[i].burstTime;
    }
    for(int i=0;i<soln.length;i++){
      print(soln[i].name);
      print(soln[i].startTime);
      print(soln[i].endTime);
      print("");

      if(soln[i].id!=ans[i].qRef.id){
        return false;
      }
      if(soln[i].startTime!=ans[i].startTime || soln[i].endTime!=ans[i].endTime ){
        return false;
      }

    }
    return true;
  }

  void submitans(List<QuestionOption> soln, List<AnswerOption> ans) {
    if (anscheck(soln, ans)) {
      print('Answer is correct');
      DialogShower().rightAnsDialog(context);
    } else {
      print('Invalid Answer');
      DialogShower().wrongAnsDialog(context);
    }
  }

  Future<void> _refreshQuestions(BuildContext context) async {
    var temp = await ApiCalls().fetchQuestion(_questionId);
    if (temp is Question) {
      setState(() {
        _question = temp;
      });
    }
    return temp;
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
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Text(_question.questionText),
                  ClickableCachedImageWithAnimationToFullScreen(
                      animationTag: "imageHero",
                      imageUrl: _question.questionImg),
                  Flexible(
                    child: DragAndDropListsWOP(current:current, allLists: allLists,),
                  ),
                  // ElevatedButton(
                  //   child: const Text('Play One-Shot Animation'),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute<void>(
                  //         builder: (context) => const PlayOneShotAnimation(),
                  //       ),
                  //     );
                  //   },
                  // ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: ElevatedButton(
                      onPressed: () {
                        submitans(current, _ansOption );
                      },
                      child: Text('Submit'),
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // DragHandle buildDragHandle({bool isList = false}) {
  //   final verticalAlignment = isList
  //       ? DragHandleVerticalAlignment.top
  //       : DragHandleVerticalAlignment.center;
  //   final color = isList ? Colors.blueGrey : Colors.black26;
  //
  //   return DragHandle(
  //     verticalAlignment: verticalAlignment,
  //     child: Container(
  //       padding: EdgeInsets.only(right: 10),
  //       child: Icon(Icons.menu, color: color),
  //     ),
  //   );
  // }

  // DragAndDropList buildList(DraggableList list) => DragAndDropList(
  //       header: Container(
  //         padding: EdgeInsets.all(0),
  //         child: Text(
  //           list.header,
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //         ),
  //       ),
  //       children: list.items
  //           .map((item) => DragAndDropItem(
  //                 child: ListTile(
  //                   leading: Image.network(
  //                     item.urlImage,
  //                     width: 40,
  //                     height: 40,
  //                     fit: BoxFit.cover,
  //                   ),
  //                   title: Text(item.title +
  //                       "\nArrival Time = " +
  //                       item.arrivalTime.toString() +
  //                       "\nExecute Time = " +
  //                       item.executeTime.toString()),
  //                 ),
  //               ))
  //           .toList(),
  //     );

  // void onReorderListItem(
  //   int oldItemIndex,
  //   int oldListIndex,
  //   int newItemIndex,
  //   int newListIndex,
  // ) {
  //   setState(() {
  //     final oldListItems = lists[oldListIndex].children;
  //     final newListItems = lists[newListIndex].children;
  //
  //     for (DraggableListItem i in current[0].items) {
  //       print("${i.id}");
  //     }
  //     print("${oldItemIndex} ${oldListIndex} ${newItemIndex} ${newListIndex}");
  //
  //     if (oldListIndex == newListIndex) {
  //       final movedItem = oldListItems.removeAt(oldItemIndex);
  //       final movedTile = current[0].items.removeAt(oldItemIndex);
  //       newListItems.insert(newItemIndex, movedItem);
  //
  //       current[0].items.insert(newItemIndex, movedTile);
  //       for (DraggableListItem i in current[0].items) {
  //         print("${i.id}");
  //       }
  //     }
  //   });
  // }

  // void onReorderList(
  //   int oldListIndex,
  //   int newListIndex,
  // ) {
  //   setState(() {
  //     final movedList = lists.removeAt(oldListIndex);
  //     lists.insert(newListIndex, movedList);
  //   });
  // }


}
