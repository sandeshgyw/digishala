import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/class_beacon.dart';
import 'package:digishala/screens/authorized_home.dart';
import 'package:digishala/screens/teacherScreens/teacher_attendance_records.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class TeacherAttendanceDatesScreen extends StatefulWidget {
  final ClassBeacon classBeacon;
  final bool fromAdmin;
  final AppUser appUser;
  const TeacherAttendanceDatesScreen(
      {Key key,
      @required this.classBeacon,
      this.fromAdmin = false,
      this.appUser})
      : super(key: key);

  @override
  State<TeacherAttendanceDatesScreen> createState() =>
      _TeacherAttendanceDatesScreenState();
}

class _TeacherAttendanceDatesScreenState
    extends State<TeacherAttendanceDatesScreen> {
  List<RoomAttendance> classRoom = [];
  List<String> dates = [];
  @override
  void initState() {
    widget.fromAdmin ? getClassRooms(user: widget.appUser) : getClassRooms();
    // TODO: implement initState
    super.initState();
  }

  getClassRooms({AppUser user}) async {
    var data;
    if (widget.fromAdmin) {
      data = await firebase.getClassRoomDates(widget.classBeacon, user: user);
    } else {
      data = await firebase.getClassRoomDates(widget.classBeacon);
    }

    setState(() {
      classRoom = data;
      classRoom.map((e) => e.date).toList().forEach((e) {
        if (!dates.contains(e)) {
          dates.add(e);
        }
      });
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
            title: dates[index],
            trailing: Icon(
              Icons.arrow_forward_ios,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeacherAttendanceRecordDetail(
                          roomAttendance: classRoom
                              .where((element) => element.date == dates[index])
                              .toList(),
                        ))),
          );
        },
        itemCount: dates.length,
      ),
    );
  }
}
