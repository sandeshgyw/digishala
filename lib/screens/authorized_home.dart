import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/mixin/room_scanner.dart';
import 'package:digishala/models/admin_request.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/class_beacon.dart';
import 'package:digishala/models/room.dart';
import 'package:digishala/models/teacher_attendance.dart';
import 'package:digishala/screens/adminScreens/faculty_screen.dart';
import 'package:digishala/screens/adminScreens/settings.dart' as settings;
import 'package:digishala/screens/studentscreens/admin_requests_screen.dart';
import 'package:digishala/screens/studentscreens/admin_task_request.dart';
import 'package:digishala/screens/studentscreens/library_screen.dart';
import 'package:digishala/screens/studentscreens/request_a_leave.dart';
import 'package:digishala/screens/teacherScreens/teacher_attendance_screen.dart';
import 'package:digishala/screens/teacherScreens/years_screen.dart';
import 'package:digishala/screens/user_detail.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:digishala/services/scanner.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snowm_scanner/snowm_scanner.dart';

class RoomAttendance {
  String roomKey, roomName, teacherUid, date;
  DateTime entryTime, exitTime, firstScannedTime, lastScannedTime;
  RoomAttendance(Room room) {
    roomKey = room.key;
    roomName = room.name;
    teacherUid = firebase.appUser?.uid;
  }

  toMap() {
    return {
      "roomKey": roomKey,
      "roomName": roomName,
      "teacherUid": firebase.firebaseUser.uid,
      "entryTime": entryTime,
      "exitTime": exitTime,
      "firstScannedTime": firstScannedTime,
      "lastScannedTime": lastScannedTime,
      "date": date
    };
  }

  static RoomAttendance fromMap(Map<String, dynamic> json) {
    return RoomAttendance(Room())
      ..roomKey = json['roomKey']
      ..roomName = json['roomName']
      ..teacherUid = json['teacherUid']
      ..entryTime = (json['entryTime'] as Timestamp).toDate()
      ..exitTime = (json['exitTime'] as Timestamp).toDate()
      ..firstScannedTime = (json['firstScannedTime'] as Timestamp).toDate()
      ..lastScannedTime = (json['lastScannedTime'] as Timestamp).toDate()
      ..date = json['date'];
  }
}

class AuthorizedHome extends StatefulWidget {
  const AuthorizedHome({Key key}) : super(key: key);

  @override
  _AuthorizedHomeState createState() => _AuthorizedHomeState();
}

class _AuthorizedHomeState extends State<AuthorizedHome> with RoomScanner {
  List<String> carousel = [];
  bool isAdmin = false;
  Map claims = {};
  bool getAdminStatus = false;
  List<String> uuids = [];
  List<ClassBeacon> classBeacons = [];
  List<Room> classRooms = [];
  TeacherAttendance attendance = TeacherAttendance();
  bool trackingStarted = false;
  // Per class

  carouselItems() {
    if (isAdmin)
      setState(() {
        carousel = [
          "Get all students records",
          "Assign Subject to teachers",
          "Monitor teacher attendance"
        ];
      });
    if (firebase.appUser?.level == UserLevel.STUDENT)
      setState(() {
        carousel = [
          "Get your attendance records",
          "Get all your library records",
          "Request administration tasks",
        ];
      });
    if (firebase.appUser?.level == UserLevel.TEACHER)
      setState(() {
        carousel = [
          "Take students attendance",
          "Get all your attendance records",
        ];
      });
    if (firebase.appUser?.level == UserLevel.LIBRARIAN)
      setState(() {
        carousel = [
          "Get all library records",
          "Get fine details",
          "Approve and Reject Books Records"
        ];
      });
  }

