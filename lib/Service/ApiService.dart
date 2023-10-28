import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parent_side/model/Entities/Activities.dart';
import 'package:parent_side/model/Entities/ResponsibleModel.dart';
import '../model/Entities/Students.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;
import 'package:parent_side/model/Entities/Activity.dart';
import 'package:parent_side/model/Entities/ClassTeacherPivot.dart';
import 'package:parent_side/model/Entities/Guardian.dart';
import 'package:parent_side/model/Entities/GuaridanPivot.dart';
import 'package:parent_side/model/Entities/MedicalRecord.dart';
import 'package:parent_side/model/Entities/SchoolClass.dart';
import 'package:parent_side/model/Entities/Student.dart';
import 'package:parent_side/model/Entities/StudentActivity.dart';
import 'package:parent_side/model/Entities/Teacher.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  // final urlApi = '18.230.116.206';
  final urlApi = '18.230.116.206';

  // Future<Activity1> fetchActivity() async {
  //   final response =
  //       await http.get(Uri.https('jsonplaceholder.typicode.com', 'todos/1'));
  //   if (response.statusCode == 200) {
  //     return Activity1.fromJson(jsonDecode(response.body));
  //   } else {
  //     throw Exception('Failed to load album');
  //   }
  // }

  Future callFunction(String function, Map<String, dynamic> params) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
    try {
      print('no try');
      return await callable.call(params);
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
      return false;
    } catch (e) {
      print('caught generic exception');
      print(e);
      return false;
    }
  }

  Future<List<Students>> getPupils(String _user, DateTime date) async {
    List<Students> students = [];
    List<String> studentsID = [];
    var studentFromFireBase = await FirebaseFirestore.instance
        .collection("parents")
        .doc(_user)
        .collection("students")
        .get();
    for (var student in studentFromFireBase.docs) {
      studentsID.add(student['id']);
    }

    for (var studentID in studentsID) {
      var student = await fetchStudent(studentID);
      students.add(student);
    }
    // await getActvityFromDate(studentsID.first, "lpy34Jkh5qZPImyqQp0L", date);
    return students;
  }

  Future<Students> fetchStudent(String studentID) async {
    var studentFromFireBase = await FirebaseFirestore.instance
        .collection("students")
        .doc(studentID)
        .get();
    return Students.fromJson(studentFromFireBase.data());
  }

  void getParent() {}

  Future<List<Activities>> fetchFoodActivity(String studentID) async {
    List<Activities> foods = [];
    var food = await FirebaseFirestore.instance
        .collection("students")
        .doc(studentID)
        .collection("bathroom")
        .get();
    for (var bath in food.docs) {
      var fetchedActivity = Activities.fromJson(bath.data());
      foods.add(fetchedActivity);
    }
    return foods;
  }

