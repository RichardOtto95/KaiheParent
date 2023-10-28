import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_DetailCell.dart';
import 'package:parent_side/View/Administrator/Admistrator_ActivityDetail.dart';
import 'package:parent_side/View/PhotoVIew.dart';
import 'package:parent_side/model/Entities/Activities.dart';
import 'package:parent_side/model/Entities/Activity.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/StudentActivity.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import 'package:parent_side/model/StarRating.dart';
import 'package:slide_to_act/slide_to_act.dart';
import '../model/Entities/Students.dart';
import '../model/globals.dart' as global;

// Atende as celulas de Chamada, alimentação, banheiro e soneca

class ActivitySimpleCell extends StatelessWidget {
  final Activities activity;

  final width;
  final height;
  final icon;
  final color;
  final secondColor;

  var type;

  final apiUrl = "http://18.230.116.206/api/v1/";
  final webApi = ApiService();
  bool _isAdministrator;
  Teacher teacher;
  SchoolClass myClass;

  String _getIcon(Activities activity) {
    switch (activity.activity) {
      case "BATHROOM":
        if (activity.option != null) {
          if (activity.option == "TEETH") {
            return 'assets/Icone_Escovoudentes@2x.png';
          } else {
            return 'assets/water.png';
          }
        }

        if (activity.what != null) {
          if (activity.what == "EVACUATED") {
            return 'assets/paper@2x.png';
          } else if (activity.option == "SHOWER") {
            return 'assets/Icone_Escovoudentes@2x.png';
          } else if (activity.what == "URINATED") {
            return 'assets/water.png';
          }
        }
        break;
      case "ATTENDANCE":
        if (activity.attendence == "PRESENT") {
          return 'assets/Bola_presente@2x.png';
        } else if (activity.attendence == "LATE") {
          return 'assets/Bola_Atrasado@2x.png';
        } else if (activity.attendence == "ABSENT") {
          return 'assets/Bola_Faltou@2x.png';
        } else {
          return 'assets/Bola_SaiuCedo@2x.png';
        }
    }

    if (activity.activity == "WATTER") {
      return 'assets/icone_bebida@2x.png';
    }

    if (activity.activity == "FOOD") {
      return 'assets/icone_comida.png';
    }

    if (activity.activity == "SLEEP") {
      return 'assets/icone_dormiu@2x.png';
    }

    return 'assets/Bola_presente@2x.png';
  }

  String getActivityType(Activities activity) {
    return activity.activity;
  }

  String getActivity(String activity) {
    switch (activity) {
      case "SLEEP":
        return "Soneca";
        break;
      case "BATHROOM":
        return "Banheiro";
        break;
      case "MOMENTS":
        return "Momentos";
        break;
      case "FOOD":
        return "Alimentação";
        break;
      case "ATTENDANCE":
        return "Chamada";
        break;
      default:
        return "Atividade";
        break;
    }
  }

  ActivitySimpleCell(
    this.activity,
    this.width,
    this.height,
    this.icon,
    this.color,
    this.secondColor,
    this._isAdministrator, {
    this.teacher,
    this.myClass,
  });

  @override
  Widget build(BuildContext context) {
    return new TextButton(
      onPressed: () {
        print("");
      },
      child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Container(
            decoration: BoxDecoration(
                color: color, borderRadius: new BorderRadius.circular(17.0)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Imagem do Título
                      Image.asset(icon, scale: 1.3),
                      SizedBox(width: 10),
                      Text(
                        this.getActivity(this.activity.activity),
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                          decoration: BoxDecoration(
                            color: secondColor,
                            borderRadius: new BorderRadius.circular(17.0),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    new Container(
                                      width: width * 0.025,
                                    ),
                                    Text(
                                      this
                                          .activity
                                          .created_at
                                          .toDate()
                                          .toString()
                                          .substring(11, 16),
                                      style: new TextStyle(
                                          fontSize: 14.0, color: Colors.white),
                                    ),
                                    new Container(
                                      width: width * 0.025,
                                    ),
                                    //Imagem da mensagem
                                    Image.asset(
                                      _getIcon(activity),
                                      width: width * 0.08,
                                      height: height * 0.05,
                                    ),
                                    new Container(
                                      width: width * 0.025,
                                    ),
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          this.activity.title,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ]))),
                  SizedBox(height: this.activity.title != "" ? 15 : 0),
                  if (this.activity.note != null && this.activity.note != "")
                    SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Container(
                        decoration: BoxDecoration(
                          color: secondColor,
                          borderRadius: new BorderRadius.circular(17.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: new EdgeInsets.fromLTRB(10, 15, 0, 10),
                              child: Text(
                                this.activity.note,
                                style: new TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: new Scrollbar(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        padding: new EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Text(
                                          "", //TESTE
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (this.activity.images != null)
                    ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: this.activity.images.length,
                      itemBuilder: (context, i) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        new PhotoView(
                                                            "${this.activity.images[i]}")));
                                          },
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            "${this.activity.images[i]}"),
                                                        fit: BoxFit.fitWidth)),
                                              ))),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                ],
              ),
            ),
          )),
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
    );
  }
}

