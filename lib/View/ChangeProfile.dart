import 'package:flutter/material.dart';
import 'package:parent_side/model/Entities/Student.dart';
// import 'package:parent_side/model/Entities/Student.dart';
import '../main.dart';
import '../model/Entities/Students.dart';

class ChangeProfile extends StatelessWidget {
  Students myStudent;
  int indexOfStudent;
  final apiUrl = "http://18.230.116.206/api/v1/";
  ChangeProfile(this.myStudent, this.indexOfStudent);
  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      new Container(
        height: MediaQuery.of(context).size.height * 0.01,
      ),
      ListTile(
          leading: new CircleAvatar(
            radius: 23,
            backgroundImage:
                NetworkImage("${this.apiUrl}images/${this.myStudent.id}"),
          ),
          title: new Text(this.myStudent.username),
          onTap: () => {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) =>
                            ChildFeed(selectedStudent: this.indexOfStudent)),
                    (Route<dynamic> route) => false)
              }),
      Divider(color: Colors.black.withOpacity(0.6)),
    ]);
  }
}
