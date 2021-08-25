import 'package:digishala/models/library_record.dart';
import 'package:digishala/screens/studentscreens/book_status.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyBookRecords extends StatefulWidget {
  final bool hasFilter;
  final String filter;
  final bool value;
  const MyBookRecords(
      {Key key, this.hasFilter = false, this.filter, this.value})
      : super(key: key);

  @override
  _MyBookRecordsState createState() => _MyBookRecordsState();
}

class _MyBookRecordsState extends State<MyBookRecords> {
  List<LibraryRecord> libraryRecords = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();
  }

  initAsync() async {
    if (widget.hasFilter) {
      var data =
          await firebase.getBooksRecordFiltered(widget.filter, widget.value);
      setState(() {
        libraryRecords = data;
      });
    } else {
      var data = await firebase.getBooksRecord();
      setState(() {
        libraryRecords = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Book Records"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: libraryRecords.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              color: libraryRecords[index].isVerified ? null : Colors.red,
              title: libraryRecords[index].bookName,
              trailing: libraryRecords[index].isReturned
                  ? Icon(Icons.verified)
                  : null,
              subtitle: libraryRecords[index].dueDate.isBefore(DateTime.now())
                  ? "Due date exceeded by " +
                      libraryRecords[index]
                          .dueDate
                          .difference(DateTime.now())
                          .inDays
                          .toString() +
                      " days"
                  : "Due on " +
                      DateFormat("yyyy-MM-dd")
                          .format(libraryRecords[index].dueDate),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        BookStatus(bookRecord: libraryRecords[index]),
                  ),
                );
              },
            );
          }),
    );
  }
}
