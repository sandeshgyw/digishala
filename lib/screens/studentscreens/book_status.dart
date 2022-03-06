import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/models/app_user.dart';
import 'package:digishala/models/library_record.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookStatus extends StatefulWidget {
  final LibraryRecord bookRecord;
  const BookStatus({Key key, this.bookRecord}) : super(key: key);

  @override
  _BookStatusState createState() => _BookStatusState();
}

class _BookStatusState extends State<BookStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Record Detail"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    firebase.appUser.imageUrl == null
                        ? Center(child: CircularProgressIndicator())
                        : CircleAvatar(
                            radius: 82,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: firebase.appUser.imageUrl == null
                                ? Text("Loading")
                                : CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    backgroundImage: NetworkImage(
                                          firebase.appUser.imageUrl,
                                        ) ??
                                        AssetImage("assets/logoo.png"),
                                    radius: 80,
                                  ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.bookRecord.studentName ?? "",
                      style: boldText,
                    ),
                    Text(
                      widget.bookRecord.studentFaculty +
                              "/" +
                              widget.bookRecord.studentRoll.toString() ??
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
                    "Book Name",
                    style: boldText,
                  ),
                  subtitle: Text(
                    widget.bookRecord.bookName,
                    style: normalText,
                  ),
                  leading: Icon(
                    Icons.book,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Book Key",
                    style: boldText,
                  ),
                  subtitle: Text(
                    widget?.bookRecord?.bookKey ?? "",
                    style: normalText,
                  ),
                  leading: Icon(
                    Icons.vpn_key,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Checkout Date",
                    style: boldText,
                  ),
                  subtitle: Text(
                    DateFormat("yyyy-MM-dd")
                        .format(widget.bookRecord.dateOfCheckout),
                    style: normalText,
                  ),
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Due Date",
                    style: boldText,
                  ),
                  subtitle: Text(
                    DateFormat("yyyy-MM-dd").format(widget.bookRecord.dueDate),
                    style: normalText,
                  ),
                  leading: Icon(
                    Icons.date_range,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  title: Text(
                    "Book Returned",
                    style: boldText,
                  ),
                  subtitle: Text(
                    widget.bookRecord.isReturned.toString(),
                    style: normalText,
                  ),
                  leading: Icon(
                    Icons.keyboard_return,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (!widget.bookRecord.dueDate.isBefore(DateTime.now()))
                  ListTile(
                    title: Text(
                      "Fine",
                      style: boldText,
                    ),
                    subtitle: Text(
                      "Rs. 0",
                      style: normalText,
                    ),
                    leading: Icon(
                      Icons.money,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                if (widget.bookRecord.dueDate.isBefore(DateTime.now()) &&
                    !widget.bookRecord.isReturned)
                  ListTile(
                    title: Text(
                      "Fine",
                      style: boldText,
                    ),
                    subtitle: Text(
                      "Rs. " +
                          (widget.bookRecord.dueDate
                                      .difference(DateTime.now())
                                      .inDays *
                                  -1)
                              .toString(),
                      style: normalText,
                    ),
                    leading: Icon(
                      Icons.money,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ListTile(
                  title: Text(
                    "Status",
                    style: boldText,
                  ),
                  subtitle: Text(
                    widget.bookRecord.isVerified
                        ? "Verified"
                        : "Verification Pending",
                    style: normalText,
                  ),
                  leading: Icon(
                    widget.bookRecord.isVerified
                        ? Icons.verified_user
                        : Icons.wifi_protected_setup_sharp,
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
          if (firebase.appUser.level == UserLevel.LIBRARIAN &&
              widget.bookRecord.isVerified == false) ...[
            CustomButton(
                text: "Verify",
                margin: EdgeInsets.all(8),
                onPress: () async {
                  firebase.verifyBookRecord(widget.bookRecord);
                  Navigator.pop(context);
                }),
            CustomButton(
                color: Colors.red,
                text: "Reject",
                margin: EdgeInsets.all(8),
                onPress: () async {
                  await firebase.rejectBookRecord(widget.bookRecord);
                  Navigator.pop(context);
                })
          ] else if (widget.bookRecord.isReturned == false &&
              firebase.appUser.level == UserLevel.LIBRARIAN)
            CustomButton(
                text: "Accept Return",
                margin: EdgeInsets.all(8),
                onPress: () async {
                  firebase.acceptBookReturn(widget.bookRecord);
                  Navigator.pop(context);
                }),
        ],
      ),
    );
  }
}
