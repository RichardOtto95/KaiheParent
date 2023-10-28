import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:parent_side/Service/ApiService.dart';
import 'package:parent_side/model/Entities/Activity.dart';
import 'package:parent_side/model/Entities/Guardian.dart';
import 'package:parent_side/model/Entities/ResponsibleModel.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/Students.dart';
import '../../model/globals.dart' as global;

class Message extends StatefulWidget {
  final Students student;
  final String schoolClassID;
  List<ResponsibleModel> studentGuardians = [];

  Message(this.student, this.studentGuardians, this.schoolClassID);

  @override
  State<StatefulWidget> createState() {
    return MessageState(
        this.student, this.studentGuardians, this.schoolClassID);
  }
}

class MessageState extends State<Message> with TickerProviderStateMixin {
  final webApi = ApiService();
  final apiUrl = "http://18.230.116.206/api/v1/";
  Students student;
  List<ResponsibleModel> studentGuardians = [];
  bool _selected = false;
  final String schoolClassID;
  bool isSent = false;
  var guardian = ResponsibleModel();
  var _message = "";
  final _formKey = GlobalKey<FormState>();
  var validate = false;

  var openAnimation = false;
  var isComplete = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  MessageState(this.student, this.studentGuardians, this.schoolClassID);

  Future<bool> sendMessage() async {
    print("entrei");
    isSent = false;
    var now = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String formattedTime = DateFormat('HH:mm').format(now);
    String formattedDate = formatter.format(now);
    Activity messageActivity = Activity(
        time: formattedTime,
        date: formattedDate,
        description:
            "${this.student.username}:${this.guardian.name}:${this.guardian.kinship}",
        type: "9",
        name: "Recado dos Pais",
        message: this._message,
        haveImage: false,
        isApproved: true,
        schoolClass: this.schoolClassID,
        needAuth: false,
        activityDate: null);
    try {
      final activitySent = await this.webApi.postActivity(messageActivity);
      await this.webApi.postPivotActivity(activitySent, this.student);
      // this.student.hasMsg = true;
      await this.webApi.updateStudent(this.student);
      setState(() {
        this.isComplete = true;
      });
    } on Exception catch (_) {
      setState(() {
        this.isComplete = false;
      });

      print("Deu ruim");
    }

    return isSent;
  }

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
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                backgroundColor: global.TopColor,
                title: Text(
                  this.student.username,
                  style: new TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                actions: <Widget>[
                  TextButton(
                      onPressed: () async {
                        print("GUARDIAN: ${this.guardian.name}");
                        if (this._message.isNotEmpty &&
                            this.guardian.name != null) {
                          print("MSG: ${this._message}");
                          await this.sendMessage();
                          setState(() {
                            if (isSent) {
                              this.isComplete = true;
                            }
                            this.openAnimation = true;
                          });
                        } else {
                          setState(() {
                            this.validate = true;
                          });
                          print("TA SEM MENSAGEM OU SEM RESPONSAVEL");
                        }
                      },
                      child: Row(
                        children: [
                          Image.asset('assets/icon_enviar.png'),
                          Container(
                            width: width * 0.01,
                          ),
                          Text(
                            "Enviar",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))
                ]),
            body: new Stack(children: [
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: SizedBox(
                    height: (height - keyboardHeight) - (height * 0.1),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                            child: Column(children: [
                              Center(
                                  child: Column(children: [
                                Image.asset('assets/icon_mensagem.png'),
                                Container(
                                  height: height * 0.04,
                                ),
                                Text(
                                  "Está precisando se comunicar com a escola?",
                                  style: TextStyle(fontSize: 15),
                                ),
                                Container(
                                  height: height * 0.01,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(21, 0, 0, 0),
                                  child: Text(
                                      "Aqui você pode mandar rapidamente uma mensagem para a coordenação escolar.",
                                      style: TextStyle(fontSize: 15)),
                                )
                              ])),
                              Container(
                                height: height * 0.03,
                              ),
                              Container(
                                  height: height * 0.6,
                                  width: width * 0.83,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: global.TopColor,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                                    child: Column(children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          //Imagem do Título
                                          Image.asset('assets/MessageIcon.png',
                                              scale: 1),
                                          new Container(
                                            width: width * 0.05,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                0, 13, 0, 0),
                                            child: Text(
                                              "Comunicado",
                                              style: new TextStyle(
                                                  fontSize: 20.0,
                                                  color: global.TopColor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: height * 0.03,
                                              ),
                                              Text(
                                                "De:",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 17),
                                              ),
                                              Container(
                                                height: height * 0.01,
                                              ),
                                              Container(
                                                height: height * 0.05,
                                                width: width,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: global.TopColor,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: new Center(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 10, 0),
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child: DropdownButton<
                                                              ResponsibleModel>(
                                                            underline: null,
                                                            isExpanded: true,
                                                            hint: Text(
                                                                'Escolha o responsável'),
                                                            icon: Image.asset(
                                                                "assets/ArrowDown.png"),
                                                            items: studentGuardians
                                                                .map(
                                                                    (ResponsibleModel
                                                                        value) {
                                                              return new DropdownMenuItem<
                                                                  ResponsibleModel>(
                                                                value: value,
                                                                child: new Text(
                                                                    "${value.name} - ${value.kinship}"),
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (ResponsibleModel
                                                                    newValue) {
                                                              _dropDownItemSelected(
                                                                  newValue);
                                                            },
                                                            value: _selected
                                                                ? this.guardian
                                                                : null,
                                                            isDense: true,
                                                          ),
                                                        ))),
                                              ),
                                              Container(
                                                height: height * 0.02,
                                              ),
                                              Container(
                                                  height: height * 0.3,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: 1,
                                                      color: global.TopColor,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: new TextFormField(
                                                    validator: (value) => value
                                                            .isEmpty
                                                        ? "Mensagem não pode ser vazia"
                                                        : null,
                                                    maxLength: 250,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: null,
                                                    decoration: InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        prefixText: "   ",
                                                        hintText:
                                                            "Descreva o comunicado aqui"),
                                                    onChanged: (String value) {
                                                      _message = value;
                                                    },
                                                  )),
                                              Container(
                                                height: height * 0.02,
                                              ),
                                              Text(
                                                this.validate
                                                    ? "Messagem e/ou Responsáveis não podem ser vazios."
                                                    : "",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ]),
                                      )
                                    ]),
                                  )))
                            ])))),
              ),
              openAnimation
                  ? AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        width: width,
                        height: height,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    )
                  : Text(""),
              Center(
                child: this.openAnimation == true
                    ? Column(
                        children: [
                          new Container(
                            height: height * 0.3,
                          ),
                          Lottie.network(
                              this.isComplete
                                  ? 'https://assets4.lottiefiles.com/packages/lf20_gpjc1bmr.json'
                                  : 'https://assets1.lottiefiles.com/private_files/lf30_chkimb7d.json',
                              width: 200,
                              height: 200,
                              fit: BoxFit.fill,
                              controller: _controller, onLoaded: (composition) {
                            _controller
                              ..duration = composition.duration
                              ..forward();
                            Future.delayed(const Duration(milliseconds: 2500),
                                () {
                              setState(() {
                                this.openAnimation = false;
                                Navigator.of(context).pop();
                              });
                            });
                          }),
                          Text(
                            this.isComplete
                                ? "Mensagem enviada com sucesso."
                                : "Falha ao enviar mensagem. Tente novamente",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Text(""),
              )
            ])));
  }

  void _dropDownItemSelected(ResponsibleModel valueSelectedByUser) {
    setState(() {
      this.guardian = valueSelectedByUser;
      _selected = true;
    });
  }
}
