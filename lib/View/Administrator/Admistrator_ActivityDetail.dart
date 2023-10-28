// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:parent_side/Service/ApiService.dart';
// import 'package:parent_side/View/Administrator/Administrator_Feed.dart';
// import 'package:parent_side/model/Entities/Activities.dart';
// import 'package:parent_side/model/Entities/Activity.dart';
// import 'package:parent_side/model/Entities/SchoolClass.dart';
// import 'package:parent_side/model/Entities/Teacher.dart';
// import '../../model/globals.dart' as global;

// class ActivityDetail extends StatefulWidget {
//   final Teacher teacher;
//   SchoolClass myClass;
//   Activities activity;
//   final type;
//   ActivityDetail(this.teacher, this.myClass, this.activity, this.type);
//   @override
//   State<StatefulWidget> createState() {
//     return ActivityDetailState(
//         this.teacher, this.myClass, this.activity, this.type);
//   }
// }

// class ActivityDetailState extends State<ActivityDetail> {
//   final webApi = ApiService();
//   Activities activity;
//   SchoolClass myClass;
//   DateTime _birthDate = DateTime.now();
//   final Teacher teacher;
//   final type;
//   final _formKey = GlobalKey<FormState>();

//   var text = "";
//   File _image;

//   final apiUrl = "http://18.230.116.206/api/v1/";

//   ActivityDetailState(this.teacher, this.myClass, this.activity, this.type);
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

//     return new MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: new Scaffold(
//             appBar: AppBar(
//               leading: IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pushAndRemoveUntil(
//                       new MaterialPageRoute(
//                           builder: (context) => new AdministratorFeed(
//                               this.teacher, this.myClass)),
//                       (Route<dynamic> route) => false);
//                 },
//                 icon: Icon(Icons.arrow_back),
//               ),
//               backgroundColor: global.TopColor,
//               title: Text(
//                 "Editar atividade",
//                 style: new TextStyle(fontSize: 18.0, color: Colors.white),
//               ),
//               shape: RoundedRectangleBorder(
//                   borderRadius:
//                       BorderRadius.vertical(bottom: Radius.circular(20))),
//             ),
//             body: new GestureDetector(
//                 onTap: () {
//                   FocusScope.of(context).requestFocus(new FocusNode());
//                 },
//                 child: SizedBox(
//                     height: (height - keyboardHeight) - (height * 0.1),
//                     child: SingleChildScrollView(
//                         child: Column(children: <Widget>[
//                       new Column(children: <Widget>[
//                         new Container(
//                             padding: new EdgeInsets.fromLTRB(20, 0, 20, 0),
//                             height: height *
//                                 (this.activity.images != null ||
//                                         this._image != null
//                                     ? 0.655
//                                     : 0.59),
//                             width: double.maxFinite,
//                             child: new Stack(
//                               children: [
//                                 Positioned(
//                                     top: height *
//                                         (this.activity.images != null ||
//                                                 this._image != null
//                                             ? 0.56
//                                             : 0.46),
//                                     child: Stack(
//                                       children: [
//                                         Container(
//                                             // padding: new EdgeInsets.fromLTRB(
//                                             //       5, 0, 0, 0),
//                                             //   alignment: Alignment.center,
//                                             width: width * 0.88,
//                                             padding: new EdgeInsets.fromLTRB(
//                                                 8, 0, 0, 0),
//                                             child: new Image.asset(
//                                               "assets/BotaoAprovar.png",
//                                               scale: 0.95,
//                                             )),
//                                         Container(
//                                             padding: new EdgeInsets.fromLTRB(
//                                                 0, 0, 120, 0),
//                                             height: height * 0.1,
//                                             width: width + 80,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 SizedBox(
//                                                   height: height * 0.1,
//                                                   width: width / 2.5,
//                                                   child: TextButton(
//                                                       onPressed: () {
//                                                         _formKey.currentState
//                                                             .save();
//                                                         Activity myActivity = Activity(
//                                                             id: this
//                                                                 .activity
//                                                                 .id,
//                                                             date: this
//                                                                 .activity
//                                                                 .created_at
//                                                                 .toDate()
//                                                                 .toString()
//                                                                 .substring(
//                                                                     0, 11),
//                                                             description:
//                                                                 this.text == this.activity.note
//                                                                     ? this
//                                                                         .activity
//                                                                         .note
//                                                                     : this.text,
//                                                             type: this
//                                                                 .activity
//                                                                 .activity,
//                                                             message: this.type == 3 && this.text != this.activity.note
//                                                                 ? this.text
//                                                                 : this
//                                                                     .activity
//                                                                     .note,
//                                                             name: this
//                                                                 .activity
//                                                                 .activity,
//                                                             haveImage: this
//                                                                     .activity
//                                                                     .images !=
//                                                                 null,
//                                                             schoolClass:
//                                                                 this.activity.class_id,
//                                                             isApproved: true,
//                                                             time: this.activity.created_at.toDate().toString().substring(11, 15));
//                                                         this
//                                                             .webApi
//                                                             .updateActivity(
//                                                                 myActivity);

