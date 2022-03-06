import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/teacherScreens/teacher_attendance_screen.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({Key key}) : super(key: key);

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {
  List<AppUser> _teachers = [];
  @override
  void initState() {
    getTeachers();
    // TODO: implement initState
    super.initState();
  }

  getTeachers() async {
    var teachers = await firebase.getTeachers();
    setState(() {
      _teachers = teachers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teachers'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CustomTile(
            title: _teachers[index].name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherAttendanceScreen(
                          fromAdmin: true,
                          appUser: _teachers[index],
                        )),
              );
            },
          );
        },
        itemCount: _teachers.length,
      ),
    );
  }
}
