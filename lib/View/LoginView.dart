import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/Students.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../model/globals.dart' as global;
import 'AddStudent.dart';

class LoginView extends StatefulWidget {
  LoginViewWidget createState() => LoginViewWidget();
}

class LoginViewWidget extends State<LoginView> {
  // var _user;
  // var _password;
  String _email = '';
  String _password = '';
  String messageError;
  bool loadCircular = false;

  Future<void> _saveLogin(var isLogin) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("isLogin", isLogin);
  }

  Future<String> createUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String _messageError;
    String emailFormatted = _email.trimRight().toLowerCase();
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: emailFormatted, password: _password);

      User _user = userCredential.user;

      if (_user != null) {
        await _user.sendEmailVerification();

        await FirebaseFirestore.instance
            .collection('parents')
            .doc(_user.uid)
            .set({
          'id': _user.uid,
          'username': emailFormatted,
          'created_at': FieldValue.serverTimestamp(),
          'connected': true,
          'country': 'Brasil',
          'notificationEnabled': true,
          'status': 'ACTIVE',
        });

        DocumentReference parentRef =
            FirebaseFirestore.instance.collection('parents').doc(_user.uid);

        String tokenString = await FirebaseMessaging.instance.getToken();

        await parentRef.update({
          'token_id': [tokenString]
        });

        _messageError = 'Um e-mail de veirificação foi enviado à você';

        //  _saveLogin("LogIn");
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //       builder: (context) => ChildFeed()
        //   ),
        //   (Route<dynamic> route) => false,
        // );
      }
    } on FirebaseAuthException catch (error) {
      print('ERROR');
      print(error.code);

      if (error.code == 'invalid-email') {
        _messageError = 'E-mail inválido!';
      }

      if (error.code == 'email-already-in-use') {
        _messageError = 'Esse e-mail já está em uso!';
      }

      if (error.code == 'operation-not-allowed') {
        _messageError = 'OPS... erro inesperado, contate o suporte.';
      }

      if (error.code == 'weak-password') {
        _messageError = 'Senha fraca!';
      }
    }

    return _messageError;
  }

  Future<void> logIn() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String _messageError;
    String emailFormatted = _email.trimRight().toLowerCase();
    setState(() {
      loadCircular = true;
    });

    QuerySnapshot teachersQuery = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: emailFormatted)
        .get();

    if (teachersQuery.docs.isNotEmpty) {
      _messageError = 'Sen permissão para acessar esse aplicativo';
    } else {
      bool filledAllFields = emailFormatted.isNotEmpty && _password.isNotEmpty;

      if (!filledAllFields) {
        _messageError = 'Todos os campos são obrigatórios';
      } else {
        try {
          UserCredential userCredential =
              await _auth.signInWithEmailAndPassword(
                  email: emailFormatted, password: _password);

          User _user = userCredential.user;

          DocumentSnapshot parentDoc = await FirebaseFirestore.instance
              .collection("parents")
              .doc(_user.uid)
              .get();

          String tokenString = await FirebaseMessaging.instance.getToken();

          await parentDoc.reference.update({
            'token_id': [tokenString]
          });

          if (!_user.emailVerified) {
            await _user.reload();
            try {
              await _user.sendEmailVerification();
              _messageError = 'Outro e-mail de verificação foi enviado à você';
            } catch (e) {
              print('error ${e.code}');
              _messageError = 'Valide o seu e-mail para entrar';
            }
          } else {
            _saveLogin("LogIn");
            _email = null;
            _password = null;

            Widget homeWidget;
            var studentsQuery = await FirebaseFirestore.instance
                .collection('parents')
                .doc(_user.uid)
                .collection('students')
                .orderBy('created_at', descending: true)
                .get();

            if (studentsQuery.docs.isNotEmpty) {
              homeWidget = ChildFeed(studentId: studentsQuery.docs.first.id);
            } else {
              homeWidget = AddStudentView(
                firstStudent: true,
              );
            }

            await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => homeWidget),
              (Route<dynamic> route) => false,
            );
          }
        } on FirebaseAuthException catch (error) {
          print('ERROR');
          print(error.code);

          if (error.code == 'invalid-email') {
            _messageError = 'E-mail inválido!';
          }

          if (error.code == 'user-not-found') {
            // _messageError = 'Não há usuário com este e-mail!';
            _messageError = await createUser();
          }

          if (error.code == 'user-disabled') {
            _messageError = 'Esse usuário foi desativado!';
          }

          if (error.code == 'wrong-password') {
            _messageError = 'Senha incorreta!';
          }
        }
      }
    }

    messageError = _messageError;
    setState(() {
      loadCircular = false;
    });
  }

  // Future<void> _getLogin(var isLogin) async {
  //   final prefs = await SharedPreferences.getInstance();

  //   prefs.getString("isLogin");
  // }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return new Scaffold(
        body: new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: SizedBox(
          height: (screenHeight - keyboardHeight),
          child: SingleChildScrollView(
              child: Column(children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, screenHeight, 0, 0),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/LoginPage@2x.png'),
                          fit: BoxFit.fitWidth,
                          scale: 5)),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.16,
                          screenHeight * 0.43, screenWidth * 0.16, 0),
                      child: Text(
                        "A sua agenda escolar em um só lugar",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 13.0,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.16,
                          screenHeight * 0.03, screenWidth * 0.16, 0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: global.LoginColor,
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: "Matrícula",
                              hintText: "E-mail",
                              prefixText: "   ",
                            ),
                            validator: (String value) {
                              return null;
                            },
                            onChanged: (String value) {
                              // _user = value;
                              _email = value;
                            },
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.16,
                          screenHeight * 0.015, screenWidth * 0.16, 0),
                      child: Container(
                          decoration: BoxDecoration(
                            color: global.LoginColor,
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: "Código da sala",
                              hintText: "Senha",
                              prefixText: "   ",
                            ),
                            onChanged: (String value) {
                              _password = value;
                            },
                          )),
                    ),
                    new Container(
                      height: screenHeight * 0.03,
                    ),
                    messageError == null
                        ? Container()
                        : Container(
                            // height: 20,
                            child: Text(
                              messageError,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 13.0,
                              ),
                            ),
                          ),
                    loadCircular
                        ? Center(child: CircularProgressIndicator())
                        : Container(
                            decoration: BoxDecoration(
                              color: global.LoginColor,
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.05,
                            child: MaterialButton(
                              child: Text("Entrar"),
                              onPressed: () async {
                                await logIn();
                                //Se tiver certo
                                //Trim utilizado para tirar espaços da string
                                // if (_user.trim() == "dudu" &&
                                //     _password.trim() == "HiLorena") {
                                //   _saveLogin("LogIn");
                                //   Navigator.of(context).pushAndRemoveUntil(
                                //       MaterialPageRoute(
                                //           builder: (context) => ChildFeed()),
                                //       (Route<dynamic> route) => false);
                                // }
                              },
                            ))
                  ],
                ),
              ],
            )
          ]))),
    ));
  }
}
