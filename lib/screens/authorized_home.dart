import 'package:carousel_slider/carousel_slider.dart';
import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/adminScreens/faculty_screen.dart';
import 'package:digishala/screens/adminScreens/settings.dart';
import 'package:digishala/screens/studentscreens/library_screen.dart';
import 'package:digishala/screens/teacherScreens/years_screen.dart';
import 'package:digishala/screens/user_detail.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthorizedHome extends StatefulWidget {
  const AuthorizedHome({Key key}) : super(key: key);

  @override
  _AuthorizedHomeState createState() => _AuthorizedHomeState();
}

class _AuthorizedHomeState extends State<AuthorizedHome> {
  List<String> carousel = [];
  bool isAdmin = false;
  Map claims = {};
  bool getAdminStatus = false;

  carouselItems() {
    if (isAdmin)
      setState(() {
        carousel = [
          "Get all students records",
          "Assign Subject to teachers",
          "Monitor teacher attendance"
        ];
      });
    if (firebase.appUser.level == UserLevel.STUDENT)
      setState(() {
        carousel = [
          "Get your attendance records",
          "Get all your library records",
          "Request administration tasks",
        ];
      });
    if (firebase.appUser.level == UserLevel.TEACHER)
      setState(() {
        carousel = [
          "Take students attendance",
          "Get all your attendance records",
        ];
      });
    if (firebase.appUser.level == UserLevel.LIBRARIAN)
      setState(() {
        carousel = [
          "Get all library records",
          "Get fine details",
          "Approve and Reject Books Records"
        ];
      });
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
    carouselItems();
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
                  (firebase.appUser?.year.toString() ?? "") +
                      "|" +
                      (firebase.appUser?.faculty?.toUpperCase() ?? ""),
                  style: tileText,
                ),
              ),
            ),
            if (isAdmin)
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(),
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
            if (firebase.appUser.level == UserLevel.STUDENT) ...[
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
            ],
            if (firebase.appUser.level == UserLevel.TEACHER)
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
            Divider(),
            ListTile(
              leading: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                "Coming Soon",
                style: normalText,
              ),
            ),
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
    if (firebase.appUser.level == UserLevel.TEACHER)
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
    if (firebase.appUser.level == UserLevel.LIBRARIAN)
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
    if (firebase.appUser.isVerified)
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
            subtitle: "show my library records",
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => LibraryScreen())),
          )
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
