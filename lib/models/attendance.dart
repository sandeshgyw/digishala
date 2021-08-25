class Attendance {
  String date;
  bool isPresent;
  Attendance({this.date, this.isPresent});

  toMap() {
    return {"date": this.date, "isPresent": this.isPresent};
  }

  static Attendance fromMap(Map<String, dynamic> json, String id) {
    return Attendance()
      ..date = id
      ..isPresent = json["isPresent"];
  }
}
