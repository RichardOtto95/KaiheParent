import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_ClassCell.dart';
import 'package:parent_side/View/Animations/Loader.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/SharedPrefApp.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/globals.dart' as global;
import 'package:parent_side/View/ChangeProfile.dart';
import 'package:parent_side/View/LoginView.dart';

class AdministratorClassList extends StatefulWidget {
  final Teacher teacher;
  AdministratorClassList({this.teacher});
  @override
  State<StatefulWidget> createState() {
    return new AdministratorClassListState(teacher: this.teacher);
  }
}

class AdministratorClassListState extends State<AdministratorClassList> {
  Teacher teacher;
  final webApi = ApiService();
  var _isLoading = true;
  var _noInternet = false;
  var sharedSetting = SharedPrefApp();
  List<int> countOfAct = [];
  List<SchoolClass> mySchoolClass = [];
  var ourStudents = [
    Student(id: "9abbc776-a1c9-43b8-b91f-9fa32c90976c", name: "Administrador"),
  ];

  AdministratorClassListState({this.teacher}) {
    if (teacher == null) {
      getTeacherAdmin();
    } else {
      this.getClasses();
    }
    //
  }

  Future<void> getTeacherAdmin() async {
    final teacherMail = await this.sharedSetting.getAdminEmail();
    this.teacher = await this.webApi.fetchTeacherByEmail(teacherMail);
    // this.teacher = allowedAdmin;
    this.getClasses();
  }

  Future<void> _saveLogin(var isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isLogin", isLogin);
  }

  Future<void> getClasses() async {
    final result = await this.webApi.fetchTeacherClassPivot(this.teacher.id);
    for (var pivot in result) {
      final currenctClass = await this.webApi.fetchClass(pivot.schoolClass_id);
      final activitiesCount = await this
          .webApi
          .fetchActivityCount(pivot.schoolClass_id, DateTime.now());
      setState(() {
        this.mySchoolClass.add(currenctClass);
        this.countOfAct.add(activitiesCount);
      });
    }
  }

  Future<void> updateFeed() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      setState(() {
        _noInternet = true;
        _isLoading = false;
      });
      print('no internet');
    }
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.42,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                      itemCount: this.ourStudents.length,
                      itemBuilder: (context, i) {
                        return Container();
                      }),
                ),
                Divider(color: Colors.black.withOpacity(0.6)),
                ListTile(
                    leading: new Icon(Icons.library_add_rounded),
                    title: new Text('Adicionar aluno'),
                    onTap: () => {
                          _saveLogin("LogOut"),
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                              (Route<dynamic> route) => false)
                        }),
                ListTile(
                    leading: new Icon(Icons.logout),
                    title: new Text('logout'),
                    onTap: () => {
                          //remover currentStudent do array
                          //atualizar userDefault
                          //Navigator to childFeed com o aluno do array
                          //Se o array tiver vazio vai pra loginView
                          _saveLogin("LogOut"),
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                              (Route<dynamic> route) => false)
                        }),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: AppBar(
            backgroundColor: global.TopColor,
            title: Text(
              "${this.teacher.name}",
              style: new TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(
                  Icons.more_horiz,
                  size: 30,
                ),
                onPressed: () {
                  _showModalBottomSheet(context);
                },
              )
            ],
          ),
          body: _noInternet
              ? new RefreshIndicator(
                  child: ListView(
                    children: [
                      new Container(
                        height: height * 0.18,
                      ),
                      Center(
                          child: Image.asset('assets/Sem_conexão@2x.png',
                              scale: 2))
                    ],
                  ),
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    this.updateFeed();
                  })
              : Column(
                  children: [
                    SizedBox(
                      height: height - (height * 0.17),
                      child: new RefreshIndicator(
                        child: new ListView.builder(
                            itemCount: this.mySchoolClass.length,
                            itemBuilder: (context, i) {
                              return Row(
                                children: [
                                  ClassCell(
                                      width,
                                      height,
                                      this.teacher,
                                      this.mySchoolClass[i],
                                      this.mySchoolClass[i].grade.split(' '),
                                      this.countOfAct[i])
                                ],
                              );
                            }),
                        onRefresh: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          this.updateFeed();
                        },
                      ),
                    ),
                  ],
                )),
    );
  }
}