class HomeWorkCell extends StatefulWidget {
  Activities activity;
  final width;
  final height;
  bool _isAdministrator;
  Teacher teacher;
  SchoolClass myClass;

  HomeWorkCell(
    this.activity,
    this.width,
    this.height,
    this._isAdministrator, {
    this.teacher,
    this.myClass,
  });

  @override
  State<HomeWorkCell> createState() => _HomeWorkCellState();
}

class _HomeWorkCellState extends State<HomeWorkCell> {
  final apiUrl = "http://18.230.116.206/api/v1/";

  final webApi = ApiService();

  var showEvaluation = false;
  double _currentSliderValue = 0;
  double _currentStarValue = 0;

  @override
  Widget build(BuildContext context) {
    return new TextButton(
      onPressed: () {
        if (widget._isAdministrator && this.widget.activity.note != null) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Detail(
                      widget.teacher, widget.myClass, widget.activity, 2)),
              (Route<dynamic> route) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
          decoration: BoxDecoration(
              color: global.HomeWorkColor,
              borderRadius: new BorderRadius.circular(17.0)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Imagem do Título
                    Image.asset('assets/homework@2x.png', scale: 1.3),
                    SizedBox(width: 10),
                    Center(
                      child: Text(
                        "Dever de casa",
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (this.widget.activity.activity != "")
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: global.HomeWorkColor2,
                        borderRadius: new BorderRadius.circular(17.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 15, 0, 10),
                            child: Text(
                              this.widget.activity.title,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (this.widget.activity.note != null)
                            Expanded(
                              flex: 1,
                              child: new Scrollbar(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        padding: new EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Text(
                                          this.widget.activity.note,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (this.widget.activity.images != null)
                  Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new PhotoView(
                                        "${this.apiUrl}images/${this.widget.activity.id}")));
                          },
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(7.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${this.apiUrl}images/${this.widget.activity.id}"),
                                        fit: BoxFit.fill)),
                              ))),
                    ),
                  ),
                SizedBox(height: global.defaultPadding),
              ],
            ),
          ),
        ),
      ),
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
    );
  }
}

class NoteCell extends StatefulWidget {
  Activities activity;
  Teacher teacher;
  SchoolClass myClass;
  bool _isAdministrator;
  Students student;
  var medals = [];
  final webApi = ApiService();
  NoteCell(
    this.activity,
    // this.medals,
    this._isAdministrator, {
    this.teacher,
    this.myClass,
    this.student,
  });

  @override
  _NoteCellState createState() =>
      _NoteCellState(this.activity, this.medals, this._isAdministrator,
          teacher: this.teacher, myClass: this.myClass, student: this.student);
}

class _NoteCellState extends State<NoteCell> {
  final apiUrl = "http://18.230.116.206/api/v1/";
  final webApi = ApiService();
  bool autorizado = false;
  bool color = false;
  Students student;
  Activities activity;
  Teacher teacher;
  SchoolClass myClass;
  bool _isAdministrator;
  var medals;

  _NoteCellState(
    this.activity,
    this.medals,
    this._isAdministrator, {
    this.teacher,
    this.myClass,
    this.student,
  });

  _getMedal(var index) {
    if (index == '1') {
      return 'assets/se_machucou.png';
    } else if (index == '2') {
      return 'assets/nãoCompriu.png';
    } else if (index == '3') {
      return 'assets/se_desentendeu.png';
    }
  }

