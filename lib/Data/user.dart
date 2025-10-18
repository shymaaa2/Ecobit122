class User {
  String? key;
  UserData? userData;

  User({this.key, this.userData});
}

class UserData{
  String? email;
  String? uname;
  String? pass;
  DateTime? dob;

  UserData({this.email, this.uname, this.pass, this.dob});

  UserData.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'],
        uname = json['uname'],
        pass = json['pass'],
        dob = json['dob'];
}