import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  const LeaveRequestScreen({Key key}) : super(key: key);

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  bool leaveState = firebase.appUser.isOnaLeave;
  AppUser user = firebase.appUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leave Request'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SwitchListTile(
                title: leaveState
                    ? Text(
                        'On Leave',
                        style: boldText,
                      )
                    : Text(
                        'Not On Leave',
                        style: boldText,
                      ),
                value: leaveState,
                onChanged: (bool val) {
                  setState(() {
                    leaveState = !leaveState;
                  });
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: "Save",
                onPress: () async {
                  user.isOnaLeave = leaveState;
                  user.docUpdate = DateTime.now().toString();
                  await firebase.updateProfile(user);

                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
