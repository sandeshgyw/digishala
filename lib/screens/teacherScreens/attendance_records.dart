import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/attendance.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/screens/teacherScreens/update_attendance.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class AttendanceRecords extends StatefulWidget {
  final AppUser user;
  final List<Attendance> attendances;
  final Subject subject;
  const AttendanceRecords({Key key, this.user, this.attendances, this.subject})
      : super(key: key);

  @override
  _AttendanceRecordsState createState() => _AttendanceRecordsState();
}

class _AttendanceRecordsState extends State<AttendanceRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendance Record"),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            widget.user.imageUrl == null
                ? Center(child: CircularProgressIndicator())
                : CircleAvatar(
                    radius: 82,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: widget.user.imageUrl == null
                        ? Text("Loading")
                        : CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            backgroundImage: NetworkImage(
                                  widget.user.imageUrl,
                                ) ??
                                AssetImage("assets/logoo.png"),
                            radius: 80,
                          ),
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.user.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              widget.user.roll.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Divider(),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: widget.attendances.length,
                  itemBuilder: (BuildContext context, int index) {
                    return CustomTile(
                      title: widget.attendances[index].date,
                      subtitle: widget.attendances[index].isPresent
                          ? "Present"
                          : "Absent",
                      onTap: () async {
                        if (firebase.appUser.level == UserLevel.TEACHER) {
                          widget.attendances[index].isPresent =
                              await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateAttendanceRecord(
                                user: widget.user,
                                attendance: widget.attendances[index],
                                subject: widget.subject,
                              ),
                            ),
                          );
                          setState(() {});
                        }
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
