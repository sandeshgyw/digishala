import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/screens/studentscreens/book_status.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class VerifyBookRecords extends StatefulWidget {
  final bool hasFilter;
  final String filter;
  final bool value;
  const VerifyBookRecords(
      {Key key, this.hasFilter = false, this.filter, this.value})
      : super(key: key);

  @override
  _VerifyBookRecordsState createState() => _VerifyBookRecordsState();
}

class _VerifyBookRecordsState extends State<VerifyBookRecords> {
  List<LibraryRecord> libraryRecords = [];

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  initAsync() async {
    if (widget.hasFilter) {
      var data =
          await firebase.getAllBooksRecordFiltered(widget.filter, widget.value);
      setState(() {
        libraryRecords = data;
      });
    } else {
      var data = await firebase.getAllBooksRecord();
      setState(() {
        libraryRecords = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verify Records"),
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: libraryRecords.length,
          itemBuilder: (BuildContext context, int index) {
            return CustomTile(
              color: libraryRecords[index].isVerified ? null : Colors.red,
              title: libraryRecords[index].bookName,
              subtitle: libraryRecords[index].studentName,
              trailing: libraryRecords[index].isReturned
                  ? Icon(Icons.verified)
                  : Text(
                      libraryRecords[index].studentRoll.toString(),
                      style: tileBoldText,
                    ),
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
