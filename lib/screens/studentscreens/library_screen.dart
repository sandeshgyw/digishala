import 'package:digishala/models/app_user.dart';
import 'package:digishala/screens/libraryscreens/verify_records.dart';
import 'package:digishala/screens/studentscreens/book_request.dart';
import 'package:digishala/screens/studentscreens/my_book_records.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_tile.dart';
import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Library"),
        ),
        body: ListView(
          children: [
            if (firebase.appUser.level == UserLevel.STUDENT)
              CustomTile(
                title: "Request a book",
                subtitle: "checkout",
                leading: Icon(
                  Icons.book,
                ),
                trailing: Icon(
                  Icons.add_box,
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LibraryCard())),
              ),
            CustomTile(
              title: "View all book records",
              leading: Icon(
                Icons.list,
              ),
              trailing: Icon(
                Icons.add_box,
              ),
              onTap: () {
                if (firebase.appUser.level == UserLevel.STUDENT)
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyBookRecords()));
                if (firebase.appUser.level == UserLevel.LIBRARIAN)
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VerifyBookRecords()));
              },
            ),
            CustomTile(
              title: "View unverified book records",
              leading: Icon(
                Icons.list,
              ),
              trailing: Icon(Icons.add_box),
              onTap: () {
                if (firebase.appUser.level == UserLevel.STUDENT)
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => MyBookRecords(
                                hasFilter: true,
                                filter: "isVerified",
                                value: false,
                              )));
                if (firebase.appUser.level == UserLevel.LIBRARIAN)
                  return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => VerifyBookRecords(
                                hasFilter: true,
                                filter: "isVerified",
                                value: false,
                              )));
              },
            )
          ],
        ));
  }
}