  // void fetchPivotActivity(bool auth) async {
  //   if (this.student == null) {
  //     return;
  //   }
  //   // await this.webApi.updateAuth(this.student.id, this.activity, auth);
  // }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (_isAdministrator) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Detail(teacher, myClass, activity, 1)),
              (Route<dynamic> route) => false);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
          decoration: BoxDecoration(
              color: global.NoteColor,
              borderRadius: new BorderRadius.circular(17.0)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Imagem do Título
                    Image.asset('assets/note@2x.png', scale: 1.5),
                    SizedBox(width: 10),
                    Text(
                      "Bilhete",
                      style: new TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                if (widget.activity.activity != "")
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: global.NoteColor2,
                        borderRadius: new BorderRadius.circular(17.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 15, 0, 10),
                            child: Text(
                              this.activity.title,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (activity.note != null)
                            Expanded(
                              flex: 1,
                              child: new Scrollbar(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Container(
                                        padding: new EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Text(
                                          widget.activity.note,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (widget.medals.length > 1)
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: this.widget.medals.length - 1,
                        itemBuilder: (context, i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      _getMedal(widget.medals[i + 1]),
                                      scale: 1.3,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                if (this.activity.images != null)
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: this.activity.images.length,
                    itemBuilder: (context, i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      new PhotoView(
                                                          "${this.activity.images[i]}")));
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          "${this.activity.images[i]}"),
                                                      fit: BoxFit.fitWidth)),
                                            ))),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                //AUTH SLIDEEE
                // if (activity.needAuth)
                //   SizedBox(
                //     height: 130,
                //     child: Column(children: <Widget>[
                //       SizedBox(height: 15),
                //       !this.autorizado
                //           ? Builder(
                //               builder: (context) {
                //                 final GlobalKey<SlideActionState> _key =
                //                     GlobalKey();
                //                 return SizedBox(
                //                   height: 50,
                //                   child: SlideAction(
                //                     key: _key,
                //                     outerColor: !this.color
                //                         ? Colors.white
                //                         : global.NoteColor2,
                //                     innerColor: !this.color
                //                         ? global.NoteColor
                //                         : Colors.white,
                //                     text: "Arraste para autorizar",
                //                     textStyle: TextStyle(color: Colors.black54),
                //                     sliderButtonIconSize: 19,
                //                     sliderButtonIconPadding: 10,
                //                     borderRadius: 9,
                //                     onSubmit: () {
                //                       Future.delayed(Duration(seconds: 1),
                //                           () => _key.currentState.reset());
                //                       Future.delayed(
                //                           Duration(milliseconds: 2150),
                //                           () => setState(() {
                //                                 this.color = false;
                //                                 this.autorizado = true;
                //                               }));
                //                       this.fetchPivotActivity(true);
                //                       print("FAZER O POST DE APROVADO");
                //                     },
                //                   ),
                //                 );
                //               },
                //             )
                //           : Container(
                //               height: 50,
                //               width: double.infinity,
                //               decoration: BoxDecoration(
                //                 color: Colors.white,
                //                 border: Border.all(color: global.NoteColor2),
                //                 borderRadius: new BorderRadius.circular(9.0),
                //               ),
                //               child: Padding(
                //                 padding: const EdgeInsets.only(left: 8.0),
                //                 child: Stack(
                //                   children: [
                //                     Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.start,
                //                       children: [
                //                         Center(
                //                           child: Image.asset(
                //                               "assets/Icone_True.png",
                //                               scale: 0.8),
                //                         ),
                //                       ],
                //                     ),
                //                     Center(
                //                       child: Text(
                //                         "Autorizado",
                //                         style: TextStyle(
                //                             color: Colors.black45,
                //                             fontSize: 15),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //       SizedBox(height: 15),
                //       Container(
                //           height: 48,
                //           width: double.infinity,
                //           decoration: BoxDecoration(
                //             color:
                //                 this.color ? Colors.white : global.NoteColor2,
                //             border: Border.all(color: Colors.white),
                //             borderRadius: new BorderRadius.circular(9.0),
                //           ),
                //           child: TextButton(
                //               onPressed: () {
                //                 if (this.autorizado != false)
                //                   this.fetchPivotActivity(false);
                //                 setState(() {
                //                   this.color = true;
                //                   this.autorizado = false;
                //                 });
                //               },
                //               child: Text(
                //                 this.color ? "Não autorizado" : "Não autorizar",
                //                 style: TextStyle(
                //                     color: this.color
                //                         ? Colors.black54
                //                         : Colors.white),
                //               )))
                //     ]),
                //   )
              ],
            ),
          ),
        ),
      ),
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
    );
  }
}

class MomentCell extends StatelessWidget {
  Activities activity;
  final width;
  final height;
  var medals = [];
  final apiUrl = "http://18.230.116.206/api/v1/";
  final webApi = ApiService();

  MomentCell(this.activity, this.width, this.height);

