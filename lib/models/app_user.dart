import 'package:digishala/models/attendance.dart';

class AppUser {
  String name, phoneNumber, faculty, token, uid, imageUrl;
  int year, roll, currentYear;
  bool profileCreated, isVerified;
  UserLevel level;
  bool isPresent = false;
  List<Attendance> attendanceRecords = [];
  int activeLibraryCards;

  toMap() {
    return {
      "uid": uid,
      "name": name,
      "phoneNumber": phoneNumber,
      "faculty": faculty?.toUpperCase(),
      "year": year,
      "roll": roll,
      "token": token,
      "profileCreated": profileCreated ?? false,
      "isVerified": isVerified ?? false,
      "level": level == UserLevel.STUDENT ? "STUDENT" : "TEACHER",
      "imageUrl": imageUrl,
      "currentYear": currentYear,
      "activeLibraryCards": activeLibraryCards
    };
  }

  static AppUser fromMap(Map<String, dynamic> json) {
    return AppUser()
      ..uid = json["uid"]
      ..name = json["name"]
      ..phoneNumber = json["phoneNumber"]
      ..faculty = json["faculty"]
      ..year = json["year"]
      ..roll = json["roll"]
      ..token = json["token"]
      ..profileCreated = json["profileCreated"]
      ..isVerified = json["isVerified"]
      ..level = json["level"] == "STUDENT"
          ? UserLevel.STUDENT
          : json["level"] == "TEACHER"
              ? UserLevel.TEACHER
              : UserLevel.LIBRARIAN
      ..imageUrl = json["imageUrl"]
      ..currentYear = json["currentYear"]
      ..activeLibraryCards = json["activeLibraryCards"];
  }
}

enum UserLevel { TEACHER, STUDENT, LIBRARIAN }
