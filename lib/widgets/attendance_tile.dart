import 'package:digishala/constants/text_styles.dart';
import 'package:flutter/material.dart';

class AttendanceTile extends StatefulWidget {
  final Widget leading;
  final Widget trailing;
  final String title;
  final String subtitle;
  final bool isThreeLine;
  final Function onTap;

  const AttendanceTile({
    Key key,
    this.leading,
    this.trailing,
    this.title,
    this.subtitle,
    this.isThreeLine,
    this.onTap,
  }) : super(key: key);

  @override
  _AttendanceTileState createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTileTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        iconColor: Colors.white,
        tileColor: Color(0xff868784),
        child: ListTile(
          leading: widget.leading,
          trailing: widget.trailing,
          title: Text(
            widget.title,
            style: tileBoldText,
          ),
          subtitle: Text(
            widget.subtitle,
            style: tileText,
          ),
          isThreeLine: widget.isThreeLine ?? false,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
