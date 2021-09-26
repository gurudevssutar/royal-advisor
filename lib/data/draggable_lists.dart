import 'package:drag_drop_listview_example/models/draggable_list.dart';

List<DraggableList> allLists = [
  DraggableList(
    header: 'Day 1 - Schedule the tasks',
    items: [
      DraggableListItem(
        id: '1',
        title: 'Meeting at Palace',
        arrivalTime: 0,
        executeTime: 5,
        urlImage:
            'https://image.freepik.com/free-vector/medieval-castle-interior-flat-cartoon-composition-with-king-throne-armed-knight-coat-arms-guard_1284-27798.jpg',
      ),
      DraggableListItem(
        id: '2',
        title: 'Visit Market',
        arrivalTime: 1,
        executeTime: 3,
        urlImage:
            'https://image.freepik.com/free-vector/food-market-stalls-with-fruits-vegetables-cheese-meat-fish-counter-crates_107791-4733.jpg',
      ),
      DraggableListItem(
        id: '3',
        title: 'Archery Practice',
        arrivalTime: 2,
        executeTime: 8,
        urlImage:
            'https://img.freepik.com/free-vector/target-icon-illustration_352822-37.jpg?size=338&ext=jpg',
      ),
      DraggableListItem(
        id: '4',
        title: 'Lunch',
        arrivalTime: 3,
        executeTime: 6,
        urlImage:
            'https://img.freepik.com/free-vector/castle-hall-with-king-queen-eat-lunch-feast-table-with-food-banquet-party_1441-1908.jpg?size=338&ext=jpg',
      ),
    ],
  ),

  // DraggableList(
  //   header: 'Day 2 - Schedule the tasks',
  //   items: [
  //     DraggableListItem(
  //       title: 'Tour the kingdom',
  //       arrivalTime: 2,
  //       executeTime: 6,
  //       urlImage:
  //           'https://image.freepik.com/free-vector/medieval-life-scene-cartoon_1284-23097.jpg',
  //     ),
  //     DraggableListItem(
  //       title: 'Visit Darbar',
  //       arrivalTime: 5,
  //       executeTime: 2,
  //       urlImage:
  //           'https://image.freepik.com/free-vector/castle-staircase-illustration_33099-2331.jpg',
  //     ),
  //     DraggableListItem(
  //       title: 'Meet Foreign delegation',
  //       arrivalTime: 1,
  //       executeTime: 8,
  //       urlImage:
  //           'https://image.freepik.com/free-vector/cartoon-king-holding-golden-scepter_29190-5435.jpg',
  //     ),
  //     DraggableListItem(
  //       title: 'Lunch',
  //       arrivalTime: 0,
  //       executeTime: 3,
  //       urlImage:
  //           'https://img.freepik.com/free-vector/castle-hall-with-king-queen-eat-lunch-feast-table-with-food-banquet-party_1441-1908.jpg?size=338&ext=jpg',
  //     ),
  //     DraggableListItem(
  //       title: 'Cabinet meeting',
  //       arrivalTime: 4,
  //       executeTime: 4,
  //       urlImage:
  //           'https://image.freepik.com/free-vector/medieval-castle-interior-flat-cartoon-composition-with-king-throne-armed-knight-coat-arms-guard_1284-27798.jpg',
  //     ),
  //   ],
  // ),
];

List<String> anslist = ['1','2', '3', '4'];