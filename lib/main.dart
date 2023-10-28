import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parent_side/View/ChangeProfile.dart';
import 'package:parent_side/View/LoginView.dart';
import 'package:parent_side/model/Entities/Activities.dart';
import 'package:parent_side/model/Entities/Students.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './View/Activity_cell.dart';
import './model/globals.dart' as global;
import 'Service/ApiService.dart';
import 'View/AddStudent.dart';
import 'View/Animations/Loader.dart';
import 'View/Date/date_picker_widget.dart';
import 'View/Form/FormView.dart';
import 'View/Send Message/Message.dart';
import 'firebase_options.dart';
import 'model/Entities/Guardian.dart';
import 'model/Entities/ResponsibleModel.dart';
import 'model/Entities/SharedPrefApp.dart';
import 'model/Entities/Student.dart';
import 'model/Entities/StudentActivity.dart';
import 'model/Entities/Teacher.dart';

String studentsId;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var _login = "";
  Widget homeWidget;
  var _isAdmin = false;
  String adminEmail;
  var sharedSetting = SharedPrefApp();
  Teacher teacher;

  SharedPreferences.getInstance().then((intance) async {
    final webApi = ApiService();

    _login = intance.getString("isLogin");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    homeWidget =
        (_login != "LogOut" && _login != null) ? ChildFeed() : LoginView();

    User _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      QuerySnapshot studentsQuery = await FirebaseFirestore.instance
          .collection('parents')
          .doc(_user.uid)
          .collection('students')
          .orderBy('created_at', descending: true)
          .get();

      if (studentsQuery.docs.isNotEmpty) {
        studentsId = studentsQuery.docs.first.id;
      } else {
        if (_login != "LogOut" && _login != null) {
          homeWidget = AddStudentView(
            firstStudent: true,
          );
        }
      }
    } else {
      sharedSetting.setLogin("LogOut");
      homeWidget = LoginView();
    }

    // _getOnboard();
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeWidget,
    ));
  });
}

class ChildFeed extends StatefulWidget {
  final int selectedStudent;
  final bool isNew;
  final Students student;
  final String studentId;

  ChildFeed(
      {this.studentId,
      this.isNew = false,
      this.selectedStudent = 0,
      this.student});
  @override
  State<StatefulWidget> createState() {
    return new ChildFeedState(
        studentId: this.studentId,
        selectedStudent: this.selectedStudent,
        isNew: this.isNew,
        newStudent: this.student);
  }
}

class ChildFeedState extends State<ChildFeed> {
  final webApi = ApiService();
  final apiUrl = "http://18.230.116.206/api/v1/";
  var _isLoading = true;
  List<Activities> activities = [];
  Students currentStudent;
  List<StudentActivity> pivotAct;
  var _noInternet = false;
  var _randomNumber = 0;
  var random = new Random();
  var selectedStudent;
  var isNew;
  Students newStudent;
  var tesing;
  Image imageFetch;
  String studentId;
  var sharedSetting = SharedPrefApp();
  var studentName = "Carregando";
  List<String> myIds = [];
  List<Student> ourStudents = [];
  List<ResponsibleModel> studentGuardians = [];
  File fileTest;

  ChildFeedState(
      {this.studentId,
      this.isNew = false,
      this.selectedStudent = 0,
      this.newStudent});

  DateTime _selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();

  void setUpSelection() {
    setState(() {
      _controller.jumpToSelection(context);
    });
  }

