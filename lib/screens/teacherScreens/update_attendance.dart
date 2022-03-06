import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/attendance.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UpdateAttendanceRecord extends StatefulWidget {
  final AppUser user;
  final Attendance attendance;
  final Subject subject;
  const UpdateAttendanceRecord(
      {Key key, this.user, this.attendance, this.subject})
      : super(key: key);

  @override
  State<UpdateAttendanceRecord> createState() => _UpdateAttendanceRecordState();
}

class _UpdateAttendanceRecordState extends State<UpdateAttendanceRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.name,
        ),
      ),
      body: Column(
        children: [
          SwitchListTile(
              title: Text(
                widget.attendance.isPresent ? "Present" : "Absent",
                style: boldText,
              ),
              value: widget.attendance.isPresent,
              onChanged: (bool val) async {
                setState(() {
                  widget.attendance.isPresent = !widget.attendance.isPresent;
                });
              }),
          Text(
            widget.attendance.date,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: "Update",
              onPress: () async {
                await firebase.updateAttendance(
                    widget.user, widget.attendance, widget.subject);
                Navigator.pop(context, widget.attendance.isPresent);
              },
            ),
          ),
        ],
      ),
    );
  }
}
