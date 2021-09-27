import 'package:drag_drop_listview_example/screens/gameSelectScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';

import 'package:drag_drop_listview_example/screens/advisorGame.dart';

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
        theme: ThemeData(primarySwatch: Colors.red,
        backgroundColor: Color.fromARGB(255, 243, 242, 248),
        ),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {

  @override
  Widget build(BuildContext context) {

    return  GameSelect();
  }
}

// class PlayOneShotAnimation extends StatefulWidget {
//   const PlayOneShotAnimation({Key? key}) : super(key: key);
//
//   @override
//   _PlayOneShotAnimationState createState() => _PlayOneShotAnimationState();
// }
//
// class _PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
//   /// Controller for playback
//   late RiveAnimationController _controller;
//
//   /// Is the animation currently playing?
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = OneShotAnimation(
//       'bounce',
//       autoplay: false,
//       onStop: () => setState(() => _isPlaying = false),
//       onStart: () => setState(() => _isPlaying = true),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('One-Shot Example'),
//       ),
//       body: Center(
//         child: RiveAnimation.network(
//           'https://cdn.rive.app/animations/vehicles.riv',
//           animations: const ['idle', 'curves'],
//           controllers: [_controller],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         // disable the button while playing the animation
//         onPressed: () => _isPlaying ? null : _controller.isActive = true,
//         tooltip: 'Play',
//         child: const Icon(Icons.arrow_upward),
//       ),
//     );
//   }
// }
