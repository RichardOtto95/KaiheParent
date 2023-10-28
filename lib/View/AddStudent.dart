import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../model/globals.dart' as global;

class AddStudentView extends StatefulWidget {
  final bool firstStudent;

  const AddStudentView({Key key, this.firstStudent}) : super(key: key);
  AddStudentViewWidget createState() => AddStudentViewWidget();
}

class AddStudentViewWidget extends State<AddStudentView> {
  String _matr = '';
  String _code = '';
  String messageError;
  bool loadCircular = false;

  Future<void> addStudent() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User _user = _auth.currentUser;
    String _messageError;
    setState(() {
      messageError = null;
      loadCircular = true;
    });

    if (_matr.isEmpty || _code.isEmpty) {
      _messageError = 'Preencha todos os campo';
    } else {
      QuerySnapshot studentsQuery = await FirebaseFirestore.instance
          .collection('students')
          .where('register', isEqualTo: _matr)
          .get();

      if (studentsQuery.docs.isEmpty) {
        _messageError = 'Nenhum aluno encontrado';
      } else {
        DocumentSnapshot studentDoc = studentsQuery.docs.first;

        DocumentSnapshot parentDoc = await FirebaseFirestore.instance
            .collection('parents')
            .doc(_user.uid)
            .get();

        await parentDoc.reference
            .collection('students')
            .doc(studentDoc.id)
            .set({
          'id': studentDoc.id,
          'created_at': FieldValue.serverTimestamp(),
        });

        await studentDoc.reference.collection('parents').doc(parentDoc.id).set({
          'id': parentDoc.id,
          'created_at': FieldValue.serverTimestamp(),
        });

        if (widget.firstStudent) {
          studentsId = studentDoc.id;
          await Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => ChildFeed()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pop();
        }
      }
    }

    messageError = _messageError;
    setState(() {
      loadCircular = false;
    });
  }

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
                      scale: 5,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(screenWidth * 0.16,
                          screenHeight * 0.43, screenWidth * 0.16, 0),
                      child: Text(
                        "Adicione um estudante",
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
                              hintText: "Matrícula",
                              prefixText: "   ",
                            ),
                            validator: (String value) {
                              return null;
                            },
                            onChanged: (String value) {
                              _matr = value;
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
                              hintText: "Código da sala",
                              prefixText: "   ",
                            ),
                            onChanged: (String value) {
                              _code = value;
                            },
                          )),
                    ),
                    new Container(
                      height: screenHeight * 0.03,
                    ),
                    messageError == null
                        ? Container()
                        : Container(
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
                              child: Text("Adicionar"),
                              onPressed: () async {
                                await addStudent();
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
