import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefApp {
  Future<List<String>> getStudentId() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    return myPrefs.getStringList("studentId");
  }

  setStudentIdList(List<String> studentsId) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    myPrefs.setStringList("studentId", studentsId);
  }

  Future<bool> getIsAdmin() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool("isAdmin");
  }

  setIsAdmin(bool isAdmin) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();

    myPrefs.setBool("isAdmin", isAdmin);
  }

  setAdminEmail(String adminEmail) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString("adminEmail", adminEmail);
  }

  Future<String> getAdminEmail() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString("adminEmail");
  }

  Future<String> getLogin() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString("isLogin");
  }

  setLogin(String isLogin) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString("isLogin", isLogin);
  }
}
