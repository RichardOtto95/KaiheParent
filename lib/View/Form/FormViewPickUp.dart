import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/model/Entities/MedicalRecord.dart';
import 'package:uuid/uuid.dart';

import '../../model/Entities/ResponsibleModel.dart';
import '../../model/Entities/Students.dart';
import '../../model/globals.dart' as global;
import 'FormViewhealth.dart';

class FormViewPickUp extends StatefulWidget {
  final width;
  final height;
  Students currentStudent;
  var selectedStudent;
  final isNew;
  MedicalRecord medicalRecord;
  List<ResponsibleModel> guardians;

  FormViewPickUp(this.height, this.width, this.guardians, this.currentStudent,
      this.medicalRecord, this.selectedStudent,
      {this.isNew = false});

  FormViewPickUpWidget createState() => FormViewPickUpWidget(
      height, width, guardians, currentStudent, this.medicalRecord,
      isNew: this.isNew, selectedStudent: this.selectedStudent);
}

class FormViewPickUpWidget extends State<FormViewPickUp> {
  final width;
  final height;
  // List<Guardian> guardians = [
  //   Guardian(
  //       id: "43242",
  //       name: "Luan Cabral",
  //       phoneNumber: "(61)666666",
  //       kinship: "Pai"),
  //   Guardian(
  //       id: "43242",
  //       name: "Dudu Dudutovisk",
  //       phoneNumber: "(61)666666",
  //       kinship: "Tio")
  // ];
  final webApi = ApiService();
  List<ResponsibleModel> guardians;
  MedicalRecord medicalRecord;
  var selectedStudent;
  var _name = [];
  var _relationship = [];
  var _contato = [];
  List<String> _document = [];
  var qtdContato = 0;
  var qtdContatoInitial = 1;
  var showButton = true;
  var addedGuardians = 0;
  final isNew;
  Students currentStudent;
  final _formKey = GlobalKey<FormState>();

