class Log {
  String? key;
  LogData? logData;

  Log({this.key, this.logData});
}

class LogData{
  String? email;
  DateTime? logTime;

  LogData({this.email, this.logTime});

  LogData.fromJson(Map<dynamic, dynamic> json)
      : email = json['email'],
        logTime = json['logTime'];
}