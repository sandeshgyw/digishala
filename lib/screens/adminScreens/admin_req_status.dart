import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/admin_request.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminRequestStatus extends StatefulWidget {
  final AdminRequest adminReq;
  const AdminRequestStatus({Key key, this.adminReq}) : super(key: key);

  @override
  _AdminRequestStatusState createState() => _AdminRequestStatusState();
}

class _AdminRequestStatusState extends State<AdminRequestStatus> {
  AppUser _appUser;

  @override
  void initState() {
    getUser();
    // TODO: implement initState
    super.initState();
  }

  getUser() async {
    var data = await firebase.getUser(widget.adminReq.userId);
    setState(() {
      _appUser = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Detail"),
      ),
      body: _appUser?.imageUrl == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          _appUser.imageUrl == null
                              ? Center(child: CircularProgressIndicator())
                              : CircleAvatar(
                                  radius: 82,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: _appUser.imageUrl == null
                                      ? Text("Loading")
                                      : CircleAvatar(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          backgroundImage: NetworkImage(
                                                _appUser.imageUrl,
                                              ) ??
                                              AssetImage("assets/logoo.png"),
                                          radius: 80,
                                        ),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.adminReq.userName ?? "",
                            style: boldText,
                          ),
                          Text(
                            widget.adminReq.faculty +
                                    "/" +
                                    widget.adminReq.roll.toString() ??
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
                      ListTile(
                        title: Text(
                          "Request Type",
                          style: boldText,
                        ),
                        subtitle: Text(
                          widget.adminReq.request,
                          style: normalText,
                        ),
                        leading: Icon(
                          Icons.book,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Request Date",
                          style: boldText,
                        ),
                        subtitle: Text(
                          DateFormat("yyyy-MM-dd")
                              .format(widget.adminReq.requestDate),
                          style: normalText,
                        ),
                        leading: Icon(
                          Icons.check_circle_outline,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "isCompleted",
                          style: boldText,
                        ),
                        subtitle: Text(
                          widget.adminReq.isReady.toString(),
                          style: normalText,
                        ),
                        leading: Icon(
                          Icons.keyboard_return,
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
                if (widget.adminReq.isReady == false) ...[
                  CustomButton(
                      text: "Verify",
                      margin: EdgeInsets.all(8),
                      onPress: () async {
                        firebase.adminReqComplete(widget.adminReq);
                        Navigator.pop(context);
                      }),
                ]
              ],
            ),
    );
  }
}