  Future<bool> getUUids() async {
    classBeacons = await firebase.getUUids();
    uuids = classBeacons.map((e) => e.uuid).toList();
    setState(() {
      classRooms = classBeacons.map((e) {
        return Room()
          ..key = e.id
          ..name = e.className
          ..uuids = [e.uuid];
      }).toList();
    });

    if (firebase.appUser?.level == UserLevel.TEACHER) {
      startRoomScanner(classRooms);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    firebase.customClaims.then((value) {
      setState(() {
        this.claims = value;
        isAdmin = claims["admin"] ?? false;
        getAdminStatus = true;
      });
    });
    getUUids();

    carouselItems();
  }

  @override
  void dispose() {
    disposeScanner();
    super.dispose();
  }

  @override
  onEntered(RoomAttendance roomAttendance) {
    if (!trackingStarted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Entered Class.Attendance tracking started{${roomAttendance.entryTime}}")));
      trackingStarted = true;
    }

    // TODO: implement onEntered
    return super.onEntered(roomAttendance);
  }

  @override
  onExited(RoomAttendance roomAttendance) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Exited Class.Attendance tracking stopped{${roomAttendance.exitTime}}")));
    trackingStarted = false;
    // TODO: implement onExited
    return super.onExited(roomAttendance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Digishala"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserDetail()));
              },
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff6B705C),
                  // image: DecorationImage(
                  //     fit: BoxFit.fill,
                  //     image: AssetImage(
                  //       "assets/logoo.png",
                  //     )),
                ),
                currentAccountPicture: CircleAvatar(
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 100,
                    child: firebase.appUser?.imageUrl == null
                        ? Icon(
                            Icons.person,
                            size: 50,
                          )
                        : ClipOval(
                            child: Image.network(
                              firebase.appUser.imageUrl,
                              fit: BoxFit.fill,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                            ),
                          ),
                  ),
                ),
                accountName: Text(
                  firebase.appUser?.name ?? "",
                  style: tileBoldText,
                ),
                accountEmail: Text(
                  (firebase.appUser?.year?.toString() ?? "") +
                              "|" +
                              (firebase.appUser?.faculty?.toUpperCase() ??
                                  "") ==
                          "|"
                      ? "WELCOME"
                      : (firebase.appUser?.year?.toString() ?? "") +
                          "|" +
                          (firebase.appUser?.faculty?.toUpperCase() ?? ""),
                  style: tileText,
                ),
              ),
            ),
            if (isAdmin) ...[
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => settings.Settings(),
                    )),
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Admin Panel",
                  style: normalText,
                ),
              ),
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => settings.Settings(),
                    )),
                leading: Icon(
                  Icons.settings,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "View Teachers Attendance",
                  style: normalText,
                ),
              ),
            ],
            if (firebase.appUser?.level == UserLevel.STUDENT) ...[
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "My Attendance",
                  style: normalText,
                ),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => YearsScreen())),
              ),
              ListTile(
                leading: Icon(
                  Icons.book,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Library",
                  style: normalText,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => LibraryScreen())),
              ),
              ListTile(
                leading: Icon(
                  Icons.security,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Admin Requests",
                  style: normalText,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminTaskRequest())),
              ),
              ListTile(
                leading: Icon(
                  Icons.request_page,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "Request a Leave",
                  style: normalText,
                ),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => LeaveRequestScreen())),
              ),
            ],
            if (firebase.appUser?.level == UserLevel.TEACHER) ...[
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "View Attendance",
                  style: normalText,
                ),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => YearsScreen())),
              ),
              ListTile(
                leading: Icon(
                  Icons.receipt_long_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "My Attendance",
                  style: normalText,
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TeacherAttendanceScreen(),
                  ),
                ),
              ),
            ],
            Divider(),
            ListTile(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  firebase.appUser = null;
                  firebase.firebaseUser = null;
                });
                navigateUser(context);
              },
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Log Out",
                style: normalText,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("My Detail"),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserDetail()));
        },
      ),
      body: getAdminStatus
          ? Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: carousel.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Text(
                                '$i',
                                style: tileBoldText,
                              ),
                            ));
                      },
                    );
                  }).toList(),
                ),
                Expanded(child: body),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget get body {
    if (isAdmin ?? false)
      return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              title: (index + 1).toString(),
              subtitle: "year",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyScreen(
                            year: index + 1,
                            isAdmin: isAdmin,
                            isViewAttendance: true,
                          ))),
            );
          });
    if (firebase.appUser?.level == UserLevel.TEACHER)
      return ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              title: (index + 1).toString(),
              subtitle: "year",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyScreen(
                            year: index + 1,
                            isAdmin: isAdmin,
                            isViewAttendance: false,
                          ))),
            );
          });
    if (firebase.appUser?.level == UserLevel.LIBRARIAN)
      return ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          CustomTile(
            title: "View library records",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LibraryScreen()),
            ),
          )
        ],
      );
    if (firebase.appUser?.isVerified ?? false)
      return ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          CustomTile(
            leading: Icon(Icons.verified_sharp),
            title: "Attendance",
            subtitle: "show my attendance",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => YearsScreen()),
            ),
          ),
          Divider(),
          CustomTile(
            leading: Icon(Icons.library_books),
            title: "Library",
            subtitle: "library tasks",
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => LibraryScreen())),
          ),
          Divider(),
          CustomTile(
            leading: Icon(Icons.verified_sharp),
            title: "Admin Requests",
            subtitle: "show my requests",
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MyAdminRequests()),
            ),
          ),
        ],
      );
    else
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ListTile(
            // tileColor: Theme.of(context).primaryColor,
            title: Text(
              "Thank you  ${firebase?.appUser?.name}.",
              textAlign: TextAlign.center,
              style: boldText,
            ),
            subtitle: Text(
              "You will be able to access the app once verified by the department.",
              style: fieldText,
              textAlign: TextAlign.center,
            ),
            isThreeLine: true,
          ),
        ),
      );
  }
}
