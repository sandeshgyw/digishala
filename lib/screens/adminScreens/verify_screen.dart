import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class VerifyScreen extends StatefulWidget {
  final AppUser user;
  const VerifyScreen({Key key, @required this.user}) : super(key: key);

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Student"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    widget.user.imageUrl == null
                        ? CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 82,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: widget.user.imageUrl == null
                                ? Text("Loading")
                                : CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundImage: NetworkImage(
                                          widget.user.imageUrl,
                                        ) ??
                                        AssetImage("assets/logoo.png"),
                                    radius: 80,
                                  ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.user.name ?? "",
                      style: boldText,
                    ),
                    Text(
                      widget.user.level.toString().split("UserLevel.")[1] ?? "",
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
                if (widget.user.level == UserLevel.STUDENT) ...[
                  ListTile(
                    title: Text(
                      "Faculty",
                      style: boldText,
                    ),
                    subtitle: Text(
                      widget.user.faculty.toUpperCase(),
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
                      widget.user.year.toString(),
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
                      widget.user.roll.toString(),
                      style: normalText,
                    ),
                    leading: Icon(
                      Icons.format_list_numbered,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
                ListTile(
                  title: Text(
                    "Status",
                    style: boldText,
                  ),
                  subtitle: Text(
                    widget.user.isVerified
                        ? "Verified"
                        : "Verification Pending",
                    style: normalText,
                  ),
                  leading: Icon(
                    widget.user.isVerified
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
              ],
            ),
          ),
          CustomButton(
            margin: EdgeInsets.all(8),
            text: "Verify",
            onPress: () async {
              await firebase.verifyUser(widget.user);
              Navigator.pop(context);
            },
          ),
          CustomButton(
            margin: EdgeInsets.all(8),
            text: "Reject",
            color: Colors.red,
            onPress: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
