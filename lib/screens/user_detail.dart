import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/services/firebase.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key key}) : super(key: key);

  @override
  _UserDerailState createState() => _UserDerailState();
}

class _UserDerailState extends State<UserDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Details",
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Column(
            children: [
              firebase.appUser.imageUrl == null
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 82,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: firebase.appUser.imageUrl == null
                          ? Text("Loading")
                          : CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,

                              backgroundImage: NetworkImage(
                                    firebase.appUser.imageUrl,
                                  ) ??
                                  AssetImage("assets/logoo.png"),
                              radius: 80,
                              // child: firebase.appUser?.imageUrl == null
                              //     ? Icon(
                              //         Icons.person,
                              //         size: 50,
                              //       )
                              //     : ClipOval(
                              //         child: Image.network(
                              //           firebase.appUser.imageUrl,
                              //           fit: BoxFit.fill,
                              //           width: MediaQuery.of(context).size.width,
                              //           height: MediaQuery.of(context).size.height,
                              //         ),
                              //       ),
                            ),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                firebase?.appUser?.name ?? "",
                style: boldText,
              ),
              Text(
                firebase?.appUser?.level.toString().split("UserLevel.")[1] ??
                    "",
                style: normalText,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
          ),
          // ListTile(
          //   title: Text(
          //     "Name",
          //     style: boldText,
          //   ),
          //   subtitle: Text(
          //     firebase.appUser.name,
          //     style: normalText,
          //   ),
          //   leading: Icon(Icons.person),
          // ),
          if (firebase.appUser.level == UserLevel.STUDENT) ...[
            ListTile(
              title: Text(
                "Faculty",
                style: boldText,
              ),
              subtitle: Text(
                firebase.appUser.faculty.toUpperCase(),
                style: normalText,
              ),
              leading: Icon(
                Icons.school_outlined,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text(
                "Batch",
                style: boldText,
              ),
              subtitle: Text(
                firebase.appUser.year.toString(),
                style: normalText,
              ),
              leading: Icon(
                Icons.date_range,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              title: Text(
                "Roll no.",
                style: boldText,
              ),
              subtitle: Text(
                firebase.appUser.roll.toString(),
                style: normalText,
              ),
              leading: Icon(
                Icons.format_list_numbered,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
          // ListTile(
          //   title: Text(
          //     "Level",
          //     style: boldText,
          //   ),
          //   subtitle:
          //       Text(firebase.appUser.level.toString().split("UserLevel.")[1]),
          //   leading: Icon(
          //     Icons.lock,
          //   ),
          // ),
          ListTile(
            title: Text(
              "Status",
              style: boldText,
            ),
            subtitle: Text(
              firebase.appUser.isVerified ? "Verified" : "Verification Pending",
              style: normalText,
            ),
            leading: Icon(
              firebase.appUser.isVerified
                  ? Icons.verified_user
                  : Icons.wifi_protected_setup_sharp,
              color: Theme.of(context).primaryColor,
            ),
          ),

          Divider(
            color: Theme.of(context).primaryColor,
          ),

          SizedBox(
            height: 30,
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(5),
          //   child: Container(
          //     margin: EdgeInsets.all(8),
          //     height: height,
          //     alignment: alignment,
          //     padding: padding ?? EdgeInsets.fromLTRB(20, 0, 20, 0),
          //     width: width ?? double.infinity,
          //     decoration: BoxDecoration(
          //       color: color ?? Theme.of(context).cardColor,
          //       borderRadius: radius ?? BorderRadius.circular(5),
          //     ),
          //     child: child,
          //   ),
          // ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xffA5A58D),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Contact department in case of any error in details.",
            style: tileBoldText,
          ),
        ),
      ),
    );
  }
}