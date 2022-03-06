import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/class_beacon.dart';
import 'package:digishala/screens/teacherScreens/teacher_attendance_dates.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  final bool fromAdmin;
  final AppUser appUser;
  const TeacherAttendanceScreen({Key key, this.fromAdmin = false, this.appUser})
      : super(key: key);

  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  List<ClassBeacon> classBeacon = [];
  @override
  void initState() {
    widget.fromAdmin ? getClassRooms(user: widget.appUser) : getClassRooms();
    // TODO: implement initState
    super.initState();
  }

  getClassRooms({AppUser user}) async {
    var data;
    if (widget.fromAdmin) {
      data = await firebase.getClassRoom(classUser: user);
    } else {
      data = await firebase.getClassRoom();
    }
    setState(() {
      classBeacon = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher Attendance",
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CustomTile(
            title: classBeacon[index].className,
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherAttendanceDatesScreen(
                          classBeacon: classBeacon[index],
                          fromAdmin: true,
                          appUser: widget.appUser,
                        ))),
          );
        },
        itemCount: classBeacon.length,
      ),
    );
  }
}
