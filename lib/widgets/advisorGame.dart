import 'package:drag_drop_listview_example/models/draggable_list.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:drag_drop_listview_example/Dialogs/rightansDialog.dart';
import 'package:drag_drop_listview_example/Dialogs/wrongansDialog.dart';
import 'package:drag_drop_listview_example/data/draggable_lists.dart';
import 'package:drag_drop_listview_example/widgets/fullscreenImage.dart';

class AdvisorGame extends StatefulWidget {
  const AdvisorGame({Key? key}) : super(key: key);

  @override
  _AdvisorGameState createState() => _AdvisorGameState();
}

class _AdvisorGameState extends State<AdvisorGame> {
  late List<DragAndDropList> lists;
  late List<DraggableList> current;

  @override
  void initState() {
    super.initState();

    lists = allLists.map(buildList).toList();
    current = allLists;


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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Hero(
              tag: 'imageHero',
              child: CachedNetworkImage(
                imageUrl:
                    "https://raw.githubusercontent.com/gurudevssutar/resources/main/OS_Q1.JPG",
                placeholder: (context, url) => Center(
                    child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator())),
                errorWidget: (context, url, error) {
                  print('Error: ${error}');
                  print('URL: ${url}');
                  return Icon(Icons.error);
                },
              )),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(
                  tag: 'imageHero',
                  url:
                      "https://raw.githubusercontent.com/gurudevssutar/resources/main/OS_Q1.JPG");
            }));
          },
        ),
        // GestureDetector(
        //   onTap: () {}, // handle your image tap here
        //   child: Image.network(
        //     'https://raw.githubusercontent.com/gurudevssutar/royal-advisor/resources/OS-q1.png',
        //      // this is the solution for border
        //     width: 500,
        //     height: 200,
        //   ),
        // ),
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
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
                primary: Colors.red,

                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          ),
        )
      ],
    );
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
