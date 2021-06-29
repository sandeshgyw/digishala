class AppUser {
  String name, phoneNumber, faculty, token, uid, imageUrl;
  int year, roll;
  bool profileCreated, isVerified;
  UserLevel level;

  toMap() {
    return {
      "uid": uid,
      "name": name,
      "phoneNumber": phoneNumber,
      "faculty": faculty,
      "year": year,
      "roll": roll,
      "token": token,
      "profileCreated": profileCreated ?? false,
      "isVerified": isVerified ?? false,
      "level": level == UserLevel.STUDENT ? "STUDENT" : "TEACHER",
      "imageUrl": imageUrl
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
      ..level =
          json["level"] == "STUDENT" ? UserLevel.STUDENT : UserLevel.TEACHER
      ..imageUrl = json["imageUrl"];
  }
}

enum UserLevel {
  TEACHER,
  STUDENT,
}
