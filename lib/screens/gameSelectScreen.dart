import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:royal_advisor/Dialogs/Loader.dart';
import 'package:http/http.dart' as http;
import 'package:royal_advisor/models/questionListModel.dart';

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
    _questions = fetchQuestionList();
  }

  Future fetchQuestionList() async {
    final url = Uri.parse("http://192.168.0.106:8080/question/all");
    final response = await http.get(url);
    print('fetch question');
    if (response.statusCode == 200) {
      if (response.body.length <= 0) {
        return;
      }
      print(response.body);
      final parsed = json.decode(response.body) as Map<String, dynamic>;
      print(parsed);
      var temp = decodeQuestionList(parsed['questions']);
      print(temp);
      print('end fetch question');
      return temp;
    } else {
      // moveToNoInternetScreen(ctx);
      throw Exception('Unable to fetch data from the REST API');
    }
  }

  List<QuestionListItem> decodeQuestionList(parsed) {
    return parsed
        .map<QuestionListItem>((json) => QuestionListItem.fromMap(json))
        .toList();
  }

  Future<void> _refreshQuestions(BuildContext context) async {
    var temp = fetchQuestionList();
    setState(() {
      _questions = temp;
    });
    return temp;
  }

  void showLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Loader();
      },
    );
  }

  void moveToGameScreen(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return AdvisorGame();
        },
      ),
    );
    // showLoaderDialog(ctx);
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
              }
              print('snapsghot printing');
              print(snapshot);
              print(snapshot.data);

              if (snapshot.hasError) {
                return Text('An error occurred!');
              } else if (snapshot.data == null) {
                return Text('Empty data');
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
                          ElevatedButton(
                            onPressed: () {
                              moveToGameScreen(context);
                            },
                            child: Text('Game Screen'),
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
                                  return Text(list[index].id.toString());
                                  // return FruitItem(item: snapshot.data[index]);
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
