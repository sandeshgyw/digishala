import 'package:digishala/models/admin_request.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/screens/studentscreens/book_status.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyAdminRequests extends StatefulWidget {
  final bool hasFilter;
  final String filter;
  final bool value;
  const MyAdminRequests(
      {Key key, this.hasFilter = false, this.filter, this.value})
      : super(key: key);

  @override
  _MyAdminRequestsState createState() => _MyAdminRequestsState();
}

class _MyAdminRequestsState extends State<MyAdminRequests> {
  List<AdminRequest> adminRequests = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  initAsync() async {
    var data = await firebase.getMyAdminRequests(firebase.appUser);
    setState(() {
      adminRequests = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Admin Requests"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: adminRequests.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              color: adminRequests[index].isReady ? Colors.green : Colors.red,
              title: adminRequests[index].request,
              subtitle: DateFormat("yyyy-MM-dd")
                  .format(adminRequests[index].requestDate)
                  .toString(),
            );
          }),
    );
  }
}
