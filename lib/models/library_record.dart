import 'package:cloud_firestore/cloud_firestore.dart';

class LibraryRecord {
  String bookName;
  DateTime dateOfCheckout;
  DateTime dueDate;
  String bookKey;
  String studentName;
  int studentRoll;
  String studentFaculty;
  String studentUid;
  bool isVerified;
  bool isReturned;
  String recordId;

  LibraryRecord(
      {this.bookName,
      this.dateOfCheckout,
      this.dueDate,
      this.bookKey,
      this.studentName,
      this.studentRoll,
      this.studentFaculty,
      this.studentUid,
      this.isVerified = false,
      this.isReturned = false,
      this.recordId});

  toMap() {
    return {
      "bookName": bookName,
      "dateOfCheckout": dateOfCheckout,
      "dueDate": dueDate,
      "bookKey": bookKey,
      "studentName": studentName,
      "studentRoll": studentRoll,
      "studentFaculty": studentFaculty,
      "studentUid": studentUid,
      "isVerified": isVerified,
      "isReturned": isReturned,
      "recordId": recordId
    };
  }

  static LibraryRecord fromMap(Map<String, dynamic> json) {
    return LibraryRecord()
      ..bookName = json["bookName"]
      ..dateOfCheckout = (json["dateOfCheckout"] as Timestamp).toDate()
      ..dueDate = (json["dueDate"] as Timestamp).toDate()
      ..bookKey = json["bookKey"]
      ..studentName = json['studentName']
      ..studentRoll = json["studentRoll"]
      ..studentFaculty = json["studentFaculty"]
      ..studentUid = json["studentUid"]
      ..isReturned = json["isReturned"]
      ..isVerified = json["isVerified"]
      ..recordId = json["recordId"];
  }
}
