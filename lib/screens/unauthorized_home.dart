import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/screens/user_detail.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/services/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UnAuthorizedHome extends StatefulWidget {
  const UnAuthorizedHome({Key key}) : super(key: key);

  @override
  _UnAuthorizedHomeState createState() => _UnAuthorizedHomeState();
}

class _UnAuthorizedHomeState extends State<UnAuthorizedHome> {
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
      body: Padding(
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
      ),
    );
  }
}
