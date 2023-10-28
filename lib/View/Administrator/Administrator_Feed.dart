import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_Main.dart';
import 'package:parent_side/View/Administrator/Administrator_StudentList.dart';
import 'package:parent_side/View/Animations/Loader.dart';
import 'package:parent_side/model/Entities/Activity.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Entities/Students.dart';
import '../../model/globals.dart' as global;
import 'package:parent_side/View/ChangeProfile.dart';
import 'package:parent_side/View/LoginView.dart';
import '../Activity_cell.dart';
import '../Date/date_picker_widget.dart';
import 'Administrator_DetailCell.dart';

class AdministratorFeed extends StatefulWidget {
  Teacher teacher;
  SchoolClass myClass;
  AdministratorFeed(this.teacher, this.myClass);
  @override
  State<StatefulWidget> createState() {
    return new AdministratorFeedState(this.teacher, this.myClass);
  }
}

class AdministratorFeedState extends State<AdministratorFeed> {
  final webApi = ApiService();
  Teacher teacher;
  SchoolClass myClass;
  List<Activity> activities = [];
  var _isLoading = true;
  var _noInternet = false;
  var _randomNumber = 0;
  var random = new Random();
  var ourStudents = [
    Student(id: "9abbc776-a1c9-43b8-b91f-9fa32c90976c", name: "Administrador"),
  ];
  List<Students> students = [];

  AdministratorFeedState(this.teacher, this.myClass) {
    this.fetchStudents();
  }

  Future<void> fetchStudents() async {
    // this.students = await this.webApi.fetchStudentByClass(this.myClass.id);
    print("");
  }

  Future<void> _saveLogin(var isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isLogin", isLogin);
  }

  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();

  void setUpSelection() {
    setState(() {
      _controller.jumpToSelection(context);
    });
  }

  Future<void> updateFeed() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        this._fetchActivityData();
        setState(() {
          _isLoading = false;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        _noInternet = true;
        _isLoading = false;
      });
      print('no internet');
    }
  }

  Future<void> _fetchActivityData() async {
    final result =
        await this.webApi.fetchActivityAdm(this.myClass.id, _selectedValue);
    setState(() {
      this.activities = result;
    });
  }

  @override
  void initState() {
    updateFeed().whenComplete(() {
      setUpSelection();
    });
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: ListView.builder(
                      itemCount:
                          this.ourStudents.length, //Colocar do tamanho do array
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
    var index = 1;

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: AppBar(
            backgroundColor: global.TopColor,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    new MaterialPageRoute(
                        builder: (context) =>
                            new AdministratorClassList(teacher: this.teacher)),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => StudentList(
                            this.myClass, this.teacher, this.students)));
              },
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this.myClass.grade,
                    style: new TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                  new Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
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
                    new Container(
                      height: height * 0.01,
                    ),
                    DatePicker(
                      DateTime.now().subtract(Duration(days: 30)),
                      height: height * 0.11,
                      width: width * 0.19,
                      controller: _controller,
                      initialSelectedDate: DateTime.now(),
                      locale: "pt-BR",
                      onDateChange: (date) {
                        setState(() {
                          _selectedValue = date;
                          print("Data selecionada ${date.day}");
                          _isLoading = true;
                        });
                        this.updateFeed();
                      },
                    ),
                    SizedBox(
                      height: height - (height * 0.27),
                      child: new RefreshIndicator(
                        child: _isLoading
                            ? new ColorLoader(
                                radius: 35.0,
                                dotRadius: 11.0,
                              )
                            : Center(
                                child: new ListView.builder(
                                    itemCount: this.activities.length,
                                    // ignore: missing_return
                                    itemBuilder: (context, i) {
                                      //this.activities == null
                                      if (this.activities.isEmpty) {
                                        _randomNumber = random.nextInt(3);
                                        return SizedBox(
                                            height: height - (height * 0.23),
                                            child: RefreshIndicator(
                                                child: ListView(
                                                  children: [
                                                    new Container(
                                                      height: height * 0.1,
                                                    ),
                                                    Center(
                                                        child: Image.asset(
                                                            _randomNumber == 1
                                                                ? 'assets/SemAtividade1@2x.png'
                                                                : _randomNumber ==
                                                                        2
                                                                    ? 'assets/SemAtividade2@2x.png'
                                                                    : 'assets/SemAtividade3@2x.png',
                                                            scale: 2))
                                                  ],
                                                ),
                                                onRefresh: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                    this._selectedValue =
                                                        DateTime.now();
                                                    setUpSelection();
                                                  });
                                                  this.updateFeed();
                                                }));
                                      } else {
                                        index = this
                                            .webApi
                                            .transform(this.activities[i].type);

                                        if (index == 1) {
                                          //Chamada

                                          return new Container();
                                          //   ActivitySimpleCell(
                                          //     activities[i],
                                          //     width,
                                          //     height,
                                          //     'assets/icone_chamada@2x.png',
                                          //     global.AttendanceColor,
                                          //     global.AttendanceColor2,
                                          //     true,
                                          //     myClass: this.myClass,
                                          //   );
                                          // } else if (index == 2) {
                                          //   //Comida

                                          //   return new ActivitySimpleCell(
                                          //       activities[i],
                                          //       width,
                                          //       height,
                                          //       'assets/food@2x.png',
                                          //       global.FoodColor,
                                          //       global.FoodColor2,
                                          //       true,
                                          //       myClass: this.myClass);
                                          // } else if (index == 3) {
                                          //   //Banheiro

                                          //   return new ActivitySimpleCell(
                                          //       activities[i],
                                          //       width,
                                          //       height,
                                          //       'assets/bathroom@2x.png',
                                          //       global.BathroomColor,
                                          //       global.BathroomColor2,
                                          //       true,
                                          //       myClass: this.myClass);
                                          // } else if (index == 4) {
                                          //   return HomeWorkCell(activities[i],
                                          //       width, height, true,
                                          //       myClass: this.myClass);
                                          // } else if (index == 5) {
                                          //   var medals =
                                          //       activities[i].type.split(':');
                                          //   return MomentCell(activities[i],
                                          //       width, height, medals, true,
                                          //       teacher: this.teacher,
                                          //       myClass: this.myClass);
                                          // } else if (index == 6) {
                                          //   var medals =
                                          //       activities[i].type.split(':');
                                          //   return NoteCell(
                                          //       activities[i], medals, true,
                                          //       teacher: this.teacher,
                                          //       myClass: this.myClass);
                                          // } else if (index == 8) {
                                          //   //Soneca
                                          //   return new ActivitySimpleCell(
                                          //       activities[i],
                                          //       width,
                                          //       height,
                                          //       'assets/sleep@2x.png',
                                          //       global.SleepColor,
                                          //       global.SleepColor2,
                                          //       true,
                                          //       myClass: this.myClass);
                                          // } else if (index == 9) {
                                          //   //Soneca
                                          //   return new MessageCell(
                                          //       activities[i], width, height);
                                          // }
                                        }
                                      }
                                    }),
                              ),
                        onRefresh: () async {
                          setState(() {
                            _isLoading = true;
                            this._selectedValue = DateTime.now();
                            setUpSelection();
                          });
                          this.updateFeed();
                        },
                      ),
                    )
                  ],
                )),
    );
  }
}