// DateTime date

  Future<List<Activities>> getActvityFromDate(
      String studentID, String classId, DateTime date) async {
    print("getData###############");

    QuerySnapshot<Map<String, dynamic>> query = await FirebaseFirestore.instance
        .collection("classes")
        .doc(classId)
        .collection("activities")
        .where("student_id", isEqualTo: studentID)
        .orderBy("created_at", descending: true)
        .get();

    print("query: ${query.docs.length}");

    List<Activities> activities = [];

    query.docs.forEach((activitie) {
      String activitieDate =
          activitie["created_at"].toDate().toString().substring(0, 11);
      if (activitieDate == date.toString().substring(0, 11)) {
        var act = Activities.fromJson(activitie.data());
        activities.add(act);
      }
    });
    print(activities);
    return activities;
  }

  Future<List<ResponsibleModel>> getStudentResponsibles(
      String studentId) async {
    var query = await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('responsibles')
        .get();
    List<ResponsibleModel> responsibles = [];
    query.docs.forEach((responsible) {
      var responsibleModel = ResponsibleModel.fromDocument(responsible);
      responsibles.add(responsibleModel);
    });
    print(responsibles);
    return responsibles;
  }

  void updateStudents(Students student) {
    var studentMap = student.toJson(student);
    var collection = FirebaseFirestore.instance.collection('students');
    collection.doc(student.id).update(studentMap);
  }

  void updateLastView(Students student) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(student.id)
        .update({"lastView": Timestamp.fromDate(DateTime.now())});
  }

  void deleteResponsbile(String studentID, String responsibleID) {
    FirebaseFirestore.instance
        .collection('students')
        .doc(studentID)
        .collection('responsibles')
        .doc(responsibleID)
        .delete();
  }

  void postResponsible(String studentId, ResponsibleModel responsible) {
    var responsibleMap = responsible.toJson(responsible);
    FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('responsibles')
        .doc(responsible.id)
        .set(responsibleMap);
  }

  void updateResponsible(String studentId, ResponsibleModel responsible) {
    var responsibleMap = responsible.toJson(responsible);
    var collection = FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .collection('responsibles')
        .doc(responsible.id);
    print(collection);
    collection..update(responsibleMap);
  }

  Future<String> getUserPhoto(String folder, String id) async {
    var instanceFB = FirebaseStorage.instance;
    try {
      var photo = await instanceFB.ref('${folder}/${id}').getDownloadURL();
      return photo;
    } on FirebaseException catch (erro) {
      print("error ${erro}");
    }
  }

  Future<String> updateUserPhoto(
      String folder, String id, String studentId, File image) async {
    File _imageFile = image;
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('${folder}/${id}/${_imageFile.path[0]}');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

//--------------------- ANTIGOOS
  Future<List<Activity>> fetchAllActivity() async {
    List<Activity> activities = [];
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/allActivity'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (var activity in responseJson) {
        var act = Activity(
            time: activity['time'],
            id: activity['id'],
            date: activity['date'],
            description: activity['description'],
            name: activity['name'],
            message: responseJson['message'],
            type: activity['type']);

        activities.add(act);
      }

      return activities;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<ClassTeacherPivot>> fetchTeacherClassPivot(
      String teacherID) async {
    List<ClassTeacherPivot> pivotActivity = [];
    final response = await http
        .get(Uri.http(this.urlApi, 'api/v1/pivot/teacher/$teacherID'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (var pivot in responseJson) {
        var newPivot = ClassTeacherPivot(
            id: pivot['id'],
            schoolClass_id: pivot['schoolClass_id'],
            teacher_id: pivot['teacher_id']);
        pivotActivity.add(newPivot);
      }
      return pivotActivity;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Student> fetchStudentByRegistration(String registration) async {
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/students/$registration'));

    if (response.statusCode == 200) {
      return Student.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<Student>> fetchStudentByClass(String classID) async {
    List<Student> studentsOfClass = [];
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/studentsClass/$classID'));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      for (var student in responseJson) {
        final newStudent = Student.fromJson(student);
        studentsOfClass.add(newStudent);
      }
      return studentsOfClass;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Activity> postActivity(Activity activity) async {
    final response = await http.post(Uri.http(this.urlApi, 'api/v1/activity'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'time': activity.time,
          'date': activity.date,
          'description': activity.description,
          'type': activity.type,
          'name': activity.name,
          'message': activity.message,
          'haveImage': activity.haveImage,
          'isApproved': activity.isApproved,
          'schoolClass': activity.schoolClass,
          'activityDate': activity.activityDate,
          'needAuth': activity.needAuth
        }));
    if (response.statusCode == 200) {
      final act = Activity.fromJson(jsonDecode(response.body));
      print("ATIVIDADE ENVIADA");
      return act;
    } else {
      print("ERRO AO ENVIAR ATIVIDADE ${response.statusCode}");
      throw Exception('Failed to load album');
    }
  }

  Future<bool> postPivotActivity(Activity activity, Students myStudent) async {
    final response =
        await http.post(Uri.http(this.urlApi, 'api/v1/pivot/classActivity'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'student_id': myStudent.id,
              'activity_id': activity.id,
              'isAuthorized': false,
              'willGo': false,
              'needSignature': false
            }));
    if (response.statusCode == 200) {
      print("Pivot enviado");
      return true;
    } else {
      print("ERRO AO ENVIAR ATIVIDADE ${response.statusCode}");
      throw Exception('Failed to load album');
    }
  }

  Future<List<Activity>> fetchActivityAdm(String classID, DateTime date) async {
    var format = NumberFormat("00", 'en_US');
    final day = format.format(date.day);
    final month = format.format(date.month);
    List<Activity> activities = [];
    final response = await http.get(Uri.http(
        this.urlApi, 'api/v1/activityAdm/$classID/$day/$month/${date.year}'));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      for (var pivot in responseJson) {
        final newActivity = Activity.fromJson(pivot);
        activities.add(newActivity);
      }
      return activities;
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<int> fetchActivityCount(String classID, DateTime date) async {
    return 3;
    // var format = NumberFormat("00", 'en_US');
    // final day = format.format(date.day);
    // final month = format.format(date.month);
    // final response = await http.get(Uri.http(
    //     this.urlApi, 'api/v1/activityCount/$classID/$day/$month/${date.year}'));

    // if (response.statusCode == 200) {
    //   final responseJson = json.decode(response.body);
    //   final count = responseJson as int;
    //   return count;
    // } else {
    //   throw Exception('Failed to activity count');
    // }
  }

  Future<SchoolClass> fetchClass(String classID) async {
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/class/$classID'));

    if (response.statusCode == 200) {
      return SchoolClass.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<Teacher> fetchTeacherByEmail(String email) async {
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/teacher/$email'));

    if (response.statusCode == 200) {
      return Teacher.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  Future<List<StudentActivity>> fetchActivityPivot(String studentID) async {
    List<StudentActivity> pivotActivity = [];
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/pivot/$studentID'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      for (var pivot in responseJson) {
        var newPivot = StudentActivity(
            id: pivot['id'],
            student_id: pivot['student_id'],
            activity_id: pivot['activity_id']);
        pivotActivity.add(newPivot);
      }
      return pivotActivity;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //FETCH DA AUTH
  Future<StudentActivity> fetchActivityPivotByStudent(
      String studentID, String activityID) async {
    final response = await http
        .get(Uri.http(this.urlApi, 'api/v1/pivot/$studentID/$activityID'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return StudentActivity.fromJson(responseJson);
    } else {
      print("TIRAR AQUIIIIIIIIIIII");
      //throw Exception('Failed to load data');
    }
  }

  Future<bool> uploadImage(String imageID, File image) async {
    List<int> imgBytes = image.readAsBytesSync();
    final testing = base64Encode(imgBytes);
    final response = await http.post(
        Uri.http(this.urlApi, 'api/v1/image/$imageID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'id': imageID, 'picture': testing}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<Guardian> fetchGuardian(String guardianID) async {
    final response =
        await http.get(Uri.http(this.urlApi, 'api/v1/guardian/$guardianID'));
    if (response.statusCode == 200) {
      return Guardian.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load guardian');
    }
  }

  Future<List<GuardianPivot>> fetchGuardianPivot(String studentID) async {
    List<GuardianPivot> guardianStudent = [];
    final response = await http
        .get(Uri.http(this.urlApi, 'api/v1/guardianPivot/$studentID'));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      for (var guardianPivot in responseJson) {
        var newPivot = GuardianPivot(
            id: guardianPivot['id'],
            student_id: guardianPivot['student_id'],
            guardian_id: guardianPivot['guardian_id']);
        guardianStudent.add(newPivot);
      }
      return guardianStudent;
    } else {
      throw Exception('Failed to load data');
    }
  }

  //new
  Future<List<Activity>> fetchActivitiesOfDate(DateTime date) async {
    List<Activity> activities = [];
    var format = NumberFormat("00", 'en_US');
    final day = format.format(date.day);
    final month = format.format(date.month);

    final response = await http.get(Uri.http(
        this.urlApi, 'api/v1/getActivityOfDate/$day/$month/${date.year}'));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      for (var activityFetched in responseJson) {
        var act = Activity(
            time: activityFetched['time'],
            id: activityFetched['id'],
            date: activityFetched['date'],
            description: activityFetched['description'],
            name: activityFetched['name'],
            message: activityFetched['message'],
            type: activityFetched['type'],
            haveImage: activityFetched['haveImage'],
            needAuth: activityFetched['needAuth']);
        activities.add(act);
      }
      return activities;
    }
  }

  Future<Activity> fetchActivityByDate(DateTime date, String activityID) async {
    Activity activities;
    var format = NumberFormat("00", 'en_US');
    final day = format.format(date.day);
    final month = format.format(date.month);

    final response = await http.get(Uri.http(
        this.urlApi, 'api/v1/activity/$activityID/$day/$month/${date.year}'));

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      var act = Activity(
          time: responseJson['time'],
          id: responseJson['id'],
          date: responseJson['date'],
          description: responseJson['description'],
          name: responseJson['name'],
          message: responseJson['message'],
          type: responseJson['type'],
          haveImage: responseJson['haveImage'],
          needAuth: responseJson['needAuth']);

      activities = act;
      return activities;
    }
  }

  Future<GuardianPivot> postPivot(String guardianID, String studentID) async {
    final pivotGuardian =
        GuardianPivot(guardian_id: guardianID, student_id: studentID);
    final response = await http.post(
        Uri.http(this.urlApi, 'api/v1/guardianPivot'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'student_id': pivotGuardian.student_id,
          'guardian_id': pivotGuardian.guardian_id
        }));
    if (response.statusCode == 200) {
      return GuardianPivot.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post guardian pivot data');
    }
  }

  Future<Guardian> postGuardian(Guardian guardian, String studentID) async {
    final guardianPost = guardian;
    final response = await http.post(Uri.http(this.urlApi, 'api/v1/guardian'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': guardianPost.name,
          'kinship': guardianPost.kinship,
          'phoneNumber': guardianPost.phoneNumber
        }));
    if (response.statusCode == 200) {
      final guardianResponse = Guardian.fromJson(jsonDecode(response.body));
      final pivot = await this.postPivot(guardianResponse.id, studentID);
      if (pivot != null) {
        return guardianResponse;
      } else {
        throw Exception('Failed to post guardian pivot data');
      }
    } else {
      throw Exception('Failed to post guardian data');
    }
  }

  Future<MedicalRecord> postMedicalRecord(MedicalRecord medicalRecord) async {
    final medicalRecordBody = medicalRecord;
    final response =
        await http.post(Uri.http(this.urlApi, 'api/v1/medicalRecord'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'allergy': medicalRecordBody.allergy,
              'remedy': medicalRecordBody.remedy,
              'bloodType': medicalRecordBody.bloodType,
              'authorization': medicalRecordBody.authorization,
              'hospitalName': medicalRecordBody.hospitalName,
              'studentID': medicalRecordBody.studentID,
              'havePrescription': medicalRecordBody.havePrescription
            }));
    if (response.statusCode == 200) {
      return MedicalRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post medical record data');
    }
  }

  Future<MedicalRecord> fetchMedicalRecord(String studentID) async {
    try {
      final response = await http
          .get(Uri.http(this.urlApi, 'api/v1/medicalRecord/$studentID'));
      if (response.statusCode != 200)
        throw HttpException('${response.statusCode}');
      return MedicalRecord.fromJson(jsonDecode(response.body));
    } on HttpException {
      print("Medical record not foud");
    }
  }

  Future<MedicalRecord> updateMedicalRecord(MedicalRecord medicalRecord) async {
    final medicalRecordParm = medicalRecord;

    final response = await http.put(
        Uri.http(this.urlApi, 'api/v1/updateMedical/${medicalRecordParm.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'remedy': medicalRecordParm.remedy,
          'allergy': medicalRecordParm.allergy,
          'hospitalName': medicalRecordParm.hospitalName,
          'studentID': medicalRecordParm.studentID,
          'bloodType': medicalRecordParm.bloodType,
          'authorization': medicalRecordParm.authorization
        }));
    if (response.statusCode == 200) {
      return MedicalRecord.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post medical record');
    }
  }

  Future<StudentActivity> updateAuth(
      String student, Activity activity, bool auth) async {
    final response = await http.put(
        Uri.http(
            this.urlApi, 'api/v1/updateAuth/${student}/${activity.id}/${auth}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'student_id': student,
          'activity_id': activity.id,
          'needSignature': true,
          'isAuthorized': auth,
          'willGo': false
        }));
    if (response.statusCode == 200) {
      return StudentActivity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post medical record');
    }
  }

  Future<http.Response> deleteActivityPivot(String activityID) async {
    final http.Response response = await http.delete(
        Uri.parse('http://${this.urlApi}/api/v1/pivotDelete/$activityID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    return response;
  }

  Future<http.Response> deleteActivity(String activityID) async {
    final http.Response response = await http.delete(
        Uri.parse('http://${this.urlApi}/api/v1/activity/$activityID'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    return response;
  }

  Future<bool> updateActivity(Activity activity) async {
    final response =
        await http.put(Uri.http(this.urlApi, 'api/v1/activity/${activity.id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'id': activity.id,
              'description': activity.description,
              'date': activity.date,
              'time': activity.time,
              'type': activity.type,
              'message': activity.message,
              'haveImage': activity.haveImage,
              'schoolClass': activity.schoolClass,
              'name': activity.name,
              'activityDate': activity.activityDate,
              'isApproved': true
            }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to post guardian data');
    }
  }

  Future<Guardian> updateGuardian(Guardian guardian) async {
    final guardianPost = guardian;
    final response = await http.put(
        Uri.http(this.urlApi, 'api/v1/guardian/${guardianPost.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': guardianPost.name,
          'kinship': guardianPost.kinship,
          'phoneNumber': guardianPost.phoneNumber
        }));
    if (response.statusCode == 200) {
      return Guardian.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post guardian data');
    }
  }

  Future<Students> updateStudent(Students student) async {
    final response =
        await http.put(Uri.http(this.urlApi, 'api/v1/student/${student.id}'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'name': student.username,
              'registration': student.register,
              // 'schoolClass_id': student.schoolClass_id,
              // 'password': student.password,
              'birthday': student.birthday,
              // 'lastSeen': student.lastSeen,
              // 'hasMsg': student.hasMsgS
            }));
    if (response.statusCode == 200) {
      return Students.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update student data');
    }
  }

  Future<Image> getImage(String endPoint, String imageName) async {
    try {
      final response =
          await http.get(Uri.http(this.urlApi, 'api/v1/$endPoint'));
      if (response.statusCode != 200)
        throw HttpException('${response.statusCode}');
      final dir = await getTemporaryDirectory();
      var filePathAndName = dir.path + '/$imageName.jpg';
      File newFile = new File(filePathAndName);
      newFile.writeAsBytesSync(response.bodyBytes);
      final image = Image.file(newFile);

      return image;
    } on HttpException {
      print("Medical record not foud");
    }
  }

  Future<bool> checkAdminCredentials(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.get(
        Uri.parse('http://${this.urlApi}/signinTeacherAdmin'),
        headers: {HttpHeaders.authorizationHeader: '$basicAuth'});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> checkCredentials(String username, String classRoom) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$classRoom'));
    final response = await http.get(Uri.parse('http://${this.urlApi}/signin'),
        headers: {HttpHeaders.authorizationHeader: '$basicAuth'});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  int transform(String tipo) {
    var tipoString = tipo.toString();

    var fstNro = tipoString[0];

    return int.parse(fstNro);
  }

  // static String encode(List<Student> students) => json.encode(
  //   students
  //       .map<Map<String,dynamic>>((student) => Student.toMap)
  // )
}
