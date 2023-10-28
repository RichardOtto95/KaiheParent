import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_Feed.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import '../../model/Entities/Students.dart';
import '../../model/globals.dart' as global;

class StudentList extends StatefulWidget {
  SchoolClass myClass;
  Teacher teacher;
  List<Students> students = [];
  StudentList(this.myClass, this.teacher, this.students);
  @override
  State<StatefulWidget> createState() {
    return StudentListState(this.myClass, this.teacher, this.students);
  }
}

class StudentListState extends State<StudentList> {
  final webApi = ApiService();
  final apiUrl = "http://18.230.116.206/api/v1/";
  SchoolClass myClass;
  Teacher teacher;
  List<Students> students = [
    Students(id: "AAAAA", username: "Jõao do Feijão"),
    Students(id: "BBBB", username: "Alana da Banana")
  ];
  var lastSeen;

  StudentListState(this.myClass, this.teacher, this.students);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(
                          builder: (context) => new AdministratorFeed(
                              this.teacher, this.myClass)),
                      (Route<dynamic> route) => false);
                },
                icon: Icon(Icons.arrow_back),
              ),
              backgroundColor: global.TopColor,
              title: Text(
                this.myClass.grade,
                style: new TextStyle(fontSize: 18.0, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
            ),
            body: new GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                  Container(
                    height: height * 0.02,
                  ),
                  Column(children: <Widget>[
                    Center(
                      child: Text(
                        "Alunos",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                        padding: new EdgeInsets.fromLTRB(20, 20, 20, 20),
                        height: height * 0.8,
                        width: double.maxFinite,
                        child: new Stack(children: [
                          ListView.builder(
                              itemCount: this.students.length,
                              itemBuilder: (context, i) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${this.apiUrl}images/${this.students[i].id}"),
                                                      fit: BoxFit.fill)),
                                            )),
                                        Container(
                                          width: width * 0.72,
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(this.students[i].username),
                                                Container(
                                                  height: height * 0.02,
                                                ),
                                                this
                                                            .students[i]
                                                            .last_view
                                                            .toString() !=
                                                        "Never"
                                                    ? Text(
                                                        //TROCAR PARA A DATA
                                                        "Última visuzlização: ${this.students[i].last_view.toDate().toString().substring(0, 11)}")
                                                    : Text(
                                                        "Nunca visualizou!",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                              ]),
                                        ),
                                      ],
                                    ),
                                    Divider(color: Colors.black.withOpacity(1))
                                  ],
                                );
                              })
                        ]))
                  ])
                ])))));
  }
}
