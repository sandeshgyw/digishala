import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/attendance.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class MyAttendanceDetail extends StatefulWidget {
  final Subject subject;
  const MyAttendanceDetail({Key key, @required this.subject}) : super(key: key);

  @override
  _MyAttendanceDetailState createState() => _MyAttendanceDetailState();
}

class _MyAttendanceDetailState extends State<MyAttendanceDetail> {
  String record;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecord();
  }

  getRecord() async {
    var data = await getAttendanceDataAsync(firebase.appUser, widget.subject);
    setState(() {
      record = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Attendance "),
      ),
      body: Column(
        children: [
          ListTile(
            subtitle: Text(
              widget.subject.faculty,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            title: Text(widget.subject.name.toUpperCase(),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            leading: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  record ?? "",
                  style: tileBoldText,
                ),
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: firebase.appUser.attendanceRecords.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomTile(
                    title: firebase.appUser.attendanceRecords[index].date,
                    subtitle:
                        firebase.appUser.attendanceRecords[index].isPresent
                            ? "Present"
                            : "Absent",
                    onTap: () {},
                  );
                }),
          ),
        ],
      ),
    );
  }

  Future<String> getAttendanceDataAsync(AppUser user, Subject subject) async {
    List<Attendance> dates = await firebase.getAttendanceData(user, subject);
    setState(() {
      user.attendanceRecords = dates;
    });
    int total = dates.length;
    int presentDays =
        dates.where((element) => element.isPresent == true).length;

    return ((presentDays / total) * 100).toInt().toString() + "%";
  }
}
