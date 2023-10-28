import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/model/Entities/Guardian.dart';
import 'package:parent_side/model/Entities/MedicalRecord.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:uuid/uuid.dart';
import '../../model/Entities/ResponsibleModel.dart';
import '../../model/Entities/Students.dart';
import '../../model/globals.dart' as global;
import 'package:flutter/cupertino.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:image_picker/image_picker.dart';
import 'FormViewPickUp.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FormView extends StatefulWidget {
  final width;
  final height;
  final isNew;
  List<ResponsibleModel> guardians;
  var selectedStudent;
  Students currentStudent;
  MedicalRecord medicalRecord;
  FormView(this.height, this.width, this.currentStudent,
      {this.guardians = const [],
      this.selectedStudent = 0,
      this.isNew = false});

  ParentFormView createState() => ParentFormView(height, width, currentStudent,
      guardians: this.guardians,
      selectedStudent: this.selectedStudent,
      isNew: this.isNew);
}

class ParentFormView extends State<FormView> {
  final width;
  final height;
  final isNew;
  final webApi = ApiService();
  String _kidsName;
  String _parentName;
  var selectedStudent;
  String _relationship = "Pai";
  String _contato;
  File _parentImage;
  MedicalRecord medicalRecord;
  File _kidImage;
  String guardianImageUrl = "noImage";
  List<ResponsibleModel> guardians = [];
  DateTime _birthDate = DateTime.now();
  Students currentStudent;
  DefaultCacheManager manager = new DefaultCacheManager();
  ParentFormView(this.height, this.width, this.currentStudent,
      {this.medicalRecord,
      this.guardians,
      this.selectedStudent = 0,
      this.isNew = false}) {
    manager.emptyCache();
    teste();
    if (this.guardians.isNotEmpty) {
      this._relationship = this.guardians.first.kinship;
      this.guardianImageUrl = this.guardians.first.id;
      if (this.currentStudent.birthday.toDate().toString().substring(0, 10) !=
          "00/00/0000") {
        DateTime tempDate = Intl.withLocale(
            'br',
            () => new DateFormat("yyyy-MM-dd").parse(this
                .currentStudent
                .birthday
                .toDate()
                .toString()
                .substring(0, 10)));
        _birthDate = tempDate;
      }
    }
  }
  final _formKey = GlobalKey<FormState>();

  bool studentChanged() {
    if (_kidsName != currentStudent.username) {
      return true;
    }
    return false;
  }

  Future<void> teste() async {
    String imageUrl =
        await webApi.getUserPhoto("student", this.currentStudent.id);
    setState(() {
      this.currentStudent.avatar = imageUrl;
    });
  }

  bool studentBirthday() {
    final birthdayString = _birthDate.toString().substring(0, 10);
    if (birthdayString !=
        currentStudent.birthday.toDate().toString().substring(0, 10)) {
      return true;
    }
    return false;
  }

