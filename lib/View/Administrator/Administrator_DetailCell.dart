import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/View/Administrator/Administrator_Feed.dart';
import 'package:parent_side/model/Entities/Activity.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import '../../model/Entities/Activities.dart';
import '../../model/globals.dart' as global;

class Detail extends StatefulWidget {
  final Teacher teacher;
  SchoolClass myClass;
  Activities activity;
  final type;
  Detail(this.teacher, this.myClass, this.activity, this.type);
  @override
  State<StatefulWidget> createState() {
    return DetailState(this.teacher, this.myClass, this.activity, this.type);
  }
}

class DetailState extends State<Detail> {
  final webApi = ApiService();
  Activities activity;
  SchoolClass myClass;
  DateTime date = DateTime.now();
  var data = "";
  File _image;
  final Teacher teacher;
  final type;
  final _formKey = GlobalKey<FormState>();

  var titulo = "";
  var messagem = "";

  final apiUrl = "http://18.230.116.206/api/v1/";

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  DetailState(this.teacher, this.myClass, this.activity, this.type);
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
                "Editar atividade",
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
                child: SizedBox(
                    height: (height - keyboardHeight),
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                      new Container(
                          padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
                          height: height * 0.8,
                          width: double.maxFinite,
                          child: new Stack(
                            children: [
                              Positioned(
                                  top: height * 0.7,
                                  child: Stack(
                                    children: [
                                      Container(
                                          // padding: new EdgeInsets.fromLTRB(
                                          //       5, 0, 0, 0),
                                          //   alignment: Alignment.center,
                                          width: width * 0.88,
                                          padding: new EdgeInsets.fromLTRB(
                                              8, 0, 0, 0),
                                          child: new Image.asset(
                                            "assets/BotaoAprovar.png",
                                            scale: 0.95,
                                          )),
                                      Container(
                                          padding: new EdgeInsets.fromLTRB(
                                              0, 0, 120, 0),
                                          height: height * 0.1,
                                          width: width + 80,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: height * 0.1,
                                                width: width / 2.5,
                                                child: TextButton(
                                                    onPressed: () {
                                                      _formKey.currentState
                                                          .save();
                                                      var haveImage = false;
                                                      if (this
                                                              .activity
                                                              .images !=
                                                          null) {
                                                        this.webApi.uploadImage(
                                                            this.activity.id,
                                                            this._image);
                                                        haveImage = true;
                                                      }
                                                      Activity myActivity;
                                                      if (this
                                                              .activity
                                                              .activity ==
                                                          "Note") {
                                                        myActivity = Activity(
                                                            id: this
                                                                .activity
                                                                .id,
                                                            date: this.data ==
                                                                    ""
                                                                ? this
                                                                    .activity
                                                                    .created_at
                                                                : this.data,
                                                            description: this
                                                                .activity
                                                                .note,
                                                            type: this
                                                                .activity
                                                                .activity,
                                                            message: this
                                                                        .messagem ==
                                                                    this
                                                                        .activity
                                                                        .note
                                                                ? this
                                                                    .activity
                                                                    .note
                                                                : this.messagem,
                                                            name: this.titulo ==
                                                                    this
                                                                        .activity
                                                                        .activity
                                                                ? this
                                                                    .activity
                                                                    .activity
                                                                : this.titulo,
                                                            haveImage:
                                                                haveImage,
                                                            schoolClass: this
                                                                .activity
                                                                .class_id,
                                                            isApproved: false,
                                                            time: this
                                                                .activity
                                                                .created_at
                                                                .toDate()
                                                                .toString()
                                                                .substring(11));
                                                      } else {
                                                        myActivity = Activity(
                                                            id: this
                                                                .activity
                                                                .id,
                                                            date: this.data == ""
                                                                ? this
                                                                    .activity
                                                                    .created_at
                                                                : this.data,
                                                            description: this
                                                                        .messagem ==
                                                                    this
                                                                        .activity
                                                                        .note
                                                                ? this
                                                                    .activity
                                                                    .note
                                                                : this.messagem,
                                                            type: this
                                                                .activity
                                                                .activity,
                                                            message: this
                                                                .activity
                                                                .note,
                                                            name: this.titulo ==
                                                                    this
                                                                        .activity
                                                                        .activity
                                                                ? this
                                                                    .activity
                                                                    .activity
                                                                : this.titulo,
                                                            haveImage:
                                                                haveImage,
                                                            schoolClass: this
                                                                .activity
                                                                .class_id,
                                                            isApproved: false,
                                                            time: this
                                                                .activity
                                                                .created_at
                                                                .toDate()
                                                                .toString()
                                                                .substring(11));
                                                      }
                                                      this
                                                          .webApi
                                                          .updateActivity(
                                                              myActivity);

                                                      //MANDAR IMAGEM

                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new AdministratorFeed(
                                                                      this.teacher,
                                                                      this.myClass)));
                                                    },
                                                    child: Text("")),
                                              ),
                                              SizedBox(
                                                height: height * 0.1,
                                                width: width / 2.5,
                                                child: TextButton(
                                                    onPressed: () async {
                                                      //DELETAR A ATIVIDADE - activity datailcell
                                                      final activityid =
                                                          this.activity.id;
                                                      final responsePivot =
                                                          await this
                                                              .webApi
                                                              .deleteActivityPivot(
                                                                  activityid);
                                                      if (responsePivot
                                                              .statusCode ==
                                                          204) {
                                                        // final responseActivity =
                                                        await this
                                                            .webApi
                                                            .deleteActivity(
                                                                activityid);
                                                      }

                                                      Navigator.push(
                                                          context,
                                                          new MaterialPageRoute(
                                                              builder: (context) =>
                                                                  new AdministratorFeed(
                                                                      this.teacher,
                                                                      this.myClass)));
                                                    },
                                                    child: Text("")),
                                              ),
                                            ],
                                          )),
                                    ],
                                  )),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        height: height * 0.66,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17.0),
                                          ),
                                          color: this.type == 1
                                              ? global.NoteColor
                                              : global.HomeWorkColor,
                                          child: new Stack(
                                            children: [
                                              Positioned(
                                                top: height * 0.01,
                                                left: width * 0.06,
                                                height: height * 0.05,
                                                width: width,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: this.type == 1
                                                      ? <Widget>[
                                                          //Imagem do Título
                                                          Image.asset(
                                                              'assets/note@2x.png',
                                                              scale: 1.5),
                                                          new Container(
                                                            width:
                                                                width * 0.025,
                                                          ),
                                                          Text(
                                                            "Aviso",
                                                            style: new TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ]
                                                      : <Widget>[
                                                          //Imagem do Título
                                                          Image.asset(
                                                              'assets/homework@2x.png',
                                                              scale: 1.2),
                                                          new Container(
                                                            width:
                                                                width * 0.025,
                                                          ),
                                                          Text(
                                                            "Dever de casa",
                                                            style: new TextStyle(
                                                                fontSize: 16.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                ),
                                              ),
                                              Positioned(
                                                  top: height * 0.06,
                                                  left: width * 0.055,
                                                  height: height * 0.06,
                                                  width: width - (width * 0.22),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    color: this.type == 1
                                                        ? global.NoteColor2
                                                        : global.HomeWorkColor2,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              new EdgeInsets
                                                                      .fromLTRB(
                                                                  12,
                                                                  15,
                                                                  0,
                                                                  10),
                                                          child: Text(
                                                            "Título",
                                                            style: new TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              padding:
                                                                  new EdgeInsets
                                                                          .fromLTRB(
                                                                      10,
                                                                      0,
                                                                      10,
                                                                      12),
                                                              child:
                                                                  TextFormField(
                                                                onSaved: (String
                                                                    value) {
                                                                  this.titulo =
                                                                      value;
                                                                },
                                                                initialValue: this
                                                                    .activity
                                                                    .activity,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                ),
                                                                style: new TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  )),
                                              Positioned(
                                                  top: height * 0.13,
                                                  left: width * 0.055,
                                                  height: height * 0.06,
                                                  width: width - (width * 0.22),
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    color: this.type == 1
                                                        ? global.NoteColor2
                                                        : global.HomeWorkColor2,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              new EdgeInsets
                                                                      .fromLTRB(
                                                                  12,
                                                                  15,
                                                                  0,
                                                                  10),
                                                          child: Text(
                                                            "Data",
                                                            style: new TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 1,
                                                            child:
                                                                MaterialButton(
                                                              elevation: 0,
                                                              child: Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Text(
                                                                  "${this.data == "" ? this.activity.created_at : this.data}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: new TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              color: this.type ==
                                                                      1
                                                                  ? global
                                                                      .NoteColor2
                                                                  : global
                                                                      .HomeWorkColor2,
                                                              onPressed: () {
                                                                showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            builder) {
                                                                      return Container(
                                                                          child:
                                                                              CupertinoDatePicker(
                                                                        initialDateTime:
                                                                            DateTime.now(),
                                                                        onDateTimeChanged:
                                                                            (DateTime
                                                                                newdate) {
                                                                          setState(
                                                                              () {
                                                                            this.data =
                                                                                "${newdate.day}/${newdate.month}/${newdate.year}";
                                                                          });
                                                                        },
                                                                        use24hFormat:
                                                                            true,
                                                                        minimumYear:
                                                                            1900,
                                                                        minuteInterval:
                                                                            1,
                                                                        mode: CupertinoDatePickerMode
                                                                            .date,
                                                                      ));
                                                                    });
                                                              },
                                                            )),
                                                      ],
                                                    ),
                                                  )),
                                              this.activity.images != null ||
                                                      this._image != null
                                                  ? Positioned(
                                                      top: height * 0.2,
                                                      left: width * 0.055,
                                                      height: height * 0.11,
                                                      width: width -
                                                          (width * 0.75),
                                                      child: this._image == null
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                      imageUrl:
                                                                          "${this.apiUrl}images/${this.activity.id}",
                                                                      progressIndicatorBuilder: (context,
                                                                              url,
                                                                              downloadProgress) =>
                                                                          Center(
                                                                            child:
                                                                                CircularProgressIndicator(
                                                                              valueColor: new AlwaysStoppedAnimation<Color>(global.TopColor),
                                                                              value: downloadProgress.progress,
                                                                              strokeWidth: 4,
                                                                            ),
                                                                          ),
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Text(
                                                                              ""),
                                                                      fit: BoxFit
                                                                          .cover))
                                                          : ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7.0),
                                                              child: Image.file(
                                                                _image,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )))
                                                  : SizedBox(
                                                      width: width,
                                                      child: Text("")),
                                              Positioned(
                                                  top: height * 0.32,
                                                  left: width * 0.055,
                                                  height: height * 0.3,
                                                  width: width - (width * 0.22),
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      color: this.type == 1
                                                          ? global.NoteColor2
                                                          : global
                                                              .HomeWorkColor2,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                new EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    5,
                                                                    0,
                                                                    0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: <
                                                                  Widget>[
                                                                //Imagem do Título
                                                                Image.asset(
                                                                    'assets/note@2x.png',
                                                                    scale: 1.7),
                                                                new Container(
                                                                  width: width *
                                                                      0.45,
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    getImage();
                                                                  },
                                                                  child: Image
                                                                      .asset(
                                                                          'assets/NotePlusButton.png'),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child:
                                                                new SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis
                                                                            .vertical,
                                                                    child:
                                                                        Container(
                                                                      padding: new EdgeInsets
                                                                              .fromLTRB(
                                                                          15,
                                                                          20,
                                                                          5,
                                                                          10),
                                                                      child:
                                                                          TextFormField(
                                                                        onSaved:
                                                                            (String
                                                                                value) {
                                                                          this.messagem =
                                                                              value;
                                                                        },
                                                                        initialValue: this
                                                                            .activity
                                                                            .note,
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        maxLines:
                                                                            null,
                                                                        decoration:
                                                                            const InputDecoration(
                                                                          border:
                                                                              InputBorder.none,
                                                                        ),
                                                                        style: new TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                    )),
                                                          ),
                                                        ],
                                                      )))
                                            ],
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ))
                    ]))))));
  }
}
