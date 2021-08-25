import 'package:digishala/screens/adminScreens/students_screen.dart';
import 'package:digishala/screens/teacherScreens/subjects_screen.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class FacultyScreen extends StatefulWidget {
  final bool isAdmin;
  final int year;
  bool isViewAttendance = true;
  FacultyScreen(
      {Key key,
      this.year,
      @required this.isAdmin,
      @required this.isViewAttendance})
      : super(key: key);

  @override
  _FacultyScreenState createState() => _FacultyScreenState();
}

class _FacultyScreenState extends State<FacultyScreen> {
  List<String> faculties = [];
  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initAsync() async {
    var facultiesList = await firebase.getFaculties();
    setState(() {
      faculties = facultiesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digishala"),
      ),
      body: faculties.length == 0
          ? CircularProgressIndicator()
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: faculties.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomTile(
                  title: faculties[index],
                  onTap: () {
                    if (widget.isAdmin)
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentsScreen(
                                    year: widget.year,
                                    faculty: faculties[index],
                                    fromAdmin: widget.isAdmin,
                                    isViewAttendance: true,
                                  )));
                    else
                      return Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubjectScreen(
                                    year: widget.year,
                                    faculty: faculties[index],
                                    fromAdmin: widget.isAdmin,
                                    isViewAttendance: widget.isViewAttendance,
                                  )));
                  },
                );
              }),
    );
  }
}
