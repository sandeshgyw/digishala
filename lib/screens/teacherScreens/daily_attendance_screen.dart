import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/authorized_home.dart';
import 'package:flutter/material.dart';

class DailyAttendanceRecord extends StatefulWidget {
  final List<AppUser> users;
  const DailyAttendanceRecord({Key key, this.users}) : super(key: key);

  @override
  _DailyAttendanceRecordState createState() => _DailyAttendanceRecordState();
}

class _DailyAttendanceRecordState extends State<DailyAttendanceRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Today's Attendance"),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => AuthorizedHome()));
            },
            label: Text("Go to Home")),
        body: ListView.builder(
            itemCount: widget.users.length,
            itemBuilder: (context, int index) {
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
                        widget.users[index].imageUrl == null
                            ? CircularProgressIndicator()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: widget.users[index].imageUrl == null
                                      ? Text("Loading")
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundImage: NetworkImage(
                                                widget.users[index].imageUrl,
                                              ) ??
                                              AssetImage("assets/logoo.png"),
                                        ),
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: " + widget.users[index].name,
                              style: tileBoldText,
                            ),
                            Text(
                              "Roll: " + widget.users[index].roll.toString(),
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
                      tileColor: widget.users[index].isPresent
                          ? Colors.green
                          : Colors.redAccent,
                      child: CheckboxListTile(
                          value: widget.users[index].isPresent,
                          onChanged: (bool newVal) {
                            // setState(() {
                            //   widget.users[index].isPresent = newVal;
                            // });
                          },
                          title: Text(
                            widget.users[index].isPresent
                                ? "Present"
                                : "Absent",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }));
  }
}
