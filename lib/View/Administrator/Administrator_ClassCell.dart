import 'package:flutter/material.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_Feed.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import '../../model/globals.dart' as global;

class ClassCell extends StatelessWidget {
  final width;
  final height;
  Teacher teacher;
  SchoolClass myClass;
  var name;
  int qtdToBeAproved;
  final webApi = ApiService();

  ClassCell(this.width, this.height, this.teacher, this.myClass, this.name,
      this.qtdToBeAproved);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: new EdgeInsets.fromLTRB(20, 30, 20, 0),
            height: height * 0.23,
            width: width,
            child: new Stack(
              children: [
                Container(
                    padding: new EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: height * 0.22,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0),
                      ),
                      color: global.AttendanceColor,
                      child: new TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    //ADICIONAR A TURMA
                                    builder: (context) => new AdministratorFeed(
                                        this.teacher, this.myClass)));
                          },
                          child: Row(
                            children: [
                              new Container(
                                width: width * 0.08,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "${this.name[0]}",
                                    style: new TextStyle(
                                        fontSize: 30.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  new Container(
                                    width: width * 0.1,
                                  ),
                                  Text(
                                    "${this.name[1]}",
                                    style: new TextStyle(
                                        fontSize: 70.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    )),
                Positioned(
                    top: -height * 0.015,
                    left: width * 0.81,
                    child: this.qtdToBeAproved != 0
                        ? new Container(
                            width: width * 0.09,
                            height: height * 0.08,
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text("${this.qtdToBeAproved}",
                                  style: new TextStyle(
                                      fontSize: 28.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        : Text("")),
              ],
            ))
      ],
    );
  }
}
