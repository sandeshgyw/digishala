import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/attendance.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/models/subject.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

class _Firebase {
  FirebaseAuth _firebaseAuth;
  User firebaseUser;
  AppUser appUser;
  FirebaseMessaging _messaging;
  FirebaseFirestore _firestore;
  FirebaseStorage _storage;

  initialize() async {
    await Firebase.initializeApp();
    _firebaseAuth = FirebaseAuth.instance;
    firebaseUser = _firebaseAuth.currentUser;
    _messaging = FirebaseMessaging.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    if (firebaseUser != null) {
      appUser = await getMyUserModel();
      // updateLastOnlineStatus();
      appUser.uid = firebaseUser.uid;
      uploadToken(appUser);
    }
  }

  sendPhoneCode(
    String countryCode,
    String phone, {
    Function(String, [int]) onSent,
    Function(FirebaseException) onFailed,
    Function(AppUser) onCompleted,
    Function(String) autoRetrivalTimeout,
  }) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+$countryCode" + phone,
      timeout: Duration(minutes: 1),
      verificationCompleted: (AuthCredential auth) async {
        onCompleted(await verifyCode(
          auth,
          countryCode,
        ));
      },
      verificationFailed: onFailed,
      codeSent: onSent,
      codeAutoRetrievalTimeout: (autoRetrivalTimeout) {},
    );
  }

  Future<AppUser> verifyCode(
    AuthCredential auth,
    String countryCode,
  ) async {
    firebaseUser = (await _firebaseAuth.signInWithCredential(auth)).user;
    // uploadToken();
    return getMyUserModel(
      countryCode: countryCode,
    );
  }

  Future<AppUser> getMyUserModel({String countryCode}) async {
    var userRef = _firestore.collection("users").doc(firebaseUser.uid);
    var userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      AppUser model = AppUser.fromMap(userSnapshot.data());
      return appUser = model;
    } else {
      AppUser userModel = AppUser()
        ..phoneNumber = firebaseUser.phoneNumber
        ..profileCreated = false
        ..isVerified = false
        ..token = await _messaging.getToken()
        ..uid = firebaseUser.uid;
      await userRef.set(userModel.toMap());
      return appUser = userModel;
    }
  }

  Future<Map> get customClaims async {
    return (await firebaseUser.getIdTokenResult(true)).claims ?? {};
  }

  Future<void> saveProfile(AppUser user, File image) async {
    user.profileCreated = true;
    Reference ref = _storage
        .ref()
        .child(user.faculty)
        .child(user.year.toString())
        .child(user.roll.toString());
    UploadTask task = ref.putFile(image);
    await task;
    user.imageUrl = await ref.getDownloadURL();
    user.phoneNumber = firebaseUser.phoneNumber;
    user.uid = firebaseUser.uid;
    user.activeLibraryCards = 7;
    await _firestore.collection("users").doc(user.uid).set(user.toMap());
  }

  uploadToken(AppUser user) async {
    String token = await _messaging.getToken();
    await _firestore.collection("users").doc(user.uid).set(
      {"token": token},
      SetOptions(merge: true),
    );
  }

  Future<bool> addSubject(Subject subject) async {
    var ref = _firestore.collection("subjects").doc();
    subject.subId = ref.id;
    await ref.set(subject.toMap());
    var usersRef = _firestore
        .collection("users")
        .where("faculty", isEqualTo: subject.faculty)
        .where("year", isEqualTo: 2074);
    return true;
  }

  Future<bool> addFinalYear(int year) async {
    var ref = _firestore.collection("settings").doc("KwDHFFZA1QBRh2JFSmT4");
    await ref.set({"5thyear": year});
    QuerySnapshot snapshot = await _firestore
        .collection("users")
        .where("level", isEqualTo: "STUDENT")
        .get();

    snapshot.docs.forEach((e) async {
      Map data = e.data();
      int currentYear = 5 + year - int.parse((data["year"].toString()));
      await _firestore
          .collection("users")
          .doc(e.id)
          .update({"currentYear": currentYear});
    });
    return true;
  }

  Future<bool> addFaculty(String faculty) async {
    var ref = _firestore
        .collection("settings")
        .doc("KwDHFFZA1QBRh2JFSmT4")
        .collection("faculties")
        .doc();
    await ref.set({"faculty": faculty});
    return true;
  }

  Future<List<String>> getFaculties() async {
    List<String> faculties = [];
    CollectionReference ref = _firestore
        .collection("settings")
        .doc("KwDHFFZA1QBRh2JFSmT4")
        .collection("faculties");
    QuerySnapshot snapshot = await ref.get();
    faculties = snapshot.docs.map((e) {
      Map data;
      data = e.data();

      return data["faculty"].toString();
    }).toList();

    return faculties;
  }

  Future<List<Subject>> getSubjects(int year, String faculty) async {
    List<Subject> subjects = [];
    CollectionReference ref = _firestore.collection("users");
    QuerySnapshot snapshot =
        await ref.doc(firebaseUser.uid).collection("subjects").get();
    subjects = snapshot.docs.map((e) {
      Map data;
      data = e.data();

      return Subject.fromMap(e.data());
    }).toList();

    return subjects;
  }

  Future<List<Subject>> getAllSubjects() async {
    List<Subject> subjects = [];
    CollectionReference ref = _firestore.collection("subjects");
    QuerySnapshot snapshot = await ref.get();
    subjects = snapshot.docs.map((e) {
      Map data;
      data = e.data();

      return Subject.fromMap(e.data());
    }).toList();

    return subjects;
  }

  Future<List<AppUser>> getStudents(
      int year, String faculty, bool isAdmin) async {
    if (isAdmin)
      return (await _firestore
              .collection("users")
              .where("currentYear", isEqualTo: year)
              .where("faculty", isEqualTo: faculty)
              .where("isVerified", isEqualTo: false)
              .get())
          .docs
          .map<AppUser>((e) => AppUser.fromMap(e.data()))
          .toList();
    else
      return (await _firestore
              .collection("users")
              .where("currentYear", isEqualTo: year)
              .where("faculty", isEqualTo: faculty)
              .where("isVerified", isEqualTo: true)
              .where("level", isEqualTo: "STUDENT")
              .get())
          .docs
          .map<AppUser>((e) => AppUser.fromMap(e.data()))
          .toList();
  }

  Future<bool> saveAttendance(
      List<AppUser> users, Subject subject, String date) async {
    users.forEach((e) async {
      await _firestore
          .collection("users")
          .doc(e.uid)
          .collection("subjects")
          .doc(subject.subId)
          .collection("dates")
          .doc(date)
          .set({"isPresent": e.isPresent});
    });

    return true;
  }

  Future<List<Attendance>> getAttendanceData(
      AppUser user, Subject subject) async {
    List<Attendance> totalDays;
    CollectionReference ref = _firestore
        .collection("users")
        .doc(user.uid)
        .collection("subjects")
        .doc(subject.subId)
        .collection("dates");
    QuerySnapshot snapshot = await ref.get();
    totalDays =
        snapshot.docs.map((e) => Attendance.fromMap(e.data(), e.id)).toList();

    return totalDays;
  }

  Future<List<AppUser>> getTeachers() async {
    return (await _firestore
            .collection("users")
            .where("level", isEqualTo: "TEACHER")
            .get())
        .docs
        .map<AppUser>((e) => AppUser.fromMap(e.data()))
        .toList();
  }

  Future<bool> assignSubtoTeacher(AppUser teacher, Subject subject) async {
    await _firestore
        .collection("users")
        .doc(teacher.uid)
        .collection("subjects")
        .doc(subject.subId)
        .set(subject.toMap());
    return true;
  }

  Future<bool> verifyUser(AppUser user) async {
    await _firestore
        .collection("users")
        .doc(user.uid)
        .update({"isVerified": true});
    return true;
  }

  Future<bool> requestBook(LibraryRecord libraryRecord) async {
    var ref = _firestore.collection("libraryRecords").doc();
    libraryRecord.recordId = ref.id;
    await ref.set(libraryRecord.toMap());

    return true;
  }

  Future<List<LibraryRecord>> getBooksRecord() async {
    return (await _firestore
            .collection("libraryRecords")
            .where("studentUid", isEqualTo: firebaseUser.uid)
            .get())
        .docs
        .map<LibraryRecord>((e) => LibraryRecord.fromMap(e.data()))
        .toList();
  }

  Future<List<LibraryRecord>> getBooksRecordFiltered(
      String filter, bool value) async {
    return (await _firestore
            .collection("libraryRecords")
            .where("studentUid", isEqualTo: firebaseUser.uid)
            .where(filter, isEqualTo: value)
            .get())
        .docs
        .map<LibraryRecord>((e) => LibraryRecord.fromMap(e.data()))
        .toList();
  }

  Future<List<LibraryRecord>> getAllBooksRecord() async {
    return (await _firestore.collection("libraryRecords").get())
        .docs
        .map<LibraryRecord>((e) => LibraryRecord.fromMap(e.data()))
        .toList();
  }

  Future<List<LibraryRecord>> getAllBooksRecordFiltered(
      String filter, bool value) async {
    return (await _firestore
            .collection("libraryRecords")
            .where(filter, isEqualTo: value)
            .get())
        .docs
        .map<LibraryRecord>((e) => LibraryRecord.fromMap(e.data()))
        .toList();
  }

  Future<bool> verifyBookRecord(LibraryRecord record) async {
    await _firestore
        .collection("libraryRecords")
        .doc(record.recordId)
        .update({"isVerified": true});
    await _firestore
        .collection("users")
        .doc(record.studentUid)
        .update({"activeLibraryCards": FieldValue.increment(-1)});
    return true;
  }

  Future<bool> rejectBookRecord(LibraryRecord record) async {
    await _firestore
        .collection("libraryRecords")
        .doc(record.recordId)
        .update({"isVerified": false});
    return true;
  }

  Future<bool> acceptBookReturn(LibraryRecord record) async {
    await _firestore
        .collection("libraryRecords")
        .doc(record.recordId)
        .update({"isReturned": true});
    await _firestore
        .collection("users")
        .doc(record.studentUid)
        .update({"activeLibraryCards": FieldValue.increment(1)});
    return true;
  }
}

_Firebase firebase = _Firebase();
