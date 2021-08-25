class Subject {
  String name;
  int year;
  int theoryMarks;
  int practicalMarks;
  String subId;
  String faculty;
  int sem;

  Subject(
      {this.name,
      this.year,
      this.theoryMarks,
      this.practicalMarks,
      this.subId,
      this.faculty,
      this.sem});

  toMap() {
    return {
      "name": name,
      "year": year,
      "theoryMarks": theoryMarks,
      "practicalMarks": practicalMarks,
      "subId": subId,
      "faculty": faculty,
      "sem": sem
    };
  }

  static Subject fromMap(Map<String, dynamic> json) {
    return Subject()
      ..name = json["name"]
      ..faculty = json["faculty"]
      ..year = json["year"]
      ..theoryMarks = json["theoryMarks"]
      ..practicalMarks = json["practicalMarks"]
      ..subId = json["subId"]
      ..sem = json["sem"];
  }
}