  Future getImage(var typeImage) async {
    final picker = ImagePicker();
    final XFile image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        if (typeImage == "Kid") {
          _kidImage = File(image.path);
        } else {
          _parentImage = File(image.path);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Widget _buildInformation(var userType, var endText) {
    return Container(
      padding: EdgeInsets.fromLTRB(50, 15, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Nome Completo" + endText),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 40, 5),
              child: Container(
                  decoration: BoxDecoration(
                    color: global.FormColor,
                    borderRadius: new BorderRadius.circular(7.0),
                  ),
                  child: TextFormField(
                    initialValue: userType == "Parent"
                        ? this.guardians.isNotEmpty
                            ? "${this.guardians.first.name}"
                            : ""
                        : "${this.currentStudent.username}",
                    decoration: InputDecoration(
                        border: InputBorder.none, prefixText: "  "),
                    validator: (value) => value.isEmpty || value == null
                        ? "Nome não pode ser vazio"
                        : null,
                    onSaved: (String value) {
                      if (userType == "Parent") {
                        _parentName = value;
                      } else {
                        _kidsName = value;
                      }
                    },
                  ))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          backgroundColor: global.TopColor,
          title: new Text("Informação do aluno(a)"),
          actions: <Widget>[
            new TextButton(
                onPressed: () async {
                  if (_kidImage != null) {
                    this.currentStudent.avatar = await webApi.updateUserPhoto(
                        "students",
                        currentStudent.id,
                        this.currentStudent.id,
                        _kidImage);
                  }
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    if (this.studentChanged()) {
                      this.currentStudent.username = this._kidsName;
                      this.currentStudent.birthday =
                          Timestamp.fromDate(this._birthDate);
                      print("UPDATE STUDENT:  ${this.currentStudent}");
                      webApi.updateStudents(this.currentStudent);

                      //TODO: UPDATE  STUDENT
                      //  this.currentStudent =

                    }

                    if (this.guardians.isNotEmpty) {
                      if (_parentImage != null) {
                        this.guardians.first.avatar =
                            await webApi.updateUserPhoto(
                                "parent",
                                currentStudent.id,
                                this.currentStudent.id,
                                _parentImage);
                      }
                      if (this._parentName != this.guardians.first.name ||
                          this._contato != this.guardians.first.phone ||
                          this._relationship != this.guardians.first.kinship &&
                              this._relationship != "" &&
                              this.guardians.isNotEmpty) {
                        this.guardians.first.name = this._parentName;
                        this.guardians.first.phone = this._contato;
                        this.guardians.first.kinship = this._relationship;
                        //UPDATE GUARDIAN
                        webApi.updateResponsible(
                            this.currentStudent.id, this.guardians.first);
                      }
                    } else {
                      print("post novo papai");

                      var newGuardian = ResponsibleModel(
                          id: Uuid().v4(),
                          name: this._parentName,
                          phone: this._contato,
                          kinship: this._relationship,
                          cpf: "00000",
                          avatar: "");

                      if (_parentImage != null) {
                        newGuardian.avatar = await webApi.updateUserPhoto(
                            "parent",
                            currentStudent.id,
                            newGuardian.id,
                            _parentImage);
                      }

                      //post new guardian
                      newGuardian = newGuardian;
                      webApi.postResponsible(
                          this.currentStudent.id, newGuardian);
                      this.guardians.add(newGuardian);
                    }

                    // if (_parentImage != null && this.guardians.isNotEmpty) {
                    //   webApi.updateUserPhoto(
                    //       'responsibles',
                    //       this.guardians.first.id,
                    //       currentStudent.id,
                    //       _parentImage);
                    // }
                    // if (_kidImage != null) {
                    //   webApi.updateUserPhoto('student', this.currentStudent.id,
                    //       currentStudent.id, _kidImage);
                    // }

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FormViewPickUp(
                                height,
                                width,
                                guardians,
                                this.currentStudent,
                                this.medicalRecord,
                                this.selectedStudent,
                                isNew: this.isNew)));
                  }
                },
                child:
                    new Text("Próximo", style: TextStyle(color: Colors.black)))
          ],
        ),
        body: new GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SizedBox(
                height: (screenHeight - keyboardHeight) - (height * 0.15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      new Container(
                        height: height * 0.02,
                      ),
                      Center(
                        child: Text(
                          "Para a melhor comunicação acontecer precisamos dos \ndados importantes sobre o estudante e responsáveis",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black.withOpacity(0.5),
                            fontSize: 13.0,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              height: height * 0.01,
                            ),
                            FlatButton(
                              onPressed: () {
                                getImage("Kid");
                              },
                              child: _kidImage == null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: Image.network(
                                        this.currentStudent.avatar,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(global.TopColor),
                                              strokeWidth: 4,
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                    'assets/EditPhoto@2x.png',
                                                    height: height * 0.16,
                                                    width: width * 0.4,
                                                    fit: BoxFit.cover),
                                        height: height * 0.16,
                                        width: width * 0.4,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: Image.file(
                                        _kidImage,
                                        height: height * 0.18,
                                        width: width * 0.4,
                                        fit: BoxFit.cover,
                                      )),
                            ),
                            _buildInformation("Kid", " do aluno(a)"),
                            Padding(
                              padding: EdgeInsets.fromLTRB(50, 0, 40, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Data de aniversário"),
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 5, 100, 15),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: global.FormColor,
                                            borderRadius:
                                                new BorderRadius.circular(7.0),
                                          ),
                                          child: MaterialButton(
                                            elevation: 0,
                                            child: Text(
                                                "${_birthDate.day}/${_birthDate.month}/${_birthDate.year}"),
                                            color: global.FormColor,
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .copyWith()
                                                                .size
                                                                .height /
                                                            3,
                                                        child:
                                                            CupertinoDatePicker(
                                                          initialDateTime:
                                                              _birthDate,
                                                          onDateTimeChanged:
                                                              (DateTime
                                                                  newdate) {
                                                            setState(() {
                                                              _birthDate =
                                                                  newdate;
                                                            });
                                                          },
                                                          use24hFormat: true,
                                                          maximumDate:
                                                              new DateTime
                                                                  .now(),
                                                          minimumYear: 1980,
                                                          minuteInterval: 1,
                                                          mode:
                                                              CupertinoDatePickerMode
                                                                  .date,
                                                        ));
                                                  });
                                            },
                                          ))),
                                  Stack(
                                    children: [
                                      Text(
                                        "Responsável",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                      Divider(
                                          color: Colors.black.withOpacity(0.4)),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            FlatButton(
                                onPressed: () {
                                  getImage("Parent");
                                },
                                child: _parentImage == null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        child: Image.network(
                                          //kid
                                          this.guardians.isNotEmpty
                                              ? this.guardians.first.avatar
                                              : "",
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(global.TopColor),
                                                strokeWidth: 4,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Image.asset(
                                                      'assets/EditPhoto@2x.png',
                                                      height: height * 0.16,
                                                      width: width * 0.4,
                                                      fit: BoxFit.cover),
                                          height: height * 0.16,
                                          width: width * 0.4,
                                          fit: BoxFit.cover,
                                        ))
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                        child: Image.file(
                                          _parentImage,
                                          height: height * 0.18,
                                          width: width * 0.4,
                                          fit: BoxFit.cover,
                                        ))),
                            _buildInformation("Parent", ""),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                new Container(
                                  width: width * 0.12,
                                ),
                                Text("Parentesco"),
                                new Container(
                                  width: width * 0.17,
                                ),
                                Text("Contato"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: width * 0.24,
                                  decoration: BoxDecoration(
                                    color: global.FormColor,
                                    borderRadius:
                                        new BorderRadius.circular(7.0),
                                  ),
                                  child: MaterialButton(
                                    child: Text(_relationship),
                                    color: global.FormColor,
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Container(
                                                child: CupertinoPicker(
                                              backgroundColor: Colors.white,
                                              itemExtent: 35,
                                              scrollController:
                                                  FixedExtentScrollController(
                                                      initialItem: 1),
                                              children: [
                                                Text("Selecionar"),
                                                Text("Pai"),
                                                Text("Mãe"),
                                                Text("Avô"),
                                                Text("Avó"),
                                                Text("Tio/Tia"),
                                                Text("Outro"),
                                              ],
                                              onSelectedItemChanged: (value) {
                                                setState(() {
                                                  switch (value) {
                                                    case 1:
                                                      _relationship = "Pai";
                                                      break;
                                                    case 2:
                                                      _relationship = "Mãe";
                                                      break;
                                                    case 3:
                                                      _relationship = "Avô";
                                                      break;
                                                    case 4:
                                                      _relationship = "Avó";
                                                      break;
                                                    case 5:
                                                      _relationship = "Tio/Tia";
                                                      break;
                                                    case 6:
                                                      _relationship = "Outro";
                                                      break;
                                                    default:
                                                      _relationship = "Pai";
                                                  }
                                                });
                                              },
                                            ));
                                          });
                                    },
                                  ),
                                ),
                                SizedBox(
                                    width: width * 0.42,
                                    height: height * 0.055,
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: global.FormColor,
                                          borderRadius:
                                              new BorderRadius.circular(7.0),
                                        ),
                                        child: TextFormField(
                                          inputFormatters: [
                                            MaskedInputFormatter(
                                                '(##)# ####-####'),
                                          ],
                                          keyboardType: TextInputType.phone,
                                          initialValue:
                                              this.guardians.isNotEmpty
                                                  ? this.guardians.first.phone
                                                  : "",
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: this
                                                      .guardians
                                                      .isNotEmpty
                                                  ? this.guardians.first.phone
                                                  : "",
                                              prefixText: " "),
                                          validator: (value) => value.isEmpty
                                              ? "Contato não pode ser vazio"
                                              : null,
                                          onSaved: (String value) {
                                            _contato = value;
                                          },
                                        ))),
                              ],
                            ),
                            new Container(
                              height: height * 0.08,
                            ),
                            // SizedBox(
                            //   width: width * 0.16,
                            //   height: height * 0.06,
                            //   child: Image.asset('assets/buletFistPage@2x.png'),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ))));
  }

  int getKinship(String kinship) {
    switch (kinship) {
      case "Pai":
        return 1;
      case "Mãe":
        return 2;
        break;
      case "Avô":
        return 3;
      case "Avó":
        return 4;
      case "Tio/Tia":
        return 5;
      case "Outro":
        return 6;
      default:
        return 0;
    }
  }
}

//showModalBottomSheet