  FormViewPickUpWidget(this.height, this.width, this.guardians,
      this.currentStudent, this.medicalRecord,
      {this.selectedStudent = 0, this.isNew = false}) {
    this.qtdContato = this.guardians.length;
    for (var i = 0; i < this.guardians.length; i++) {
      if (i >= this._name.length) {
        this._name.add(this.guardians[i].name);
        this._relationship.add(this.guardians[i].kinship);
        this._contato.add(this.guardians[i].phone);
        this._document.add(this.guardians[i].cpf);
      } else if (i < this._name.length) {
        this._name[i] = this.guardians[i].name;
        this._relationship[i] = this.guardians[i].kinship;
        this._contato[i] = this.guardians[i].phone;
      }
    }
    this.qtdContatoInitial = this.guardians.length;
  }
  showAlertDialog(BuildContext context, String responsibleName, int position) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop(true);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remover", style: TextStyle(color: global.MessageColor2)),
      onPressed: () {
        if (this.guardians.length > position) {
          webApi.deleteResponsbile(
              this.currentStudent.id, this.guardians[position].id);
          this.guardians.removeAt(position);
        }

        setState(() {
          this.addedGuardians -= 1;
          this.qtdContato -= 1;
          this._name.removeAt(position);
          this._relationship.removeAt(position);
          this._contato.removeAt(position);
          this._document.removeAt(position);
        });
        Navigator.of(context).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Atenção!"),
      content:
          Text("Deseja remover $responsibleName das pessoas autorizadas ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildPickUpSchool(var context, var responsiblePossition) {
    return Container(
      padding: EdgeInsets.fromLTRB(35, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Nome Completo"),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 30, 10),
              child: Container(
                  decoration: BoxDecoration(
                    color: global.FormColor,
                    borderRadius: new BorderRadius.circular(7.0),
                  ),
                  child: TextFormField(
                    key: Key(_name[responsiblePossition]),
                    initialValue: _name[responsiblePossition],
                    decoration: InputDecoration(
                        border: InputBorder.none, prefixText: "   "),
                    validator: (value) =>
                        value.isEmpty ? "Nome não pode ser vazio" : null,
                    onSaved: (String value) {
                      _name[responsiblePossition] = value;
                    },
                  ))),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Documento"),
              new Container(
                width: width * 0.26,
              ),
              Text("Contato"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: width * 0.39,
                  height: height * 0.055,
                  child: Container(
                      decoration: BoxDecoration(
                        color: global.FormColor,
                        borderRadius: new BorderRadius.circular(7.0),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          MaskedInputFormatter('###.###.###-##'),
                        ],
                        key: Key(_document[responsiblePossition]),
                        initialValue: this._document[
                            responsiblePossition], //Colocar Documento,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, prefixText: "   "),
                        validator: (value) => value.isEmpty
                            ? "documento não pode ser vazio"
                            : null,
                        onSaved: (String value) {
                          this._document[responsiblePossition] = value;
                          //_contato[responsiblePossition] = value;
                        },
                      ))),
              SizedBox(
                  width: width * 0.42,
                  height: height * 0.055,
                  child: Container(
                      decoration: BoxDecoration(
                        color: global.FormColor,
                        borderRadius: new BorderRadius.circular(7.0),
                      ),
                      child: TextFormField(
                        inputFormatters: [
                          MaskedInputFormatter('(##) #####-####'),
                        ],
                        key: Key(_contato[responsiblePossition]),
                        initialValue: _contato[responsiblePossition],
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            border: InputBorder.none, prefixText: "   "),
                        validator: (value) =>
                            value.isEmpty ? "Contato não pode ser vazio" : null,
                        onSaved: (String value) {
                          _contato[responsiblePossition] = value;
                        },
                      ))),
              new Container(
                height: height * 0.1,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Parentesco"),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.39,
                decoration: BoxDecoration(
                  color: global.FormColor,
                  borderRadius: new BorderRadius.circular(7.0),
                ),
                child: MaterialButton(
                  child: Text(_relationship[responsiblePossition]),
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
                                FixedExtentScrollController(initialItem: 0),
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
                                    _relationship[responsiblePossition] = "Pai";
                                    break;
                                  case 2:
                                    _relationship[responsiblePossition] = "Mãe";
                                    break;
                                  case 3:
                                    _relationship[responsiblePossition] = "Avô";
                                    break;
                                  case 4:
                                    _relationship[responsiblePossition] = "Avó";
                                    break;
                                  case 5:
                                    _relationship[responsiblePossition] =
                                        "Tio/Tia";
                                    break;
                                  case 6:
                                    _relationship[responsiblePossition] =
                                        "Outro";
                                    break;
                                  default:
                                    _relationship[responsiblePossition] = "Pai";
                                }
                              });
                            },
                          ));
                        });
                  },
                ),
              ),
              TextButton(
                  onPressed: () {
                    //Deletar o meliante
                    showAlertDialog(context, this._name[responsiblePossition],
                        responsiblePossition);
                  },
                  child: SizedBox(
                      width: width * 0.39,
                      height: height * 0.055,
                      child: Container(
                          decoration: BoxDecoration(
                            color: global.MessageColor2,
                            borderRadius: new BorderRadius.circular(7.0),
                          ),
                          child: Center(
                              child: Text("Remover",
                                  style: TextStyle(color: Colors.black))))))
            ],
          )
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
          title: new Text("Informação do aluno"),
          actions: <Widget>[
            new TextButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    if (qtdContatoInitial > 0) {
                      for (var i = qtdContatoInitial;
                          i < this._name.length;
                          i++) {
                        var newGuardian = ResponsibleModel(
                            id: "${Uuid().v4()}",
                            avatar: "",
                            cpf: this._document[i],
                            kinship: this._relationship[i],
                            name: this._name[i],
                            phone: this._contato[i]);
                        //Post newGuardian
                        webApi.postResponsible(
                            this.currentStudent.id, newGuardian);
                        // await this.webApi.postGuardian(newGuardian, this.currentStudent.id);
                        this.guardians.add(newGuardian);

                        this.qtdContatoInitial = this.guardians.length;
                      }
                    }
                    for (var i = 0; i < this.guardians.length; i++) {
                      if (i < this._name.length) {
                        if (this._name[i] != this.guardians[i].name ||
                            this._relationship[i] !=
                                this.guardians[i].kinship ||
                            this._contato[i] != this.guardians[i].phone ||
                            this._document[i] != this.guardians[i].cpf) {
                          final updateGuardian = ResponsibleModel(
                              id: this.guardians[i].id,
                              avatar: "",
                              cpf: this._document[i],
                              kinship: this._relationship[i],
                              name: this._name[i],
                              phone: this._contato[i]);

                          //Update guardian
                          webApi.updateResponsible(
                              this.currentStudent.id, updateGuardian);
                          this.guardians[i] = updateGuardian;
                          // await this.webApi.updateGuardian(updateGuardian);
                        }
                      }
                    }

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FormViewHealth(
                                  height,
                                  width,
                                  this.medicalRecord,
                                  this.currentStudent,
                                  selectedStudent: this.selectedStudent,
                                  isNew: this.isNew,
                                )));
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
                        "Dados importantes de controle da saída na escola",
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
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        "Quem é autorizado para retirar o aluno do ambiente escolar?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            new Container(
                              height: height * 0.01,
                            ),
                            new SizedBox(
                                height: height * 0.68,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: qtdContato,
                                  itemBuilder: (context, i) {
                                    return _buildPickUpSchool(context, i);
                                  },
                                )),
                          ],
                        )),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          this.addedGuardians += 1;
                          this.qtdContato += 1;
                          this._name.add("");
                          this._relationship.add("");
                          this._contato.add("");
                          this._document.add("");
                        });
                      },
                      child: showButton
                          ? Image.asset(
                              'assets/PlusButton@2x.png',
                              scale: 6,
                            )
                          : null,
                    ),
                    new Container(
                      height: height * 0.2,
                    )
                  ],
                )))));
  }
}