//                                                         Navigator.push(
//                                                             context,
//                                                             new MaterialPageRoute(
//                                                                 builder: (context) =>
//                                                                     new AdministratorFeed(
//                                                                         this.teacher,
//                                                                         this.myClass)));
//                                                       },
//                                                       child: Text("")),
//                                                 ),
//                                                 SizedBox(
//                                                   height: height * 0.1,
//                                                   width: width / 2.5,
//                                                   child: TextButton(
//                                                       onPressed: () async {
//                                                         //DELETAR A ATIVIDADE - activity detail
//                                                         final activityid =
//                                                             this.activity.id;
//                                                         final responsePivot =
//                                                             await this
//                                                                 .webApi
//                                                                 .deleteActivityPivot(
//                                                                     activityid);
//                                                         if (responsePivot
//                                                                 .statusCode ==
//                                                             204) {
//                                                           // final responseActivity =
//                                                           await this
//                                                               .webApi
//                                                               .deleteActivity(
//                                                                   activityid);
//                                                         }

//                                                         Navigator.push(
//                                                             context,
//                                                             new MaterialPageRoute(
//                                                                 builder: (context) =>
//                                                                     new AdministratorFeed(
//                                                                         this.teacher,
//                                                                         this.myClass)));
//                                                       },
//                                                       child: Text("")),
//                                                 ),
//                                               ],
//                                             )),
//                                       ],
//                                     )),
//                                 Form(
//                                   key: _formKey,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Container(
//                                           height: height *
//                                               (this.activity.images != null ||
//                                                       this._image != null
//                                                   ? 0.55
//                                                   : 0.43),
//                                           child: Card(
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(17.0),
//                                             ),
//                                             color: this.type == 1
//                                                 ? global.BathroomColor
//                                                 : this.type == 2
//                                                     ? global.SleepColor
//                                                     : this.type == 3
//                                                         ? global.FoodColor
//                                                         : global.MomentColor,
//                                             child: new Stack(children: [
//                                               Positioned(
//                                                 top: height * 0.01,
//                                                 left: width * 0.06,
//                                                 height: height * 0.05,
//                                                 width: width,
//                                                 child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     children: this.type == 1
//                                                         ? <Widget>[
//                                                             //Imagem do Título
//                                                             Image.asset(
//                                                                 'assets/icone_banheiro@2x.png',
//                                                                 scale: 1.5),
//                                                             new Container(
//                                                               width:
//                                                                   width * 0.025,
//                                                             ),
//                                                             Text(
//                                                               "Banheiro",
//                                                               style: new TextStyle(
//                                                                   fontSize:
//                                                                       16.0,
//                                                                   color: Colors
//                                                                       .white),
//                                                             ),
//                                                           ]
//                                                         : this.type == 2
//                                                             ? <Widget>[
//                                                                 //Imagem do Título
//                                                                 Image.asset(
//                                                                     'assets/sleep@2x.png',
//                                                                     scale: 1.2),
//                                                                 new Container(
//                                                                   width: width *
//                                                                       0.025,
//                                                                 ),
//                                                                 Text(
//                                                                   "Soneca",
//                                                                   style: new TextStyle(
//                                                                       fontSize:
//                                                                           16.0,
//                                                                       color: Colors
//                                                                           .white),
//                                                                 ),
//                                                               ]
//                                                             : this.type == 3
//                                                                 ? <Widget>[
//                                                                     //Imagem do Título
//                                                                     Image.asset(
//                                                                         'assets/Icone_alimentação_pag@2x.png',
//                                                                         scale:
//                                                                             1.2),
//                                                                     new Container(
//                                                                       width: width *
//                                                                           0.025,
//                                                                     ),
//                                                                     Text(
//                                                                       "Alimentação",
//                                                                       style: new TextStyle(
//                                                                           fontSize:
//                                                                               16.0,
//                                                                           color:
//                                                                               Colors.white),
//                                                                     )
//                                                                   ]
//                                                                 : <Widget>[
//                                                                     //Imagem do Título
//                                                                     Image.asset(
//                                                                         'assets/icone_momento@2x.png',
//                                                                         scale:
//                                                                             1.2),
//                                                                     new Container(
//                                                                       width: width *
//                                                                           0.025,
//                                                                     ),
//                                                                     Text(
//                                                                       "Momentos",
//                                                                       style: new TextStyle(
//                                                                           fontSize:
//                                                                               16.0,
//                                                                           color:
//                                                                               Colors.white),
//                                                                     )
//                                                                   ]),
//                                               ),
//                                               this.activity.images != null ||
//                                                       this._image != null
//                                                   ? Positioned(
//                                                       top: height * 0.4,
//                                                       left: width * 0.07,
//                                                       height: height * 0.11,
//                                                       width: width -
//                                                           (width * 0.75),
//                                                       child: this._image == null
//                                                           ? ClipRRect(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           7.0),
//                                                               child:
//                                                                   CachedNetworkImage(
//                                                                       imageUrl:
//                                                                           "${this.apiUrl}images/${this.activity.id}",
//                                                                       progressIndicatorBuilder: (context,
//                                                                               url,
//                                                                               downloadProgress) =>
//                                                                           Center(
//                                                                             child:
//                                                                                 CircularProgressIndicator(
//                                                                               valueColor: new AlwaysStoppedAnimation<Color>(global.TopColor),
//                                                                               value: downloadProgress.progress,
//                                                                               strokeWidth: 4,
//                                                                             ),
//                                                                           ),
//                                                                       errorWidget: (context,
//                                                                               url,
//                                                                               error) =>
//                                                                           Text(
//                                                                               ""),
//                                                                       fit: BoxFit
//                                                                           .cover))
//                                                           : ClipRRect(
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           7.0),
//                                                               child: Image.file(
//                                                                 _image,
//                                                                 fit: BoxFit
//                                                                     .cover,
//                                                               )))
//                                                   : SizedBox(
//                                                       width: width,
//                                                       child: Text(""),
//                                                     ),
//                                               Positioned(
//                                                   top: height * 0.08,
//                                                   left: width * 0.055,
//                                                   height: height * 0.3,
//                                                   width: width - (width * 0.22),
//                                                   child: Card(
//                                                       shape:
//                                                           RoundedRectangleBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8.0),
//                                                       ),
//                                                       color: this.type == 1
//                                                           ? global
//                                                               .BathroomColor2
//                                                           : this.type == 2
//                                                               ? global
//                                                                   .SleepColor2
//                                                               : this.type == 3
//                                                                   ? global
//                                                                       .FoodColor2
//                                                                   : global
//                                                                       .MomentColor2,
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Container(
//                                                             padding:
//                                                                 new EdgeInsets
//                                                                         .fromLTRB(
//                                                                     10,
//                                                                     5,
//                                                                     0,
//                                                                     0),
//                                                             child: Row(
//                                                               mainAxisAlignment:
//                                                                   MainAxisAlignment
//                                                                       .spaceEvenly,
//                                                               children: <
//                                                                   Widget>[
//                                                                 //Imagem do Título
//                                                                 Image.asset(
//                                                                     'assets/note@2x.png',
//                                                                     scale: 1.7),
//                                                                 new Container(
//                                                                   width: width *
//                                                                       0.45,
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                           Expanded(
//                                                             flex: 1,
//                                                             child:
//                                                                 new SingleChildScrollView(
//                                                                     scrollDirection:
//                                                                         Axis
//                                                                             .vertical,
//                                                                     child:
//                                                                         Container(
//                                                                       padding: new EdgeInsets
//                                                                               .fromLTRB(
//                                                                           15,
//                                                                           20,
//                                                                           5,
//                                                                           10),
//                                                                       child:
//                                                                           TextFormField(
//                                                                         onSaved:
//                                                                             (String
//                                                                                 value) {
//                                                                           this.text =
//                                                                               value;
//                                                                         },
//                                                                         initialValue: this.type ==
//                                                                                 4
//                                                                             ? this.activity.note
//                                                                             : this.activity.note,
//                                                                         keyboardType:
//                                                                             TextInputType.multiline,
//                                                                         maxLines:
//                                                                             null,
//                                                                         decoration:
//                                                                             const InputDecoration(
//                                                                           border:
//                                                                               InputBorder.none,
//                                                                         ),
//                                                                         style: new TextStyle(
//                                                                             fontSize:
//                                                                                 14.0,
//                                                                             color:
//                                                                                 Colors.white,
//                                                                             fontWeight: FontWeight.bold),
//                                                                       ),
//                                                                     )),
//                                                           ),
//                                                         ],
//                                                       ))),
//                                             ]),
//                                           )),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ))
//                       ])
//                     ]))))));
//   }
// }
