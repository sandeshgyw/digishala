import 'package:digishala/models/admin_request.dart';
import 'package:digishala/screens/adminScreens/admin_req_status.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class AllAdminRequests extends StatefulWidget {
  const AllAdminRequests({Key key}) : super(key: key);

  @override
  State<AllAdminRequests> createState() => _AllAdminRequestsState();
}

class _AllAdminRequestsState extends State<AllAdminRequests> {
  List<AdminRequest> adminRequets = [];
  @override
  void initState() {
    getAll();
    // TODO: implement initState
    super.initState();
  }

  getAll() async {
    var data = await firebase.getAllAdminRequest();
    setState(() {
      adminRequets = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Admin Requests'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return CustomTile(
            color: adminRequets[index].isReady ? Colors.green : Colors.red,
            title: adminRequets[index].userName,
            subtitle: adminRequets[index].request,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      AdminRequestStatus(adminReq: adminRequets[index])),
            ),
          );
        },
        itemCount: adminRequets.length,
      ),
    );
  }
}
