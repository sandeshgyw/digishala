import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/authorized_home.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TeacherAttendanceRecordDetail extends StatefulWidget {
  final List<RoomAttendance> roomAttendance;
  const TeacherAttendanceRecordDetail({Key key, this.roomAttendance})
      : super(key: key);

  @override
  _TeacherAttendanceRecordDetailState createState() =>
      _TeacherAttendanceRecordDetailState();
}

class _TeacherAttendanceRecordDetailState
    extends State<TeacherAttendanceRecordDetail> {
  List<RoomAttendance> roomAttendance = [];
  AppUser user = AppUser();
  String total = "";

  @override
  void initState() {
    getUserByUid(widget.roomAttendance[0].teacherUid);
    roomAttendance = widget.roomAttendance;
    getTotalAttendanceDuration(roomAttendance);
    // TODO: implement initState
    super.initState();
  }

  getUserByUid(String uid) async {
    var data = await firebase.getUser(uid);
    setState(() {
      user = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendance Record"),
        ),
        body: user?.name == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  user.imageUrl == null
                      ? Center(child: CircularProgressIndicator())
                      : CircleAvatar(
                          radius: 82,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: user.imageUrl == null
                              ? Text("Loading")
                              : CircleAvatar(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  backgroundImage: NetworkImage(
                                        user.imageUrl,
                                      ) ??
                                      AssetImage("assets/logoo.png"),
                                  radius: 80,
                                ),
                        ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    user?.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    roomAttendance[0].date,
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
                        itemCount: roomAttendance.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomTile(
                              title: "Entry : " +
                                  DateFormat.jms().format(
                                      roomAttendance[index].firstScannedTime),
                              subtitle: "Exit : " +
                                  DateFormat.jms().format(
                                      roomAttendance[index].lastScannedTime),
                              trailing: Text(
                                ((roomAttendance[index]
                                                .lastScannedTime
                                                .difference(
                                                  roomAttendance[index]
                                                      .firstScannedTime,
                                                )
                                                .inSeconds) /
                                            60)
                                        .toStringAsFixed(2)
                                        .toString() +
                                    " min",
                                style: tileText,
                              )
                              // onTap: () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               VerifyScreen(user: users[index])));
                              // },
                              );
                        }),
                  ),
                  Text(
                    "Total: " + total,
                    style: boldText,
                  ),
                ],
              ));
  }

  getTotalAttendanceDuration(List<RoomAttendance> attendance) {
    int totalDuration = 0;
    for (int i = 0; i < attendance.length; i++) {
      totalDuration += (attendance[i]
          .lastScannedTime
          .difference(attendance[i].firstScannedTime)
          .inSeconds);
    }
    total = (totalDuration / 60).toStringAsFixed(2) + " min";
    setState(() {});
    return totalDuration;
  }
}
