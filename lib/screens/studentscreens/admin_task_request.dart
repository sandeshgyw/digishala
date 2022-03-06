import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/admin_request.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminTaskRequest extends StatefulWidget {
  const AdminTaskRequest({Key key}) : super(key: key);

  @override
  _AdminTaskRequestState createState() => _AdminTaskRequestState();
}

class _AdminTaskRequestState extends State<AdminTaskRequest> {
  AdminRequest adminReq = AdminRequest()
    ..userId = firebase.appUser.uid
    ..year = firebase.appUser.year
    ..faculty = firebase.appUser.faculty
    ..year = firebase.appUser.year
    ..userName = firebase.appUser.name
    ..roll = firebase.appUser.roll.toString()
    ..requestDate = DateTime.now()
    ..isReady = false;

  List<String> requestTypes = [
    "Id Card Request",
    "Character Certificate Request",
    "Transcript Request",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Request"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: firebase.appUser.name,
                        enabled: false,
                        style: fieldText,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Mandatory Field";
                          return null;
                        },
                        decoration: new InputDecoration(
                          alignLabelWithHint: true,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30),
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: "Student Name",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: firebase.appUser.faculty,
                        enabled: false,
                        style: fieldText,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Mandatory Field";
                          return null;
                        },
                        decoration: new InputDecoration(
                          alignLabelWithHint: true,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30),
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: "Student Faculty",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: firebase.appUser.roll.toString(),
                        enabled: false,
                        style: fieldText,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Mandatory Field";
                          return null;
                        },
                        decoration: new InputDecoration(
                          alignLabelWithHint: true,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30),
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: "Student Roll",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue:
                            DateFormat("yyyy-MM-dd").format(DateTime.now()),
                        enabled: false,
                        style: fieldText,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value == "")
                            return "Mandatory Field";
                          return null;
                        },
                        decoration: new InputDecoration(
                          alignLabelWithHint: true,
                          border: new OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(30),
                            ),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                          ),
                          labelText: "Request Date",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropdownButtonFormField<String>(
                      style: fieldText,

                      validator: (value) {
                        if (value == null) return "Mandatory Field";
                        return null;
                      },
                      decoration: new InputDecoration(
                        alignLabelWithHint: true,
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(30),
                          ),
                        ),
                        filled: true,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        labelText: "Request Type",
                      ),
                      isExpanded: true,
                      // hint: Text("Select item"),
                      // value: user.level,
                      onChanged: (String value) {
                        setState(() {
                          adminReq.request = value;
                        });
                      },
                      items: requestTypes.map((String sub) {
                        return DropdownMenuItem<String>(
                            value: sub,
                            child: Text(
                              sub,
                            ));
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomButton(
            text: "Request",
            margin: EdgeInsets.all(8),
            onPress: () async {
              await firebase.adminRequest(adminReq);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
