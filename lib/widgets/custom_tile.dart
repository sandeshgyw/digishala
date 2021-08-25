import 'package:digishala/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CustomTile extends StatefulWidget {
  final Widget leading;
  final Widget trailing;
  final String title;
  final String subtitle;
  final bool isThreeLine;
  final Function onTap;
  final Color color;

  const CustomTile(
      {Key key,
      this.leading,
      this.trailing,
      this.title,
      this.subtitle,
      this.isThreeLine,
      this.onTap,
      this.color})
      : super(key: key);

  @override
  _CustomTileState createState() => _CustomTileState();
}

class _CustomTileState extends State<CustomTile> {
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
        tileColor: widget.color ?? Color(0xff868784),
        child: ListTile(
          leading: widget.leading,
          trailing: widget.trailing,
          title: Text(
            widget.title,
            style: tileBoldText,
          ),
          subtitle: Text(
            widget.subtitle ?? "",
            style: tileText,
          ),
          isThreeLine: widget.isThreeLine ?? false,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
