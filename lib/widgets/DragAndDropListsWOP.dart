import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import 'package:royal_advisor/models/draggable_list.dart';
import 'package:royal_advisor/models/questionModel.dart';

class DragAndDropListsWOP extends StatefulWidget {
  final List<QuestionOption> current;
  // late List<DragAndDropList> lists;
  final List<QuestionOption> allLists;

  DragAndDropListsWOP({required this.current, required this.allLists});

  @override
  _DragAndDropListsWOPState createState() => _DragAndDropListsWOPState();


}

class _DragAndDropListsWOPState extends State<DragAndDropListsWOP> {

  late List<DragAndDropList> lists=[];

  late List<QuestionOption> allLists=widget.allLists;


  @override
  void initState() {
    super.initState();

    // lists = allLists.map(buildList).toList() as List<DragAndDropList>;
    lists.add(buildList(allLists));
  }


  void onReorderListItem(
      int oldItemIndex,
      int oldListIndex,
      int newItemIndex,
      int newListIndex,
      ) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      for (QuestionOption i in widget.current) {
        print("${i.id}");
      }
      print("${oldItemIndex} ${oldListIndex} ${newItemIndex} ${newListIndex}");

      if (oldListIndex == newListIndex) {
        final movedItem = oldListItems.removeAt(oldItemIndex);
        final movedTile = widget.current.removeAt(oldItemIndex);
        newListItems.insert(newItemIndex, movedItem);

        widget.current.insert(newItemIndex, movedTile);
        for (QuestionOption i in widget.current) {
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


  @override
  Widget build(BuildContext context) {
    return DragAndDropLists(
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
    );
  }
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


DragAndDropList buildList(List<QuestionOption> list) => DragAndDropList(
  // header: Container(
  //   padding: EdgeInsets.all(0),
  //   child: Text(
  //     list.name,
  //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  //   ),
  // ),
  children: list.map((item) => DragAndDropItem(
    child: ListTile(
      leading: Image.network(
        item.optionImage,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
      ),
      title: Text(item.name +
          "\nArrival Time = " +
          item.arrivalTime.toString() +
          "\nExecute Time = " +
          item.burstTime.toString()),
    ),
  )
  )
      .toList(),
);