  _getMedal(var index) {
    if (index == '1') {
      return 'assets/icon_momento_BomComportamento@2x.png';
    } else if (index == '2') {
      return 'assets/icon_momento_Participação@2x.png';
    } else if (index == '3') {
      return 'assets/icon_momento_HoraDaDiversão@2x.png';
    } else if (index == '4') {
      return 'assets/icon_momento_TrabalhoEmEquipe@2x.png';
    } else if (index == '5') {
      return 'assets/icon_momento_ÓtimoTrabalho@2x.png';
    } else {
      return 'assets/icon_momento_AjudouOsAmigos@2x.png';
    }
  }

  double _checkSize() {
    if (activity.note != "" && activity.images != null) {
      return medals.length == 1 ? 0.51 : 0.6;
    } else if (activity.note != "" && activity.images != null) {
      return medals.length == 1 ? 0.3 : 0.4;
    } else if (activity.note == "" && activity.images != null) {
      return 0.34;
    } else if (activity.images != null) {
      return 0.52;
    } else {
      return 0.25;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // if (_isAdministrator) {
        //   Navigator.of(context).pushAndRemoveUntil(
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               ActivityDetail(teacher, myClass, activity, 4)),
        //       (Route<dynamic> route) => false);
        // }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Container(
          decoration: BoxDecoration(
              color: global.MomentColor,
              borderRadius: new BorderRadius.circular(17.0)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Imagem do Título
                    Image.asset('assets/icone_momento@2x.png', scale: 1.6),
                    SizedBox(width: 5),
                    Center(
                      child: Text(
                        "Momentos",
                        style:
                            new TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: this.activity.description != null ? 10 : 0),
                if (this.activity.title != null)
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Container(
                      decoration: BoxDecoration(
                        color: global.MomentColor2,
                        borderRadius: new BorderRadius.circular(17.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 15, 0, 10),
                            child: Text(
                              this.activity.title,
                              style: new TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (this.activity.description != null)
                            Expanded(
                              flex: 1,
                              child: new Scrollbar(
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Container(
                                        padding: new EdgeInsets.fromLTRB(
                                            10, 0, 0, 10),
                                        child: Text(
                                          this.activity.description,
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white),
                                        ),
                                      ))),
                            ),
                        ],
                      ),
                    ),
                  ),
                if (medals.length > 1)
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: this.medals.length - 1,
                        itemBuilder: (context, i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      _getMedal(this.medals[i + 1]),
                                      scale: 1.3,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                if (this.activity.images != null)
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: this.activity.images.length,
                        itemBuilder: (context, i) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new PhotoView(
                                                              "${this.activity.images[i]}")));
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(7.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              "${this.activity.images[i]}"),
                                                          fit:
                                                              BoxFit.fitWidth)),
                                                ))),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
      ),
    );
  }
}

class MessageCell extends StatelessWidget {
  Activity activity;
  Teacher teacher;
  SchoolClass myClass;
  final width;
  final height;
  final apiUrl = "http://18.230.116.206/api/v1/";
  final webApi = ApiService();

  MessageCell(
    this.activity,
    this.width,
    this.height,
  );

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: new EdgeInsets.fromLTRB(20, 20, 20, 0),
            height: height * 0.3,
            width: double.maxFinite,
            child: new Stack(
              children: [
                Container(
                  height: height * (activity.haveImage == false ? 0.28 : 0.36),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.0),
                      ),
                      color: global.MessageColor,
                      child: new Stack(
                        children: [
                          Positioned(
                            top: height * 0.01,
                            left: width * 0.06,
                            height: height * 0.05,
                            width: width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                //Imagem do Título
                                Image.asset(
                                    'assets/icon_envelope_card-prof@2x.png',
                                    scale: 1.5),
                                new Container(
                                  width: width * 0.025,
                                ),
                                Text(
                                  "Comunicado " +
                                      activity.description.split(":")[0],
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              top: height * 0.06,
                              left: width * 0.055,
                              height: height * 0.17,
                              width: width - (width * 0.22),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color: global.MessageColor2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: new EdgeInsets.fromLTRB(
                                          10, 15, 0, 10),
                                      child: Text(
                                        activity.description.split(":")[1] +
                                            "-" +
                                            activity.description.split(":")[2],
                                        style: new TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: new Scrollbar(
                                          child: SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Container(
                                                padding:
                                                    new EdgeInsets.fromLTRB(
                                                        10, 0, 0, 10),
                                                child: Text(
                                                  activity.message,
                                                  style: new TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                              ))),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )),
                ),
              ],
            )),
      ],
    );
  }
}