  Future<void> verifyInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          this._noInternet = false;
          this._selectedValue = DateTime.now();
        });
        setUpSelection();
      }
    } on SocketException catch (_) {
      setState(() {
        this._noInternet = true;
      });
    }
  }

  Future<void> updateLastSeen(DateTime date) async {
    String formattedDate =
        DateFormat('kk:mm|dd MMM yyyy').format(DateTime.now());
    this.currentStudent.last_view = Timestamp.fromDate(date);

    ///TODO: Create update student method
    //updateStudent
  }

  Future<void> updateFeed(DateTime date) async {
    this.activities = [];
    var fetchedActivities = await webApi.getActvityFromDate(
        currentStudent.id, currentStudent.class_id, date);

    if (fetchedActivities.isNotEmpty) {
      this.activities = fetchedActivities;
    } else {
      fetchedActivities = null;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchPivot() async {
    final pivot = await this.webApi.fetchActivityPivot(this.currentStudent.id);
    pivotAct = pivot;
  }

  Future<void> _saveIds(List<String> ids) async {
    await sharedSetting.setStudentIdList(ids);
    print("id saved");
  }

  Future<List<ResponsibleModel>> getGuardianPivot(String studentID) async {
    this.studentGuardians = await webApi.getStudentResponsibles(studentID);

    return studentGuardians;
  }

  Future<Guardian> postGuardian(Guardian guardian, String studentID) async {
    final guardianPost = await this.webApi.postGuardian(guardian, studentID);
    await this.getGuardianPivot(studentID);
    return guardianPost;
  }

  Future<Guardian> updateGuardian(Guardian guardian, String studentID) async {
    final guardianPost = await this.webApi.updateGuardian(guardian);
    await this.getGuardianPivot(studentID);
    return guardianPost;
  }

  Future<void> _saveLogin(var isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("isLogin", isLogin);
  }

  Future<void> getCount() async {
    final me = await this.webApi.fetchActivityCount(
        "6BC3F8F5-9E06-4A79-87C8-1BF03DD5085E", DateTime.now());
    print(me);
  }

  void fetchStudet() async {
    String studentStatus;
    if (this.studentId != null) {
      studentStatus = this.studentId;
    } else {
      studentStatus = studentsId;
    }

    var myStudent = await webApi.fetchStudent(studentStatus);
    studentName = myStudent.username;

    setState(() {
      currentStudent = myStudent;
    });
    verifyInternet();
    getData();
  }

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  void getData() async {
    setLoading(true);
    this.activities = [];
    this.activities = await this.webApi.getActvityFromDate(
        currentStudent.id, currentStudent.class_id, _selectedValue);
    this.studentGuardians =
        await this.webApi.getStudentResponsibles(currentStudent.id);
    setLoading(false);
    webApi.updateLastView(currentStudent);
  }

  void _showModalBottomSheet(context) {
    User _user = FirebaseAuth.instance.currentUser;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.43,
            child: Wrap(
              children: <Widget>[
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('parents')
                        .doc(_user.uid)
                        .collection('students')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          alignment: Alignment.center,
                          // height: MediaQuery.of(context).size.height * 0.25,
                          child: LinearProgressIndicator(),
                        );
                      }
                      QuerySnapshot studentsQuery = snapshot.data;
                      return SizedBox(
                        height: studentsQuery.docs.isEmpty
                            ? 0
                            : MediaQuery.of(context).size.height * 0.25,
                        child: ListView.builder(
                          itemCount: studentsQuery.docs.length,
                          itemBuilder: (context, i) {
                            DocumentSnapshot studentDoc = studentsQuery.docs[i];
                            return ChangeProfile(this.currentStudent, i);
                          },
                        ),
                      );
                    }),
                Divider(color: Colors.black.withOpacity(0.6)),
                ListTile(
                  leading: new Icon(Icons.library_add_rounded),
                  title: new Text('Adicionar novo aluno'),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => new AddStudentView(
                          firstStudent: false,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: new Icon(Icons.logout),
                    title: new Text('logout'),
                    onTap: () => {
                          // if (ourStudents.isNotEmpty)
                          //   {
                          //     this.ourStudents.removeWhere(
                          //         (element) => element.id == currentStudent.id)
                          //   },
                          // this.myIds.removeAt(this.selectedStudent),
                          // if (this.ourStudents.length >= 1)
                          //   {
                          //     //TODO: MAKE LOGOUT
                          //     // this.currentStudent = this.ourStudents.last,
                          //     this.selectedStudent = this.ourStudents.length - 1
                          //   },
                          // this._saveIds(this.myIds),
                          // if (this.ourStudents.isEmpty)
                          //   {
                          _saveLogin("LogOut"),
                          FirebaseAuth.instance.signOut(),
                          currentStudent = null,
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginView()),
                              (Route<dynamic> route) => false)
                          //   }
                          // else
                          //   {
                          //     Navigator.of(context).pushAndRemoveUntil(
                          //         MaterialPageRoute(
                          //             builder: (context) => ChildFeed(
                          //                 selectedStudent: this.selectedStudent,
                          //                 isNew: false)),
                          //         (Route<dynamic> route) => false)
                          //   }
                        }),
                new Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                )
              ],
            ),
          ));
        });
  }

  @override
  initState() {
    super.initState();
    fetchStudet();

    // int studentIndex = selectedStudent;
    // super.initState();
    // this.getCount();
    // this._getStudent().whenComplete(() {
    //   if (this.isNew) {
    //     this.myIds.add(this.newStudent.registration);
    //     this.currentStudent = newStudent;

    //     this._saveIds(this.myIds);
    //     this.updateFeed().whenComplete(() {
    //       setUpSelection();
    //     });
    //   }

    //   _fetchStudent().whenComplete(() {
    //     if (!isNew) {
    //       this.selectedStudent = selectedStudent;
    //       this.currentStudent = this.ourStudents[selectedStudent];
    //     } else {
    //       studentIndex = this
    //           .ourStudents
    //           .indexWhere((element) => element.id == currentStudent.id);
    //       if (studentIndex >= 0) {
    //         this.selectedStudent = studentIndex;
    //       } else {
    //         this.selectedStudent = 0;
    //       }
    //     }
    //     this.updateFeed();
    //     this.updateLastSeen(DateTime.now());
    //
    //     setUpSelection();
    //   });
    //   // this.currentStudent = this.ourStudents[selectedStudent];

    //   //
    // });

    // setUpSelection();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
          appBar: AppBar(
            backgroundColor: global.TopColor,
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        //             //TODO: MAKE SEND MSG LOGIC
                        builder: (context) =>
                            // new Container()
                            Message(
                              this.currentStudent,
                              this.studentGuardians,
                              this.currentStudent.class_id,
                            )));
              },
              icon: Image.asset('assets/note@2x.png', scale: 1.8),
            ),
            title: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => this._noInternet != true
                            ? FormView(height, width, this.currentStudent,
                                guardians: this.studentGuardians,
                                selectedStudent: this.selectedStudent)
                            : ChildFeed()));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 190,
                    child: Center(
                      child: Text(
                        this.studentName,
                        style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
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
                    this.updateFeed(_selectedValue);
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
                        this.updateFeed(date);
                      },
                    ),
                    SizedBox(
                      height: height - (height * 0.26),
                      child: new RefreshIndicator(
                        child: Center(
                          child: _isLoading
                              ? new ColorLoader(
                                  radius: 35.0,
                                  dotRadius: 11.0,
                                )
                              : new ListView.builder(
                                  itemCount: this.activities.isNotEmpty
                                      ? this.activities.length
                                      : 1,
                                  // ignore: missing_return
                                  itemBuilder: (context, i) {
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
                                                this.verifyInternet();
                                                setState(() {
                                                  _isLoading = true;
                                                  this._selectedValue =
                                                      DateTime.now();
                                                  setUpSelection();
                                                });

                                                this.updateFeed(_selectedValue);
                                              }));
                                    } else {
                                      //return SleepDevelopmentCell();
                                      var index = this.activities[i].activity;
                                      if (index == "ATTENDANCE") {
                                        //Chamada

                                        return new ActivitySimpleCell(
                                          activities[i],
                                          width,
                                          height,
                                          'assets/icone_chamada@2x.png',
                                          global.AttendanceColor,
                                          global.AttendanceColor2,
                                          false,
                                        );
                                      } else if (index == "FOOD") {
                                        //Comida
                                        return new ActivitySimpleCell(
                                          activities[i],
                                          width,
                                          height,
                                          'assets/food@2x.png',
                                          global.FoodColor,
                                          global.FoodColor2,
                                          false,
                                        );
                                      } else if (index == "BATHROOM") {
                                        //Banheiro

                                        return new ActivitySimpleCell(
                                          activities[i],
                                          width,
                                          height,
                                          'assets/bathroom@2x.png',
                                          global.BathroomColor,
                                          global.BathroomColor2,
                                          false,
                                        );
                                      } else if (index == "HOMEWORK") {
                                        return HomeWorkCell(
                                          activities[i],
                                          width,
                                          height,
                                          false,
                                        );
                                      } else if (index == "MOMENT") {
                                        return MomentCell(
                                            activities[i], width, height);
                                      } else if (index == "NOTE") {
                                        return NoteCell(activities[i], false,
                                            student: currentStudent);
                                      } else if (index == "SLEEP") {
                                        //Soneca
                                        return new ActivitySimpleCell(
                                          activities[i],
                                          width,
                                          height,
                                          'assets/sleep@2x.png',
                                          global.SleepColor,
                                          global.SleepColor2,
                                          false,
                                        );
                                      } else {
                                        return Text("");
                                      }
                                    }
                                  },
                                ),
                        ),
                        onRefresh: () async {
                          setState(() {
                            _isLoading = true;
                            this._selectedValue = DateTime.now();
                            setUpSelection();
                          });
                          this.updateFeed(_selectedValue);
                        },
                      ),
                    )
                  ],
                )),
    );
  }
}
