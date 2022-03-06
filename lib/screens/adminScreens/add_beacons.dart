import 'package:digishala/constants/text_styles.dart';
import 'package:digishala/mixin/loading.dart';
import 'package:digishala/models/class_beacon.dart';
import 'package:digishala/services/firebase.dart';
import 'package:digishala/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddBeacons extends StatefulWidget {
  const AddBeacons({Key key}) : super(key: key);

  @override
  _AddBeaconsState createState() => _AddBeaconsState();
}

class _AddBeaconsState extends State<AddBeacons> with LoadingStateMixin {
  ClassBeacon classBeacon = ClassBeacon();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Beacon "),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: fieldText,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value == "") return "Mandatory Field";
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
                      Icons.book,
                    ),
                    labelText: "Class Name",
                  ),
                  onChanged: (value) {
                    classBeacon.className = value;
                  },
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  style: fieldText,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value == "") return "Mandatory Field";
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
                      Icons.book,
                    ),
                    labelText: "Beacon UUID",
                  ),
                  onChanged: (value) {
                    classBeacon.uuid = value;
                  },
                ),
              ),
            ),
            CustomButton(
              text: "Assign Beacon",
              loading: loading,
              onPress: () async {
                setLoading(true);
                await firebase.addBeacon(classBeacon);
                setLoading(false);
                Navigator.pop(context);
              },
              color: Color(0xff6B705C),
              margin: EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );
  }
}
