import 'package:digishala/screens/adminScreens/add_beacons.dart';
import 'package:digishala/screens/adminScreens/add_faculty.dart';
import 'package:digishala/screens/adminScreens/add_final_year.dart';
import 'package:digishala/screens/adminScreens/add_subject.dart';
import 'package:digishala/screens/adminScreens/assign_sub_screen.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          CustomTile(
            title: "Add Subject",
            subtitle: "To add a new subject",
            leading: Icon(
              Icons.subject,
            ),
            trailing: Icon(
              Icons.add_box,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddSubject())),
          ),
          Divider(),
          CustomTile(
            title: "Add Faculty",
            subtitle: "To add a new faculty",
            leading: Icon(
              Icons.subject,
            ),
            trailing: Icon(
              Icons.add_box,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddFaculty())),
          ),
          CustomTile(
            title: "Assign beacon to class",
            subtitle: "To assign beacon to class",
            leading: Icon(
              Icons.subject,
            ),
            trailing: Icon(
              Icons.add_box,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AddBeacons())),
          ),
          Divider(),
          CustomTile(
            title: "Set Current 5th year",
            subtitle: "a reference for the final year",
            leading: Icon(
              Icons.subject,
            ),
            trailing: Icon(
              Icons.add_box,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => FinalYear())),
          ),
          Divider(),
          CustomTile(
            title: "Assign subject to teacher",
            leading: Icon(
              Icons.subject,
            ),
            trailing: Icon(
              Icons.add_box,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AssignSubject())),
          ),
          Divider(),
        ],
      ),
    );
  }
}
