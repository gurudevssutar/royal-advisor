import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:drag_drop_listview_example/data/draggable_lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'model/draggable_list.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final String title = 'Royal Advisor';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.red),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
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
    for(DraggableListItem i in soln[0].items){
      if(i.id != ans[j]){
        return false;
      }
      j++;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Color.fromARGB(255, 243, 242, 248);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(MyApp.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Flexible(
            child: DragAndDropLists(
              lastItemTargetHeight: 50,
              addLastItemTargetHeightToTop: true,
              lastListTargetSize: 30,
              listPadding: EdgeInsets.all(16),

              listInnerDecoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10),
              ),
              children: lists,
              itemDivider:
                  Divider(thickness: 2, height: 2, color: backgroundColor),
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
          ElevatedButton(
            onPressed: () {
              if(anscheck(current, anslist)){
                print('Answer is correct');
              }else{
                print('Invalid Answer');
              }
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          )
        ],
      ),
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
          padding: EdgeInsets.all(8),
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

      for(DraggableListItem i in current[0].items){
        print("${i.id}");
      }
      print("${oldItemIndex} ${oldListIndex} ${newItemIndex} ${newListIndex}");

      if (oldListIndex == newListIndex) {
        final movedItem = oldListItems.removeAt(oldItemIndex);
        final movedTile = current[0].items.removeAt(oldItemIndex);
        newListItems.insert(newItemIndex, movedItem);

        current[0].items.insert(newItemIndex, movedTile);
        for(DraggableListItem i in current[0].items){
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
