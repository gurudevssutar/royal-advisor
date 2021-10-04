import 'package:flutter/material.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:royal_advisor/Dialogs/rightansDialog.dart';
import 'package:royal_advisor/Dialogs/wrongansDialog.dart';
import 'package:royal_advisor/api/apiCalls.dart';
import 'package:royal_advisor/data/draggable_lists.dart';
import 'package:royal_advisor/models/draggable_list.dart';
import 'package:royal_advisor/models/questionListModel.dart';
import 'package:royal_advisor/models/questionModel.dart';
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
  late List<DraggableList> current;
  late Question _question;
  late final String _questionId;

  @override
  void initState() {
    super.initState();

    lists = allLists.map(buildList).toList();
    current = allLists;
    _question = widget._question;
    _questionId = widget._id;
    print(_question.questionImg);
  }

  bool anscheck(List<DraggableList> soln, List<String> ans) {
    // Code to check answer
    int j = 0;
    for (DraggableListItem i in soln[0].items) {
      if (i.id != ans[j]) {
        return false;
      }
      j++;
    }
    return true;
  }

  void submitans(List<DraggableList> soln, List<String> ans) {
    if (anscheck(soln, ans)) {
      print('Answer is correct');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return RightAnsDialog();
          });
    } else {
      print('Invalid Answer');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return IncorrectAnsDialog();
          });
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
                    child: DragAndDropLists(
                      lastItemTargetHeight: 50,
                      addLastItemTargetHeightToTop: true,
                      // lastListTargetSize: 30,
                      listPadding: EdgeInsets.all(16),

                      listInnerDecoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      children: lists,
                      itemDivider: Divider(
                          thickness: 2,
                          height: 2,
                          color: Theme.of(context).backgroundColor),
                      itemDecorationWhileDragging: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 4)
                        ],
                      ),
                      // listDragHandle: buildDragHandle(isList: true),
                      itemDragHandle: buildDragHandle(),
                      onItemReorder: onReorderListItem,
                      onListReorder: onReorderList,
                    ),
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
                        submitans(current, anslist);
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

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;
    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }

  DragAndDropList buildList(DraggableList list) => DragAndDropList(
        header: Container(
          padding: EdgeInsets.all(0),
          child: Text(
            list.header,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        children: list.items
            .map((item) => DragAndDropItem(
                  child: ListTile(
                    leading: Image.network(
                      item.urlImage,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.title +
                        "\nArrival Time = " +
                        item.arrivalTime.toString() +
                        "\nExecute Time = " +
                        item.executeTime.toString()),
                  ),
                ))
            .toList(),
      );

  void onReorderListItem(
    int oldItemIndex,
    int oldListIndex,
    int newItemIndex,
    int newListIndex,
  ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      for (DraggableListItem i in current[0].items) {
        print("${i.id}");
      }
      print("${oldItemIndex} ${oldListIndex} ${newItemIndex} ${newListIndex}");

      if (oldListIndex == newListIndex) {
        final movedItem = oldListItems.removeAt(oldItemIndex);
        final movedTile = current[0].items.removeAt(oldItemIndex);
        newListItems.insert(newItemIndex, movedItem);

        current[0].items.insert(newItemIndex, movedTile);
        for (DraggableListItem i in current[0].items) {
          print("${i.id}");
        }
      }
    });
  }

  void onReorderList(
    int oldListIndex,
    int newListIndex,
  ) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }
}
