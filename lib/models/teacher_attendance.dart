import 'package:intl/intl.dart';

class TeacherAttendance {
  String date;
  String entryTime;
  String exitTime;
  String className;
  TeacherAttendance({this.date, this.entryTime, this.exitTime, this.className});

  toMap() {
    return {
      "date": this.date,
      "entryTime": this.entryTime,
      "exitTime": this.exitTime,
      "className": this.className
    };
  }

  static TeacherAttendance fromMap(Map<String, dynamic> json) {
    return TeacherAttendance()
      ..date = DateFormat.yMEd(DateTime.now()).toString()
      ..entryTime = json["entryTime"]
      ..exitTime = json["exitTime"]
      ..className = json["className"];
  }
}
