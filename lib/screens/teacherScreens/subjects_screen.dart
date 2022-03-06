import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/screens/adminScreens/students_screen.dart';
import 'package:digishala/screens/studentscreens/my_attendance.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class SubjectScreen extends StatefulWidget {
  final String faculty;
  final int year;
  final bool fromAdmin;
  bool isViewAttendance = true;
  SubjectScreen(
      {Key key,
      this.faculty,
      this.year,
      this.fromAdmin,
      @required this.isViewAttendance})
      : super(key: key);

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<Subject> subs = [];
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initAsync() async {
    if (firebase.appUser.level == UserLevel.TEACHER) {
      var valSub = await firebase.getSubjects(widget.year, widget.faculty);
      setState(() {
        subs = valSub;
      });
    }
    if (firebase.appUser.level == UserLevel.STUDENT) {
      var val = await firebase.getAllSubjects();
      setState(() {
        subs = val
            .where((element) =>
                element.faculty == widget.faculty &&
                element.year == widget.year)
            .toList();
      });
      print(subs);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subjects")),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: subs.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              title: subs[index].name,
              subtitle: subs[index].faculty,
              onTap: () {
                if (firebase.appUser.level == UserLevel.STUDENT)
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAttendanceDetail(
                                subject: subs[index],
                              )));
                else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StudentsScreen(
                                faculty: widget.faculty,
                                year: widget.year,
                                fromAdmin: widget.fromAdmin,
                                subject: subs[index],
                                isViewAttendance: widget.isViewAttendance,
                              )));
              },
            );
          }),
    );
  }
}
