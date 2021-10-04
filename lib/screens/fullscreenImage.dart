import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  final String tag;
  final String url;

  DetailScreen({Key? key, required this.tag, required this.url})
      : assert(tag != null),
        assert(url != null),
        super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.25,
          maxScale: 2,
          child: Center(
            child: Hero(
              tag: widget.tag,
              child: CachedNetworkImage(
                imageUrl: widget.url,
                placeholder: (context, url) => Center(
                    child: Container(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator())),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),

    );
  }
}
