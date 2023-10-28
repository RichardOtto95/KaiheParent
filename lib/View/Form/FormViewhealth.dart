import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/model/Entities/MedicalRecord.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../model/Entities/Students.dart';
import '../../model/globals.dart' as global;
import 'package:flutter/cupertino.dart';
import 'dart:io';

class FormViewHealth extends StatefulWidget {
  final width;
  final height;
  final isNew;
  Students currentStudent;
  MedicalRecord medicalRecord;
  var selectedStudent;
  FormViewHealth(
      this.height, this.width, this.medicalRecord, this.currentStudent,
      {this.selectedStudent = 0, this.isNew = false});

  FormViewHealthWidget createState() => FormViewHealthWidget(
      height, width, this.medicalRecord, this.currentStudent,
      selectedStudent: this.selectedStudent, isNew: this.isNew);
}

class FormViewHealthWidget extends State<FormViewHealth> {
  final width;
  final height;
  var _allergys;
  var _medicines;
  var _bloodType = "";
  var _takeToHospital = "";
  var _hospitalName;
  String hospitalPermission = "Não";
  var havePrescription = false;
  final isNew;
  Students sutdentFill;

  Future<void> _saveOnboard() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("MadeOnboard", "YES");
  }

  Future<void> _saveLogin(var isLogin) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("isLogin", isLogin);
  }

  MedicalRecord medicalRecord;
  File _medicationPrescription;
  final webApi = ApiService();
  Students currentStudent;
  var selectedStudent;
  FormViewHealthWidget(
      this.height, this.width, this.medicalRecord, this.currentStudent,
      {this.selectedStudent = 0, this.isNew = false}) {
    this._hospitalName = this.currentStudent.hospital;
    this._allergys = this.currentStudent.allergy;
    this._medicines = this.currentStudent.prescription_drug;
    this._bloodType = this.currentStudent.blood_type;
    this._takeToHospital = this.currentStudent.authorized_take_hospital;
    this.havePrescription = true;
  }

  Future getImage() async {
    final imageSelected =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (imageSelected != null) {
        _medicationPrescription = File(imageSelected.path);
        this.havePrescription = true;
      } else {
        print('No image selected.');
      }
    });
  }

  void fillStudent() {
    currentStudent.blood_type = this._bloodType;
    currentStudent.allergy = this._allergys;
    currentStudent.hospital = this._hospitalName;
    currentStudent.prescription_drug = this._medicines;
    currentStudent.authorized_take_hospital = this.hospitalPermission;
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
          title: new Text("Informação do Aluno"),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  this.fillStudent();
                  //updateStudent
                  webApi.updateStudents(this.currentStudent);
                  if (isNew) {
                    _saveLogin("LogIn");
                    _saveOnboard();
                  }

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ChildFeed(
                              selectedStudent: this.selectedStudent,
                              student: this.currentStudent,
                              isNew: this.isNew)),
                      (Route<dynamic> route) => false);
                },
                child: new Text("Finalizar",
                    style: TextStyle(color: Colors.black)))
          ],
        ),
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SizedBox(
              height: (screenHeight - keyboardHeight) - (height * 0.16),
              child: SingleChildScrollView(
                  child: Column(children: [
                new Container(
                  height: height * 0.02,
                ),
                Center(
                  child: Text(
                    "Informações fundamentais em caso de emergência ",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 13.0,
                    ),
                  ),
                ),
                new Container(
                  height: height * 0.02,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alergia",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      new Container(
                        height: height * 0.01,
                      ),
                      Text(
                          "Caso tenha alguma alergia, descreva abaixo detalhadamente",
                          style: TextStyle(fontSize: 12)),
                      new Container(
                        height: height * 0.015,
                      ),
                      SizedBox(
                          width: width * 0.85,
                          height: height * 0.13,
                          child: Container(
                              decoration: BoxDecoration(
                                color: global.FormColor,
                                borderRadius: new BorderRadius.circular(7.0),
                              ),
                              child: TextFormField(
                                initialValue: _allergys,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixText: "   "),
                                onChanged: (String value) {
                                  _allergys = value;
                                },
                              ))),
                    ],
                  ),
                ),
                new Container(
                  height: height * 0.03,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Remédio controlado",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      new Container(
                        height: height * 0.01,
                      ),
                      Text("Caso seja necessário, descreva abaixo",
                          style: TextStyle(fontSize: 12)),
                      new Container(
                        height: height * 0.015,
                      ),
                      SizedBox(
                          width: width * 0.85,
                          height: height * 0.13,
                          child: Container(
                              decoration: BoxDecoration(
                                color: global.FormColor,
                                borderRadius: new BorderRadius.circular(7.0),
                              ),
                              child: TextFormField(
                                initialValue: _medicines,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixText: "   "),
                                onChanged: (String value) {
                                  _medicines = value;
                                },
                              ))),
                      new Container(
                        height: height * 0.01,
                      ),
                      TextButton(
                        child: Text(
                            this.havePrescription == false
                                ? '' //Adicionar prescrição médica
                                : '', //Prescrição adicionada!
                            style: TextStyle(fontSize: 12)),
                        style: TextButton.styleFrom(
                          primary: Colors.black,
                          backgroundColor: global.FormColor,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                        onPressed: () {
                          // getImage();
                        },
                      )
                    ],
                  ),
                ),
                new Container(
                  height: height * 0.03,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        "Emergência",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(35, 10, 35, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.5,
                                child:
                                    Text("Qual é o tipo sanguíneo do aluno ?"),
                              ),
                              MaterialButton(
                                child: Text("$_bloodType"),
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
                                                  initialItem: 0),
                                          children: [
                                            Text("Selecionar"),
                                            Text("A+"),
                                            Text("A-"),
                                            Text("B+"),
                                            Text("B-"),
                                            Text("O+"),
                                            Text("O-"),
                                            Text("AB+"),
                                            Text("AB-"),
                                          ],
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              switch (value) {
                                                case 1:
                                                  _bloodType = "A+";
                                                  break;
                                                case 2:
                                                  _bloodType = "A-";
                                                  break;
                                                case 3:
                                                  _bloodType = "B+";
                                                  break;
                                                case 4:
                                                  _bloodType = "B-";
                                                  break;
                                                case 5:
                                                  _bloodType = "O+";
                                                  break;
                                                case 6:
                                                  _bloodType = "O-";
                                                  break;
                                                case 7:
                                                  _bloodType = "AB+";
                                                  break;
                                                case 8:
                                                  _bloodType = "AB-";
                                                  break;
                                                default:
                                              }
                                            });
                                          },
                                        ));
                                      });
                                },
                              ),
                            ],
                          ),
                          new Container(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                    "Em caso de emergência, é autorizado\npara ser levado ao hospital ?"),
                              ),
                              MaterialButton(
                                child: Text("$_takeToHospital"),
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
                                                  initialItem: 0),
                                          children: [
                                            Text("Selecionar"),
                                            Text("Sim"),
                                            Text("Não"),
                                          ],
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              switch (value) {
                                                case 1:
                                                  _takeToHospital = "Sim";
                                                  this.hospitalPermission =
                                                      _takeToHospital;
                                                  break;
                                                case 2:
                                                  _takeToHospital = "Não";
                                                  this.hospitalPermission =
                                                      _takeToHospital;
                                                  break;
                                                default:
                                              }
                                            });
                                          },
                                        ));
                                      });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    new Container(
                      height: height * 0.01,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(40, 10, 30, 0),
                        child: Text("Nome do Hospital")),
                    Column(
                      children: [
                        new Container(
                          height: height * 0.01,
                        ),
                        SizedBox(
                            width: width * 0.82,
                            height: height * 0.05,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: global.FormColor,
                                  borderRadius: new BorderRadius.circular(7.0),
                                ),
                                child: TextFormField(
                                  initialValue: this._hospitalName,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixText: "   "),
                                  onChanged: (String value) {
                                    _hospitalName = value;
                                  },
                                ))),
                        new Container(
                          height: height * 0.1,
                        ),
                      ],
                    )
                  ],
                )
              ]))),
        ));
  }
}
