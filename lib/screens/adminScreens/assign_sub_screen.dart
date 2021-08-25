import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AssignSubject extends StatefulWidget {
  const AssignSubject({Key key}) : super(key: key);

  @override
  _AssignSubjectState createState() => _AssignSubjectState();
}

class _AssignSubjectState extends State<AssignSubject> {
  List<Subject> subs = [];
  List<AppUser> teachers = [];
  Subject selectedSub = Subject();
  AppUser teacher = AppUser();

  assignSubject(AppUser user, Subject sub) async {
    await firebase.assignSubtoTeacher(user, sub);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  initAsync() async {
    var sub = await firebase.getAllSubjects();
    var teacherss = await firebase.getTeachers();
    setState(() {
      subs = sub;
      teachers = teacherss;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Assign Subject",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: DropdownButtonFormField<Subject>(
                style: fieldText,

                validator: (value) {
                  if (value == null) return "Mandatory Field";
                  return null;
                },
                decoration: new InputDecoration(
                  alignLabelWithHint: true,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                  labelText: "Subject",
                ),
                isExpanded: true,
                // hint: Text("Select item"),
                // value: user.level,
                onChanged: (Subject value) {
                  setState(() {
                    selectedSub = value;
                  });
                },
                items: subs.map((Subject sub) {
                  return DropdownMenuItem<Subject>(
                      value: sub,
                      child: Text(
                        sub.name,
                      ));
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: DropdownButtonFormField<AppUser>(
                style: fieldText,

                validator: (value) {
                  if (value == null) return "Mandatory Field";
                  return null;
                },
                decoration: new InputDecoration(
                  alignLabelWithHint: true,
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30),
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(
                    Icons.lock,
                  ),
                  labelText: "Teachers",
                ),
                isExpanded: true,
                // hint: Text("Select item"),
                // value: user.level,
                onChanged: (AppUser value) {
                  setState(() {
                    teacher = value;
                  });
                },
                items: teachers.map((AppUser user) {
                  return DropdownMenuItem<AppUser>(
                      value: user,
                      child: Text(
                        user.name,
                      ));
                }).toList(),
              ),
            ),
            CustomButton(
              text: "Assign",
              margin: EdgeInsets.all(8),
              onPress: () => assignSubject(teacher, selectedSub),
            )
          ],
        ),
      ),
    );
  }
}
