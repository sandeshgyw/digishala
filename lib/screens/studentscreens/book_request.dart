import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LibraryCard extends StatefulWidget {
  const LibraryCard({Key key}) : super(key: key);

  @override
  _LibraryCardState createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  LibraryRecord libraryRecord = LibraryRecord(
      studentUid: firebase.appUser.uid, dateOfCheckout: DateTime.now());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    libraryRecord.studentUid = firebase.appUser.uid;
    libraryRecord.studentName = firebase.appUser.name;
    libraryRecord.studentFaculty = firebase.appUser.faculty;
    libraryRecord.studentRoll = firebase.appUser.roll;
    libraryRecord.dateOfCheckout = DateTime.now();
    libraryRecord.dueDate = DateTime.now().add(Duration(days: 90));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request a book"),
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
                          labelText: "Checkout Date",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        initialValue: DateFormat("yyyy-MM-dd")
                            .format(DateTime.now().add(Duration(days: 90))),
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
                          labelText: "Due Date",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
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
                          labelText: "Book Name",
                        ),
                        onChanged: (value) {
                          libraryRecord.bookName = value;
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
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
                          labelText: "Book Key",
                        ),
                        onChanged: (value) {
                          libraryRecord.bookKey = value;
                        },
                      ),
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
              await firebase.requestBook(libraryRecord);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
