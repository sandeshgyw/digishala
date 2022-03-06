import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/screens/adminScreens/admin_requests_all_screen.dart';
import 'package:digishala/screens/adminScreens/faculty_screen.dart';
import 'package:digishala/screens/adminScreens/settings.dart';
import 'package:digishala/screens/adminScreens/teachers_screen.dart';
import 'package:digishala/screens/user_detail.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnAuthorizedHome extends StatefulWidget {
  const UnAuthorizedHome({Key key}) : super(key: key);

  @override
  _UnAuthorizedHomeState createState() => _UnAuthorizedHomeState();
}

class _UnAuthorizedHomeState extends State<UnAuthorizedHome> {
  bool isAdmin = false;
  Map claims = {};
  bool getAdminStatus = false;
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
            if (isAdmin) ...[
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
              Divider(),
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeachersListScreen(),
                    )),
                leading: Icon(
                  Icons.school,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "View Teachers Attendance",
                  style: normalText,
                ),
              ),
              Divider(),
              ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllAdminRequests(),
                    )),
                leading: Icon(
                  Icons.request_page,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  "View Admin Requests",
                  style: normalText,
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
          ? body
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
                            isViewAttendance: false,
                          ))),
            );
          });
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
