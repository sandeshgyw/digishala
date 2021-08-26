import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/attendance.dart';
import 'package:digishala/models/subject.dart';
import 'package:digishala/screens/adminScreens/verify_screen.dart';
import 'package:digishala/screens/teacherScreens/attendance_records.dart';
import 'package:digishala/screens/user_detail.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/attendance_tile.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class StudentsScreen extends StatefulWidget {
  final bool fromAdmin;
  final int year;
  final String faculty;
  final Subject subject;
  final bool isViewAttendance;
  const StudentsScreen(
      {Key key,
      this.faculty,
      this.year,
      @required this.fromAdmin,
      this.isViewAttendance = true,
      this.subject})
      : super(key: key);

  @override
  _StudentsScreenState createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<AppUser> users = [];
  bool present = false;
  List<Attendance> attendacerecords = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  initAsync() async {
    var data = await firebase.getStudents(
        widget.year, widget.faculty, widget.fromAdmin);
    setState(() {
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students List"),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await firebase.saveAttendance(users, widget.subject,
                DateTime.now().toString().split(" ").first);
            Navigator.pop(context);
          },
          label: Text("Save Attendance")),
      body: users.length == 0
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.fromAdmin)
                  return CustomTile(
                    title: users[index].name,
                    subtitle: users[index].phoneNumber.toString(),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VerifyScreen(user: users[index])));
                    },
                  );
                if (widget.isViewAttendance == false)
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Color(0xff868784),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            users[index].imageUrl == null
                                ? CircularProgressIndicator()
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: users[index].imageUrl == null
                                          ? Text("Loading")
                                          : CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              backgroundImage: NetworkImage(
                                                    users[index].imageUrl,
                                                  ) ??
                                                  AssetImage(
                                                      "assets/logoo.png"),
                                            ),
                                    ),
                                  ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name: " + users[index].name,
                                  style: tileBoldText,
                                ),
                                Text(
                                  "Roll: " + users[index].roll.toString(),
                                  style: tileBoldText,
                                ),
                                Text(
                                  DateTime.now().toString().split(" ").first,
                                  style: tileBoldText,
                                ),
                              ],
                            )
                          ],
                        ),
                        ListTileTheme(
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          iconColor: Colors.white,
                          tileColor: users[index].isPresent
                              ? Colors.green
                              : Colors.redAccent,
                          child: CheckboxListTile(
                              value: users[index].isPresent,
                              onChanged: (bool newVal) {
                                setState(() {
                                  users[index].isPresent = newVal;
                                });
                              },
                              title: Text(
                                users[index].isPresent ? "Present" : "Absent",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ),
                      ],
                    ),
                  );
                return FutureBuilder(
                    future:
                        getAttendanceDataAsync(users[index], widget.subject),
                    initialData: "Loading text..",
                    builder:
                        (BuildContext context, AsyncSnapshot<String> text) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AttendanceRecords(
                                      user: users[index],
                                      attendances:
                                          users[index].attendanceRecords,
                                    ))),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Color(0xff868784),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  users[index].imageUrl == null
                                      ? CircularProgressIndicator()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 50,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: users[index].imageUrl == null
                                                ? Text("Loading")
                                                : CircleAvatar(
                                                    radius: 50,
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                    backgroundImage:
                                                        NetworkImage(
                                                              users[index]
                                                                  .imageUrl,
                                                            ) ??
                                                            AssetImage(
                                                                "assets/logoo.png"),
                                                  ),
                                          ),
                                        ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name: " + users[index].name,
                                        style: tileBoldText,
                                      ),
                                      Text(
                                        "Roll: " + users[index].roll.toString(),
                                        style: tileBoldText,
                                      ),
                                      Text(
                                        DateTime.now()
                                            .toString()
                                            .split(" ")
                                            .first,
                                        style: tileBoldText,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              ListTileTheme(
                                // shape: RoundedRectangleBorder(
                                //   borderRadius: BorderRadius.circular(10),
                                // ),
                                iconColor: Colors.white,
                                tileColor: users[index].isPresent
                                    ? Colors.green
                                    : Colors.redAccent,
                                child: ListTile(
                                    title: Text(
                                  text.data,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // color: users[index].isPresent
                                    //     ? Colors.yellow
                                    //     : Colors.redAccent,
                                  ),
                                )
                                    // subtitle: Text(
                                    //   users[index].roll.toString(),
                                    //   style: tileText,
                                    // ),
                                    // onTap: () {
                                    //   Navigator.push(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //           builder: (context) =>
                                    //               VerifyScreen(user: users[index])));
                                    // },
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }),
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

    return ((presentDays / total) * 100).toString() + " %";
  }
}
