import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/adminScreens/faculty_screen.dart';
import 'package:digishala/screens/teacherScreens/subjects_screen.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class YearsScreen extends StatefulWidget {
  const YearsScreen({Key key}) : super(key: key);

  @override
  _YearsScreenState createState() => _YearsScreenState();
}

class _YearsScreenState extends State<YearsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Attendance"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              title: (index + 1).toString(),
              subtitle: "year",
              onTap: () {
                if (firebase.appUser.level == UserLevel.STUDENT)
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubjectScreen(
                                year: index + 1,
                                faculty: firebase.appUser.faculty,
                                fromAdmin: false,
                                isViewAttendance: true,
                              )));
                else
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacultyScreen(
                                isViewAttendance:
                                    true, //as YearsScrren only to viewAttendance
                                year: index + 1,
                                isAdmin: false,
                              )));
              },
            );
          }),
    );
  }
}
