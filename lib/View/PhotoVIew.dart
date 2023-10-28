import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../model/globals.dart' as global;

class PhotoView extends StatelessWidget {
  String picture;

  PhotoView(this.picture);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: global.TopColor,
        title: new Text("Foto"),
      ),
      body: new Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage("${picture}"), fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
